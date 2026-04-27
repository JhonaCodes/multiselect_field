import 'package:flutter/material.dart';

/// Defines how the label text should be rendered in [MultiSelectLabel].
///
/// - [LabelType.line]: single line, no wrapping (default behavior).
/// - [LabelType.wrap]: allows wrapping up to [MultiSelectLabel.maxLines]
///   lines via natural word break.
/// - [LabelType.overflow]: single line that truncates with an ellipsis
///   when it does not fit in the available width.
enum LabelType { line, wrap, overflow }

/// Reusable label widget for [MultiSelectField] variants.
///
/// Centralizes how a label string is rendered based on a [LabelType] preset.
/// Use it as the standard building block when supplying a `labelBuilder`:
///
/// ```dart
/// MultiSelectField<Foo>(
///   label: 'Categories',
///   labelBuilder: (label) => MultiSelectLabel(
///     label: label,
///     type: LabelType.wrap,
///     maxLines: 2,
///     style: Theme.of(context).textTheme.titleSmall,
///   ),
///   data: () => choices,
/// )
/// ```
class MultiSelectLabel extends StatelessWidget {
  /// Text to display.
  final String label;

  /// Rendering preset. See [LabelType].
  final LabelType type;

  /// Optional text style. Falls back to the ambient [DefaultTextStyle].
  final TextStyle? style;

  /// Max lines used when [type] is [LabelType.wrap]. Defaults to 2.
  /// Ignored for other types.
  final int maxLines;

  const MultiSelectLabel({
    super.key,
    required this.label,
    this.type = LabelType.line,
    this.style,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      LabelType.line => Text(
        label,
        style: style,
      ),
      LabelType.wrap => Text(
        label,
        style: style,
        maxLines: maxLines,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      LabelType.overflow => Text(
        label,
        style: style,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    };
  }
}
