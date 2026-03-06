import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';

/// Extends [BuildContext] with style resolution methods for
/// [ChipMultiSelectField] menu items.
///
/// Centralizes all style-related decisions (colors, dimensions, label)
/// so the widget's build method only consumes resolved values
/// without embedding conditional logic.
extension ChipMultiSelectStyleExtension on BuildContext {
  /// Resolves the chip's visual colors based on its open/closed state.
  ///
  /// When the menu is open, active variants take priority.
  /// Falls back to inactive variants, then to sensible defaults.
  ({Color background, Color border, Color? text, Color icon})
  resolveChipColors({required bool isOpen, required ChipStyle chipStyle}) {
    final theme = Theme.of(this);

    return isOpen
        ? (
            background:
                chipStyle.activeBackgroundColor ??
                chipStyle.backgroundColor ??
                Colors.transparent,
            border:
                chipStyle.activeBorderColor ??
                chipStyle.borderColor ??
                Colors.grey.withValues(alpha: 0.4),
            text:
                chipStyle.activeTextColor ??
                chipStyle.textColor ??
                theme.textTheme.labelLarge?.color,
            icon:
                chipStyle.activeIconColor ??
                chipStyle.iconColor ??
                Colors.grey.shade600,
          )
        : (
            background: chipStyle.backgroundColor ?? Colors.transparent,
            border: chipStyle.borderColor ?? Colors.grey.withValues(alpha: 0.4),
            text: chipStyle.textColor ?? theme.textTheme.labelLarge?.color,
            icon: chipStyle.iconColor ?? Colors.grey.shade600,
          );
  }

  /// Resolves the chip's dimensions by combining [ChipStyle] overrides
  /// with [ChipSize] defaults.
  ///
  /// [ChipStyle] properties take priority when set; otherwise
  /// [ChipSize] provides proportionally scaled defaults.
  ({
    EdgeInsetsGeometry padding,
    BorderRadius borderRadius,
    double iconSize,
    double fontSize,
    double spacing,
  })
  resolveChipDimensions({
    required ChipStyle chipStyle,
    required ChipSize chipSize,
  }) {
    return (
      padding: chipStyle.padding ?? chipSize.padding,
      borderRadius:
          chipStyle.borderRadius ??
          BorderRadius.circular(chipSize.borderRadius),
      iconSize: chipStyle.iconSize ?? chipSize.iconSize,
      fontSize: chipStyle.textStyle?.fontSize ?? chipSize.fontSize,
      spacing: chipSize.spacing,
    );
  }

  /// Resolves the display label shown on the chip.
  ///
  /// - No selection → original [label]
  /// - Single selection → the selected item's value
  /// - Multi selection → "[label] (count)"
  String resolveChipDisplayLabel<T>({
    required String label,
    required List<Choice<T>> selectedChoices,
    required bool singleSelection,
    required bool hasData,
  }) {
    if (selectedChoices.isEmpty || !hasData) return label;

    return singleSelection
        ? selectedChoices.first.value
        : '$label (${selectedChoices.length})';
  }
}
