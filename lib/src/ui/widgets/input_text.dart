import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final int? maxLength;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isClearText;
  final bool? readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function()? onEditingComplete;
  final Function()? onTap;
  String? errorText;
  InputText(
      {super.key,
      this.label,
      this.placeholder,
      this.maxLength,
      this.errorText,
      this.keyboardType,
      this.inputFormatters,
      this.controller,
      this.isClearText,
      this.prefixIcon,
      this.suffixIcon,
      this.readOnly,
      this.onEditingComplete,
      this.onTap});

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
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
          TextField(
              autocorrect: false,
              autofocus: true,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(72),
                  ),
                ),
                labelText: widget.placeholder,
                errorText: widget.errorText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.isClearText == true
                    ? IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () => widget.controller?.clear(),
                      )
                    : widget.suffixIcon,
              ),
              onEditingComplete: widget.onEditingComplete ?? () {},
              readOnly: widget.readOnly == true ? true : false,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              onTap: widget.onTap,
              onChanged: (value) {
                setState(() {
                  widget.errorText = null;
                });
              },
              style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
