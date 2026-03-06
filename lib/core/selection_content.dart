import 'package:flutter/material.dart';

import 'package:multiselect_field/core/multi_select.dart';

/// Shared selection content widget used by all MultiSelectField variants.
///
/// Renders a list of selectable items with support for:
/// - Single or multi selection (checkbox/radio)
/// - Group titles
/// - Select all option
/// - Custom content override via [menuContent]
class SelectionContent<T> extends StatelessWidget {
  final Widget? menuContent;
  final List<Choice<T>> Function()? data;
  final bool selectAllOption;
  final bool singleSelection;
  final bool selectAllActive;
  final List<Choice<T>> selectedChoices;
  final TextStyle? titleMenuStyle;
  final TextStyle? itemMenuStyle;
  final EdgeInsetsGeometry? titleMenuPadding;
  final void Function(Choice<T>) onToggleSelection;
  final VoidCallback onToggleSelectAll;
  final bool Function(Choice<T>) isSelected;

  const SelectionContent({
    super.key,
    this.menuContent,
    this.data,
    required this.selectAllOption,
    required this.singleSelection,
    required this.selectAllActive,
    required this.selectedChoices,
    this.titleMenuStyle,
    this.itemMenuStyle,
    this.titleMenuPadding,
    required this.onToggleSelection,
    required this.onToggleSelectAll,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (menuContent != null) return menuContent!;
    if (data == null) return const SizedBox.shrink();

    final choices = data!();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (selectAllOption && choices.isNotEmpty)
          ListTile(
            leading: Checkbox(
              value: selectAllActive,
              onChanged: (_) => onToggleSelectAll(),
            ),
            title: const Text('All'),
            dense: true,
            onTap: onToggleSelectAll,
          ),
        ...choices.where((c) => c.value.isNotEmpty).map((choice) {
          final isGroupTitle = choice.key == null || choice.key!.isEmpty;

          if (isGroupTitle) {
            return Padding(
              padding:
                  titleMenuPadding ??
                  const EdgeInsets.only(left: 16, top: 12, bottom: 4),
              child: Text(
                choice.value,
                style:
                    titleMenuStyle ??
                    Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            );
          }

          final itemStyle =
              itemMenuStyle ?? Theme.of(context).textTheme.bodyMedium;
          final selected = isSelected(choice);

          if (singleSelection) {
            return ListTile(
              leading: Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? Theme.of(context).primaryColor : null,
              ),
              title: Text(choice.value, style: itemStyle),
              dense: true,
              onTap: () => onToggleSelection(choice),
            );
          }

          return ListTile(
            leading: Checkbox(
              value: selected,
              onChanged: (_) => onToggleSelection(choice),
            ),
            title: Text(choice.value, style: itemStyle),
            dense: true,
            onTap: () => onToggleSelection(choice),
          );
        }),
      ],
    );
  }
}
