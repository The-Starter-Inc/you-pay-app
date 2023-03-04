import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropDownText extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final List<dynamic>? items;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isClearText;
  final bool? readOnly;
  final TextEditingController? controller;
  final Function()? onEditingComplete;
  String? errorText;
  DropDownText(
      {super.key,
      this.label,
      this.placeholder,
      this.controller,
      this.items,
      this.errorText,
      this.keyboardType,
      this.inputFormatters,
      this.isClearText,
      this.readOnly,
      this.onEditingComplete});

  @override
  State<DropDownText> createState() => _DropDownTextState();
}

class _DropDownTextState extends State<DropDownText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (widget.label != null) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(widget.label!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                          ))
                ],
              ),
            )
          ],
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.errorText != null
                          ? Colors.red.shade800
                          : Colors.black45),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton(
                    hint: Text(widget.placeholder!,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),
                    value: widget.controller!.text.isNotEmpty
                        ? widget.controller!.text
                        : null,
                    autofocus: true,
                    isExpanded: true,
                    underline: Container(),
                    items: <DropdownMenuItem>[
                      ...widget.items!.map((item) => DropdownMenuItem(
                          value: "${item.id}",
                          child: Text(
                            item.name,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          )))
                    ],
                    style: const TextStyle(color: Colors.black54),
                    onChanged: (value) {
                      setState(() {
                        widget.controller!.text = "$value";
                        widget.errorText = null;
                      });
                    },
                  ))),
          if (widget.errorText != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Text(widget.errorText!,
                      style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis))
                ],
              ),
            )
        ],
      ),
    );
  }
}
