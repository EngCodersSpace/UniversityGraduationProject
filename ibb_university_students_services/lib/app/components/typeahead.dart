import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

class TypeAhead extends StatefulWidget {
  TypeAhead({
    required this.textController,
    this.label,
    required this.items,
    required this.context,
    this.color = Colors.blue,
    this.menuColor = Colors.white,
    super.key,
  });

  TextEditingController textController;
  String? label;
  List items;
  Color color;
  Color menuColor;
  BuildContext context;
  final RxBool _isDropdownOpen = false.obs;
  OverlayEntry? overlayEntry;


  void showOverlay() {
    if (overlayEntry != null) return; // Prevent multiple overlays
    final overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    overlayEntry = OverlayEntry(
      builder: (context) =>
          Positioned(
            left: offset.dx,
            top: offset.dy - 150, // Moves dropdown **above** the text field
            width: renderBox.size.width,
            child: Material(
              elevation: 4.0,
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  color: menuColor,
                  border: Border.all(color: Colors.grey),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: items
                        .where((item) =>
                        item
                            .toLowerCase()
                            .contains(textController.text.toLowerCase()))
                        .map((item) =>
                        ListTile(
                          title: Text(item),
                          onTap: () {
                            textController.text = item;
                            _isDropdownOpen.value = false;
                          },
                        ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry!);
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  State<TypeAhead> createState() => _TypeAheadState();
}

class _TypeAheadState extends State<TypeAhead> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.textController,
          decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.color,),
                borderRadius: const BorderRadius.all(Radius.circular(25))),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: widget.color),
              borderRadius: const BorderRadius.all(Radius.circular(30)),

            ),
            prefixIconColor: widget.color,
            iconColor: widget.color,
            labelText: widget.label,
            labelStyle: AppTextStyles.highlightStyle(),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_outlined, color: widget.color,),
          ),),
      ],
    );
  }
}

