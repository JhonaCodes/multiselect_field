import 'package:flutter/material.dart';

import 'package:multiselect_field/core/multi_select.dart';

/// Extension for resolving bottom sheet style properties.
extension BottomSheetMultiSelectStyleExtension on BuildContext {
  /// Resolves the maximum height for the bottom sheet.
  double resolveBottomSheetMaxHeight({BottomSheetStyle? style}) {
    final screenHeight = MediaQuery.of(this).size.height;
    if (style?.fixedHeight != null) return style!.fixedHeight!;
    return screenHeight * (style?.maxHeightFraction ?? 0.6);
  }

  /// Resolves the border radius for the bottom sheet.
  BorderRadius resolveBottomSheetBorderRadius({BottomSheetStyle? style}) {
    return style?.borderRadius ??
        const BorderRadius.vertical(top: Radius.circular(16));
  }

  /// Resolves the background color for the bottom sheet.
  Color resolveBottomSheetBackgroundColor({BottomSheetStyle? style}) {
    return style?.backgroundColor ?? Theme.of(this).scaffoldBackgroundColor;
  }
}
