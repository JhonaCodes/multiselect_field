import 'package:flutter/material.dart';

/// A custom [SearchMultiselectField] widget that provides a search bar
/// with specific styling for use in multi-select fields.
///
/// This widget is designed to handle search input in a multi-select context,
/// allowing users to type and filter options. It includes mobile-specific
/// adjustments for better usability on smaller screens.
///
/// The [textController] parameter manages the text input in the search bar.
/// The [isMobile] parameter adjusts the height of the search bar based on the
/// device type.
/// The [onTap] parameter is a callback that triggers when the search bar is tapped.
/// The [onChange] parameter handles the changes in the search input.
/// The [focusNodeTextField] parameter manages the focus state of the search bar.
///
/// Example usage:
/// ```dart
/// SearchMultiselectField(
///   textController: myTextController,
///   isMobile: true,
///   onTap: () {
///     // Handle tap
///   },
///   focusNodeTextField: myFocusNode,
///   onChange: (value) {
///     // Handle text change
///   },
/// )
/// ```
@protected
final class SearchMultiselectField extends StatelessWidget {
  /// Indicates whether the device is mobile, adjusting the height of the search bar.
  final bool isMobile;

  /// Manages the focus state of the search bar.
  final FocusNode focusNodeTextField;

  /// Callback function triggered when the search bar is tapped.
  final void Function() onTap;

  /// Callback function that handles changes in the search input.
  final void Function(String value) onChange;

  final String? label;
  final TextStyle? textStyleLabel;

  /// Creates a [SearchMultiselectField] widget.
  ///
  /// The [textController], [isMobile], [onTap], [focusNodeTextField], and [onChange] parameters are required.
  const SearchMultiselectField({
    super.key,
    required this.isMobile,
    required this.onTap,
    required this.focusNodeTextField,
    required this.onChange,
    this.label,
    this.textStyleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 0,
        maxWidth: 100,
      ),
      child: SearchBar(
        hintText: label,
        padding:
            const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
        elevation: const WidgetStatePropertyAll<double>(0),
        backgroundColor:
            const WidgetStatePropertyAll<Color>(Colors.transparent),
        shape: const WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
        ),
        textStyle: const WidgetStatePropertyAll<TextStyle>(
          TextStyle(
            decoration: TextDecoration.none,
            decorationStyle: TextDecorationStyle.solid,
            overflow: TextOverflow.ellipsis,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
        constraints: BoxConstraints(minHeight: isMobile ? 40 : 30),
        surfaceTintColor:
            const WidgetStatePropertyAll<Color>(Colors.transparent),
        shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        hintStyle: WidgetStatePropertyAll<TextStyle>(
          textStyleLabel ??
              const TextStyle(
                decoration: TextDecoration.none,
              ),
        ),
        onTap: onTap,
        onChanged: onChange,
        focusNode: focusNodeTextField,
      ),
    );
  }
}
