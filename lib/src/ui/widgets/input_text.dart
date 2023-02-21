import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final bool? isClearText;
  final bool? readOnly;
  final Function()? onEditingComplete;
  const InputText(
      {super.key,
      this.label,
      this.placeholder,
      this.controller,
      this.isClearText,
      this.readOnly,
      this.onEditingComplete});

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
              margin: const EdgeInsets.all(16),
              child: Text(widget.label!,
                  style: const TextStyle(color: Colors.black54)),
            )
          ],
          TextField(
              autocorrect: false,
              autofocus: true,
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(72),
                  ),
                ),
                labelText: widget.placeholder,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: widget.isClearText == true
                    ? IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () => widget.controller?.clear(),
                      )
                    : null,
              ),
              keyboardType: TextInputType.emailAddress,
              onEditingComplete: widget.onEditingComplete ?? () {},
              readOnly: widget.readOnly == true ? true : false,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
