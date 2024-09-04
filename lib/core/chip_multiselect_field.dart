import 'package:flutter/material.dart';

@protected
final class ChipMultiselectField extends StatelessWidget {
  final String title;
  final void Function() onDeleted;
  const ChipMultiselectField(
      {super.key, required this.title, required this.onDeleted});
  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.all(7),
      label: Text(title, style: Theme.of(context).textTheme.labelLarge),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            style: BorderStyle.solid,
            width: 0.5,
            strokeAlign: 0.5),
      ),
      deleteIcon: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.close,
          size: 15,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      onDeleted: onDeleted,
    );
  }
}
