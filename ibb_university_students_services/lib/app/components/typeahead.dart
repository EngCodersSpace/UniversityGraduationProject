// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

class TypeAhead extends StatefulWidget {
  TypeAhead({
    required this.textController,
    this.label,
    this.icon = const Icon(
      Icons.arrow_drop_down_outlined,
      color: Colors.white,
      size: 25,
    ),
    required this.items,
    this.width,
    this.height = 60,
    this.color = Colors.transparent,
    this.textStyle,
    this.menuTextStyle,
    this.menuColor = Colors.white,
    super.key,
  });

  TextEditingController textController;
  String? label;
  List items;
  Color? color;
  TextStyle? textStyle;
  TextStyle? menuTextStyle;
  Icon icon;
  Color menuColor;
  double? width;
  double height;

  @override
  State<TypeAhead> createState() => _TypeAheadState();
}

class _TypeAheadState extends State<TypeAhead> {
  OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    final overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    overlayEntry = OverlayEntry(
      builder: (context) => Stack(children: [
        GestureDetector(
          onTap: () {
            hideOverlay();
          },
        ),
        Positioned(
          left: offset.dx,
          top: offset.dy + renderBox.size.height-10,
          width: renderBox.size.width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: widget.menuColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)),
              ),
              child: Theme(
                data: ThemeData(
                    scrollbarTheme: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.all(widget.menuTextStyle?.color),
                  // Set the thumb color
                  radius: Radius.circular(
                      10), // Optional: Set the radius to make the scrollbar thumb rounded
                )),
                child: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      children: widget.items
                          .where((item) => item.toLowerCase().contains(
                              widget.textController.text.toLowerCase()))
                          .map((item) => ListTile(
                                title: Text(
                                  item,
                                  style: widget.menuTextStyle,
                                ),
                                onTap: () {
                                  widget.textController.text = item;
                                  hideOverlay();
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );

    overlay.insert(overlayEntry!);
  }

  void hideOverlay() {
    setState(() {
      overlayEntry?.remove();
      overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: TextFormField(
            controller: widget.textController,
            onTap: () {
              showOverlay(context);
            },
            onChanged: (e) {
              setState(() {
                if (overlayEntry == null) showOverlay(context);
                overlayEntry?.markNeedsBuild();
                widget.textController.text = e;
              });
            },
            style: widget.textStyle,
            decoration: InputDecoration(
              fillColor: widget.color,
              filled: true,
              isDense: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: widget.label,
              labelStyle: widget.textStyle,
              suffixIcon: widget.icon,
            ),
          ),
        ),
      ],
    );
  }
}
