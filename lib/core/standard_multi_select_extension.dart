import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';


/// Extends [BuildContext] with style resolution methods for
/// [StandardMultiSelectField] menu items.
///
/// Centralizes all style-related decisions so the widget only
/// consumes the final resolved values without embedding conditional logic.
extension MultiSelectStyleExtension on BuildContext {

  /// Default color scheme applied to menu items when no custom [ItemColor]
  /// is provided. These values provide subtle visual feedback without
  /// competing with the app's primary theme.
  ItemColor get _defaultItemColor => ItemColor(
    selected: Color(0x338448E1),
    unSelected: Colors.transparent,
    hovered: Color(0x1E8448E1),
  );

  /// Resolves which [ButtonStyle] to apply to a menu item.
  ///
  /// Priority order (first match wins):
  /// 1. [selectedItemButtonStyle] — if the item is selected and not a group title
  /// 2. [buttonStyle] — user-provided global style for all items
  /// 3. Default built-in style with dynamic background color resolution
  ///
  /// This separation allows users to customize selected items independently
  /// from the rest, which was not possible when a single [buttonStyle]
  /// controlled every item.
  ButtonStyle resolveItemStyle({
    required bool isGroupingTitle,
    required bool isSelected,
    required bool isMobile,
    ButtonStyle? selectedItemButtonStyle,
    ButtonStyle? buttonStyle,
    ItemColor? itemColor,
  }) {
    return switch ((isSelected && !isGroupingTitle, selectedItemButtonStyle, buttonStyle)) {
      (true, final style?, _) => style,
      (_, _, final style?) => style,
      _ => ButtonStyle(
        alignment: Alignment.centerLeft,
        elevation: const WidgetStatePropertyAll<double>(7.5),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith((state) {
          return resolveItemBackgroundColor(
            widgetState: state,
            isGroupingTitle: isGroupingTitle,
            isSelected: isSelected,
            isMobile: isMobile,
            itemColor: itemColor,
          );
        }),
      ),
    };
  }

  /// Resolves the background color for a menu item based on its current
  /// widget state (hovered, pressed, etc.) and selection status.
  ///
  /// Returns:
  /// - [ItemColor.hovered] when the item is hovered on mobile
  /// - [ItemColor.selected] when the item is selected and not a group title
  /// - [ItemColor.unSelected] as the default fallback
  ///
  /// Falls back to [defaultItemColor] when no custom color is specified.
  Color? resolveItemBackgroundColor({
    required Set<WidgetState> widgetState,
    required bool isGroupingTitle,
    required bool isSelected,
    required bool isMobile,
    ItemColor? itemColor,
  }) {
    final colors = itemColor ?? _defaultItemColor;
    return switch ((widgetState.contains(WidgetState.hovered) && isMobile, isSelected && !isGroupingTitle)) {
      (true, _) => colors.hovered ?? _defaultItemColor.hovered,
      (_, true) => colors.selected ?? _defaultItemColor.selected,
      _ => colors.unSelected ?? _defaultItemColor.unSelected,
    };
  }
}
