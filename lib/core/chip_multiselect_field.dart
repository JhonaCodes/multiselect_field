import 'package:flutter/material.dart';

/// A custom [ChipMultiselectField] widget that displays a selectable chip with a delete icon.
///
/// This widget is intended to be used in a multi-select field where each selected item
/// is represented as a chip. The chip displays a title and includes a delete icon that
/// triggers an action when pressed.
///
/// The [title] parameter is required and is used as the text inside the chip.
/// The [onDeleted] parameter is required and is the callback function that is executed
/// when the delete icon is pressed.
///
/// Example usage:
/// ```dart
/// ChipMultiselectField(
///   title: 'Selected Item',
///   onDeleted: () {
///     // Handle deletion
///   },
/// )
/// ```
@protected
final class ChipMultiselectField extends StatelessWidget {
  /// The title text displayed inside the chip.
  final String title;

  /// Callback function triggered when the delete icon is pressed.
  final void Function() onDeleted;

  /// Creates a [ChipMultiselectField] widget.
  ///
  /// The [title] and [onDeleted] parameters are required.
  const ChipMultiselectField({
    super.key,
    required this.title,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.all(7),
      label: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: Colors.grey.withValues(alpha: 255 * 0.4),
          style: BorderStyle.solid,
          width: 0.5,
          strokeAlign: 0.5,
        ),
      ),
      deleteIcon: Align(
        alignment: Alignment.center,
        child: Icon(Icons.close,
            size: 15, color: Colors.grey.withValues(alpha: 255 * 0.7)),
      ),
      onDeleted: onDeleted,
    );
  }
}
