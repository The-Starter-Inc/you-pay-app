import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';

class FloatButton extends StatefulWidget {
  final String title;
  final String? icon;
  bool? selected;
  final Function? onSelected;

  FloatButton(
      {Key? key,
      required this.title,
      this.icon,
      this.selected,
      this.onSelected})
      : super(key: key);

  @override
  State<FloatButton> createState() => _FloatButtonState();
}

class _FloatButtonState extends State<FloatButton> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.selected == true ? AppColor.primaryLight : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.selected = widget.selected == true ? false : true;
            if (widget.onSelected != null) {
              widget.onSelected!(widget.selected);
            }
          });
        },
        child: Padding(
          padding: widget.icon != null
              ? const EdgeInsets.fromLTRB(0, 5, 16, 5)
              : const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.icon != null) ...[
                CircleAvatar(backgroundImage: AssetImage(widget.icon!)),
                const SizedBox(width: 5),
              ],
              Text(
                widget.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black87),
              ),
              if (widget.selected == true) ...[
                const SizedBox(width: 5),
                const Icon(Icons.check, size: 18, color: Colors.black87)
              ]
            ],
          ),
        ),
      ),
    );
  }
}
