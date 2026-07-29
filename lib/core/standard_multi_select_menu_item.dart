import 'package:flutter/material.dart';

import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/standard_multi_select_extension.dart';

/// Single menu entry rendered inside the [StandardMultiSelectField] dropdown.
///
/// Extracted to keep the parent build method readable; receives only the
/// resolved values it needs and delegates selection back via [onTap].
class StandardMultiSelectMenuItem<T> extends StatelessWidget {
  final Choice<T> result;
  final bool isGroupingTitle;
  final bool isSelected;
  final double maxWidth;
  final bool menuWidthBaseOnContent;
  final EdgeInsetsGeometry? itemPadding;
  final EdgeInsetsGeometry? selectedItemPadding;
  final bool closeOnActivate;
  final Key? itemKey;
  final bool showSelectedTick;
  final bool selectAllOption;
  final ButtonStyle? buttonStyle;
  final ButtonStyle? selectedItemButtonStyle;
  final bool mergeSelectedStyle;
  final ItemColor? itemColor;
  final Color? pressedColor;

  /// When `true`, a hairline [Divider] of [dividerColor] is drawn directly
  /// above this row. The caller decides this so grouping titles never receive
  /// one; the item itself only renders what it is told.
  final bool showTopDivider;

  /// Color of the top divider. Only used when [showTopDivider] is `true`.
  final Color? dividerColor;

  final bool isMobile;
  final TextStyle? titleMenuStyle;
  final TextStyle? itemMenuStyle;

  /// Merged onto the label style when this row is selected (not a grouping
  /// title). `null` leaves the selected label identical to unselected rows.
  final TextStyle? selectedItemMenuStyle;

  final Widget Function(Choice<T> choice)? itemMenuButton;
  final Widget? Function(Choice<T> choice, bool isSelected)? leadingIconBuilder;
  final Widget? Function(Choice<T> choice, bool isSelected)?
  trailingIconBuilder;
  final VoidCallback? onTap;

  const StandardMultiSelectMenuItem({
    super.key,
    required this.result,
    required this.isGroupingTitle,
    required this.isSelected,
    required this.maxWidth,
    required this.menuWidthBaseOnContent,
    required this.itemPadding,
    required this.selectedItemPadding,
    required this.closeOnActivate,
    required this.itemKey,
    required this.showSelectedTick,
    required this.selectAllOption,
    required this.buttonStyle,
    required this.selectedItemButtonStyle,
    required this.mergeSelectedStyle,
    required this.itemColor,
    this.pressedColor,
    this.showTopDivider = false,
    this.dividerColor,
    required this.isMobile,
    required this.titleMenuStyle,
    required this.itemMenuStyle,
    this.selectedItemMenuStyle,
    required this.itemMenuButton,
    required this.onTap,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
  });

  /// Resolves the label text style for this row. Grouping titles use
  /// [titleMenuStyle]; option rows use [itemMenuStyle], with
  /// [selectedItemMenuStyle] merged on top when the row is selected.
  TextStyle? _labelStyle(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final base = itemMenuStyle ?? theme.labelMedium;
    return switch ((isGroupingTitle, isSelected, selectedItemMenuStyle)) {
      (true, _, _) => titleMenuStyle ?? theme.titleMedium,
      (false, true, final selected?) => base?.merge(selected) ?? selected,
      _ => base,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: menuWidthBaseOnContent ? null : maxWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showTopDivider)
            Divider(
              height: 1,
              thickness: 1,
              indent: 12,
              endIndent: 12,
              color: dividerColor,
            ),
          Padding(
            padding: (isSelected && selectedItemPadding != null)
                ? selectedItemPadding!
                : itemPadding ?? EdgeInsets.zero,
            child: MenuItemButton(
              closeOnActivate: closeOnActivate,
              key: itemKey,
              trailingIcon:
                  trailingIconBuilder?.call(result, isSelected) ??
                  switch ((
                    showTick: showSelectedTick,
                    selectAll: selectAllOption,
                    isSelected: isSelected,
                  )) {
                    (showTick: true, selectAll: false, isSelected: true) =>
                      const Icon(Icons.check, color: Colors.green, size: 12),
                    _ => null,
                  },
              leadingIcon:
                  leadingIconBuilder?.call(result, isSelected) ??
                  (selectAllOption && !isGroupingTitle
                      ? Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: isSelected
                              ? const Icon(Icons.check_box, color: Colors.green)
                              : const Icon(Icons.check_box_outline_blank),
                        )
                      : null),
              style: context.resolveItemStyle(
                isGroupingTitle: isGroupingTitle,
                isSelected: isSelected,
                isMobile: isMobile,
                selectedItemButtonStyle: selectedItemButtonStyle,
                mergeSelectedStyle: mergeSelectedStyle,
                buttonStyle: buttonStyle,
                itemColor: itemColor,
                pressedColor: pressedColor,
              ),
              onPressed: isGroupingTitle ? null : onTap,
              child: switch (itemMenuButton) {
                null => Padding(
                  padding: EdgeInsets.only(left: isGroupingTitle ? 0 : 10),
                  child: Text(result.value, style: _labelStyle(context)),
                ),
                _ => itemMenuButton!(result),
              },
            ),
          ),
        ],
      ),
    );
  }
}
