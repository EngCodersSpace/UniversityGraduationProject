// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TypeAhead<T> extends StatefulWidget {
  TypeAhead({
    this.label,
    this.icon = const Icon(
      Icons.arrow_drop_down_outlined,
      color: Colors.white,
      size: 25,
    ),
    this.value,
    required this.items,
    this.width,
    this.height = 60,
    this.color = Colors.transparent,
    this.textStyle,
    this.menuTextStyle,
    this.menuColor = Colors.white,
    this.onSelected,
    this.includeAllOption = false,
    super.key,
  });

  final TextEditingController _textController = TextEditingController();
  String? label;
  Map<T, String> items;
  Color? color;
  TextStyle? textStyle;
  TextStyle? menuTextStyle;
  Icon icon;
  Color menuColor;
  double? width;
  double height;
  bool includeAllOption;

  void Function(T val, String item)? onSelected;
  T? value;

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
            if (widget.value != null) {
              if (widget.items.containsKey(widget.value)) {
                widget._textController.text = widget.items[widget.value]!;
              }
            }
          },
        ),
        Positioned(
          left: offset.dx,
          top: offset.dy + renderBox.size.height - 10,
          width: renderBox.size.width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 300,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: widget.menuColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)),
              ),
              child: Theme(
                data: ThemeData(
                    scrollbarTheme: ScrollbarThemeData(
                  thumbColor:
                      WidgetStateProperty.all(widget.menuTextStyle?.color),
                  trackColor: WidgetStateProperty.all(Colors.grey),
                )),
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: Radius.circular(24),
                  child: SingleChildScrollView(
                    child: Column(
                      children: widget.items.entries
                          .where((item) => item.value.toLowerCase().contains(
                              widget._textController.text.toLowerCase()))
                          .map((item) => ListTile(
                                title: Text(
                                  item.value,
                                  style: widget.menuTextStyle,
                                ),
                                onTap: () {
                                  widget.value = item.key;
                                  widget._textController.text = item.value;
                                  hideOverlay();
                                  if (widget.onSelected != null) {
                                    widget.onSelected!(item.key, item.value);
                                  }
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
  void didUpdateWidget( oldWidget) {
    if (widget.includeAllOption) {
      widget.items["all-option"] = "All";
    }
    if (widget.value != null) {
      if (widget.items.containsKey(widget.value)) {
        widget._textController.text = widget.items[widget.value]!;
      }
    }
    super.didUpdateWidget(oldWidget);
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
            controller: widget._textController,
            onTap: () {
              widget._textController.text = "";
              showOverlay(context);
            },
            onChanged: (e) {
              setState(() {
                if (overlayEntry == null) showOverlay(context);
                overlayEntry?.markNeedsBuild();
              });
            },
            style: widget.textStyle,
            textAlign: TextAlign.center,
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
