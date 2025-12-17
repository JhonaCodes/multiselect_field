import 'package:flutter/material.dart';

import 'package:multiselect_field/core/standard_multi_select_field.dart';
import 'package:multiselect_field/core/chip_multi_select_field.dart';

/// Base abstract class for MultiSelectField variants.
///
/// This class provides two variants:
/// - [MultiSelectField] (default) - Full multiselect field with chips display
/// - [MultiSelectField.chip] - Compact chip dropdown for space-constrained areas
///
/// Example usage:
/// ```dart
/// // Standard multiselect
/// MultiSelectField<Car>(
///   data: () => carChoices,
///   onSelect: (selected, isDefault) => print(selected),
/// )
///
/// // Chip dropdown variant
/// MultiSelectField<String>.chip(
///   label: 'Filter',
///   data: () => filterChoices,
///   onSelect: (selected, isDefault) => print(selected),
/// )
/// ```
abstract class MultiSelectField<T> extends StatefulWidget {
  /// Internal constructor for subclasses.
  @protected
  const MultiSelectField.internal({super.key});

  /// Creates a standard [MultiSelectField] with full selection display.
  ///
  /// This is the default variant that displays selected items as chips
  /// within the field area.
  const factory MultiSelectField({
    Key? key,
    required List<Choice<T>> Function() data,
    required void Function(List<Choice<T>> choiceList, bool isFromDefaultData)
    onSelect,
    Widget Function(bool isEmpty)? title,
    Widget? footer,
    Widget Function(Choice<T> choiceList)? singleSelectWidget,
    Widget Function(Choice<T> choiceList)? multiSelectWidget,
    bool cleanCurrentSelection,
    List<Choice<T>>? defaultData,
    bool isMandatory,
    bool singleSelection,
    bool useTextFilter,
    Decoration? decoration,
    double? menuWidth,
    double? menuHeight,
    bool menuWidthBaseOnContent,
    bool menuHeightBaseOnContent,
    TextStyle? textStyleSingleSelection,
    MenuStyle? menuStyle,
    Widget Function(bool menuState)? iconLeft,
    Widget Function(bool menuState)? iconRight,
    ButtonStyle? buttonStyle,
    Widget? itemMenuButton,
    TextStyle? titleMenuStyle,
    TextStyle? itemMenuStyle,
    String? label,
    TextStyle? textStyleLabel,
    bool selectAllOption,
    ItemColor? itemColor,
    ScrollbarConfig? scrollbarConfig,
  }) = StandardMultiSelectField<T>;

  /// Creates a compact chip-style [MultiSelectField].
  ///
  /// This variant displays as a small chip that opens a dropdown menu
  /// when tapped. Ideal for filter bars or space-constrained areas.
  ///
  /// The dropdown can contain either:
  /// - Auto-generated list from [data] (like standard MultiSelectField)
  /// - Custom [menuContent] widget for full flexibility
  ///
  /// Example with data:
  /// ```dart
  /// MultiSelectField<Status>.chip(
  ///   label: 'Status',
  ///   data: () => [
  ///     Choice('1', 'Active'),
  ///     Choice('2', 'Pending'),
  ///   ],
  ///   onSelect: (selected, _) => updateFilter(selected),
  /// )
  /// ```
  ///
  /// Example with custom content:
  /// ```dart
  /// MultiSelectField<String>.chip(
  ///   label: 'Date',
  ///   menuContent: Column(
  ///     children: [
  ///       RadioListTile(...),
  ///       DatePicker(...),
  ///     ],
  ///   ),
  ///   onSelect: (selected, _) => updateFilter(selected),
  /// )
  /// ```
  const factory MultiSelectField.chip({
    Key? key,
    required String label,
    List<Choice<T>> Function()? data,
    void Function(List<Choice<T>> choiceList, bool isFromDefaultData)? onSelect,
    List<Choice<T>>? defaultData,
    Widget? menuContent,
    Widget? menuHeader,
    Widget? menuFooter,
    ChipStyle? chipStyle,
    ChipMenuStyle? menuStyle,
    ChipSize? chipSize,
    VoidCallback? onMenuOpened,
    VoidCallback? onMenuClosed,
    bool enabled,
    Widget? leading,
    Widget? trailing,
    bool showDropdownIcon,
    bool singleSelection,
    bool selectAllOption,
    MenuController? controller,
    TextStyle? titleMenuStyle,
    TextStyle? itemMenuStyle,
    EdgeInsetsGeometry? titleMenuPadding,
  }) = ChipMultiSelectField<T>;
}

/// Represents a selectable choice item.
///
/// The [key] field serves dual purposes:
/// 1. Unique identification for validation and selection tracking
/// 2. Grouping: if [key] is null or empty, the choice acts as a group title
///
/// Example:
/// ```dart
/// List<Choice<Car>> choices = [
///   Choice(null, 'Sports Cars'),  // Group title
///   Choice('1', 'Ferrari', metadata: Car(...)),
///   Choice('2', 'Porsche', metadata: Car(...)),
///   Choice(null, 'SUVs'),  // Another group title
///   Choice('3', 'Range Rover', metadata: Car(...)),
/// ];
/// ```
class Choice<T> {
  final String? key;
  final String value;
  final T? metadata;

  const Choice(this.key, this.value, {this.metadata});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Choice &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value &&
          metadata == other.metadata;

  @override
  int get hashCode => Object.hash(key, value, metadata);
}

/// Color configuration for menu items.
class ItemColor {
  final Color? selected;
  final Color? hovered;
  final Color? unSelected;

  const ItemColor({this.selected, this.hovered, this.unSelected});
}

/// Configuration for scrollbar appearance in dropdown menus.
class ScrollbarConfig {
  final bool visible;
  final ScrollbarThemeData? themeData;

  const ScrollbarConfig({this.visible = true, this.themeData});

  factory ScrollbarConfig.preset({required String preset, Color? color}) {
    final effectiveColor = color ?? Colors.blue;

    switch (preset.toLowerCase()) {
      case 'thick':
        return ScrollbarConfig(
          visible: true,
          themeData: ScrollbarThemeData(
            thickness: WidgetStateProperty.all(12.0),
            thumbColor: WidgetStateProperty.all(effectiveColor),
            trackColor: WidgetStateProperty.all(
              effectiveColor.withValues(alpha: 0.2),
            ),
            radius: const Radius.circular(6.0),
            thumbVisibility: WidgetStateProperty.all(true),
            trackVisibility: WidgetStateProperty.all(true),
          ),
        );
      case 'thin':
        return ScrollbarConfig(
          visible: true,
          themeData: ScrollbarThemeData(
            thickness: WidgetStateProperty.all(4.0),
            thumbColor: WidgetStateProperty.all(
              effectiveColor.withValues(alpha: 0.8),
            ),
            trackColor: WidgetStateProperty.all(Colors.transparent),
            radius: const Radius.circular(2.0),
            thumbVisibility: WidgetStateProperty.all(false),
            trackVisibility: WidgetStateProperty.all(false),
          ),
        );
      case 'rounded':
        return ScrollbarConfig(
          visible: true,
          themeData: ScrollbarThemeData(
            thickness: WidgetStateProperty.all(8.0),
            thumbColor: WidgetStateProperty.all(effectiveColor),
            trackColor: WidgetStateProperty.all(
              effectiveColor.withValues(alpha: 0.15),
            ),
            radius: const Radius.circular(12.0),
            thumbVisibility: WidgetStateProperty.all(true),
            trackVisibility: WidgetStateProperty.all(true),
          ),
        );
      case 'hidden':
        return const ScrollbarConfig(visible: false);
      default:
        return ScrollbarConfig(
          visible: true,
          themeData: ScrollbarThemeData(
            thickness: WidgetStateProperty.all(6.0),
            thumbColor: WidgetStateProperty.all(
              effectiveColor.withValues(alpha: 0.7),
            ),
            trackColor: WidgetStateProperty.all(
              Colors.grey.withValues(alpha: 0.3),
            ),
            radius: const Radius.circular(3.0),
          ),
        );
    }
  }

  ScrollbarConfig copyWith({bool? visible, ScrollbarThemeData? themeData}) {
    return ScrollbarConfig(
      visible: visible ?? this.visible,
      themeData: themeData ?? this.themeData,
    );
  }
}

/// Size configuration for proportional chip scaling.
///
/// Use predefined sizes [small], [medium], [large] or create custom sizes.
/// All dimensions are proportionally scaled for visual consistency.
///
/// Example:
/// ```dart
/// MultiSelectField<String>.chip(
///   label: 'Filter',
///   chipSize: ChipSize.small,
///   // ...
/// )
/// ```
class ChipSize {
  /// Font size for the chip label.
  final double fontSize;

  /// Icon size for the dropdown arrow.
  final double iconSize;

  /// Padding inside the chip.
  final EdgeInsets padding;

  /// Border radius of the chip.
  final double borderRadius;

  /// Spacing between label and icon.
  final double spacing;

  const ChipSize({
    required this.fontSize,
    required this.iconSize,
    required this.padding,
    required this.borderRadius,
    this.spacing = 4,
  });

  /// Extra small chip - minimal footprint.
  static const extraSmall = ChipSize(
    fontSize: 11,
    iconSize: 14,
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    borderRadius: 12,
    spacing: 2,
  );

  /// Small chip - compact size.
  static const small = ChipSize(
    fontSize: 12,
    iconSize: 16,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    borderRadius: 14,
    spacing: 3,
  );

  /// Medium chip - default size.
  static const medium = ChipSize(
    fontSize: 14,
    iconSize: 20,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: 20,
    spacing: 4,
  );

  /// Large chip - prominent size.
  static const large = ChipSize(
    fontSize: 16,
    iconSize: 24,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    borderRadius: 24,
    spacing: 6,
  );

  /// Extra large chip - maximum visibility.
  static const extraLarge = ChipSize(
    fontSize: 18,
    iconSize: 28,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    borderRadius: 28,
    spacing: 8,
  );
}

/// Style configuration for chip appearance.
class ChipStyle {
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? borderColor;
  final Color? activeBorderColor;
  final Color? textColor;
  final Color? activeTextColor;
  final Color? iconColor;
  final Color? activeIconColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final IconData? icon;
  final double? iconSize;

  const ChipStyle({
    this.backgroundColor,
    this.activeBackgroundColor,
    this.borderColor,
    this.activeBorderColor,
    this.textColor,
    this.activeTextColor,
    this.iconColor,
    this.activeIconColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.icon,
    this.iconSize,
  });

  /// Creates a chip style with the given primary color.
  factory ChipStyle.withColor(Color primaryColor) {
    return ChipStyle(
      backgroundColor: Colors.transparent,
      activeBackgroundColor: primaryColor.withValues(alpha: 0.1),
      borderColor: Colors.grey.withValues(alpha: 0.4),
      activeBorderColor: primaryColor,
      textColor: Colors.grey.shade700,
      activeTextColor: primaryColor,
      iconColor: Colors.grey.shade600,
      activeIconColor: primaryColor,
    );
  }

  /// Creates a chip style with color and size combined.
  factory ChipStyle.styled({
    required Color color,
    ChipSize size = ChipSize.medium,
  }) {
    return ChipStyle(
      backgroundColor: Colors.transparent,
      activeBackgroundColor: color.withValues(alpha: 0.1),
      borderColor: Colors.grey.withValues(alpha: 0.4),
      activeBorderColor: color,
      textColor: Colors.grey.shade700,
      activeTextColor: color,
      iconColor: Colors.grey.shade600,
      activeIconColor: color,
      padding: size.padding,
      borderRadius: BorderRadius.circular(size.borderRadius),
      iconSize: size.iconSize,
      textStyle: TextStyle(fontSize: size.fontSize),
    );
  }
}

/// Style configuration for chip dropdown menu.
class ChipMenuStyle {
  final double? width;
  final double? height;
  final MenuStyle? menuStyle;
  final Offset? offset;

  const ChipMenuStyle({this.width, this.height, this.menuStyle, this.offset});
}

/// Utility function to compare two Choice lists.
bool isSameData<T>(List<Choice<T>> list1, List<Choice<T>> list2) {
  if (list1.length != list2.length) return false;
  return Set.from(list1).containsAll(list2);
}
