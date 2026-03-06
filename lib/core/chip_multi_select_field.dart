import 'package:flutter/material.dart';

import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/chip_multi_select_extension.dart';
import 'package:multiselect_field/core/selection_content.dart';

/// Chip variant implementation of [MultiSelectField].
///
/// Displays as a compact chip that opens a dropdown menu when tapped.
/// Ideal for filter bars or space-constrained areas.
///
/// Can use either:
/// - [data] to auto-generate selection list (like standard MultiSelectField)
/// - [menuContent] for fully custom dropdown content
class ChipMultiSelectField<T> extends MultiSelectField<T> {
  /// The label displayed on the chip.
  final String label;

  /// Data source for selection options.
  /// If null, [menuContent] must be provided.
  final List<Choice<T>> Function()? data;

  /// Callback when selection changes (includes default data flag).
  final void Function(List<Choice<T>> choiceList, bool isFromDefaultData)?
  onSelect;

  /// Simple callback that fires only on user interaction, never on default data.
  final void Function(List<Choice<T>> selectedItems)? onChanged;

  /// Pre-selected choices.
  final List<Choice<T>>? defaultData;

  /// Custom content for the dropdown menu.
  /// If provided, overrides auto-generated list from [data].
  final Widget? menuContent;

  /// Optional header widget for the menu.
  final Widget? menuHeader;

  /// Optional footer widget for the menu.
  final Widget? menuFooter;

  /// Style configuration for the chip.
  final ChipStyle? chipStyle;

  /// Style configuration for the dropdown menu.
  final ChipMenuStyle? menuStyle;

  /// Called when the menu opens.
  final VoidCallback? onMenuOpened;

  /// Called when the menu closes.
  final VoidCallback? onMenuClosed;

  /// Whether the chip is interactive.
  final bool enabled;

  /// Widget to display before the label.
  final Widget? leading;

  /// Widget to display after the label (before dropdown icon).
  final Widget? trailing;

  /// Whether to show the dropdown arrow icon.
  final bool showDropdownIcon;

  /// If true, only one item can be selected at a time.
  final bool singleSelection;

  /// If true, shows "Select All" option.
  final bool selectAllOption;

  /// Controller for programmatic menu control.
  final MenuController? controller;

  /// Text style for group titles in the menu.
  final TextStyle? titleMenuStyle;

  /// Text style for items in the menu.
  final TextStyle? itemMenuStyle;

  /// Padding for group titles in the menu.
  final EdgeInsetsGeometry? titleMenuPadding;

  /// Size configuration for proportional scaling.
  /// Use [ChipSize.small], [ChipSize.medium], [ChipSize.large] or custom.
  final ChipSize? chipSize;

  const ChipMultiSelectField({
    super.key,
    required this.label,
    this.data,
    this.onSelect,
    this.onChanged,
    this.defaultData,
    this.menuContent,
    this.menuHeader,
    this.menuFooter,
    this.chipStyle,
    this.menuStyle,
    this.onMenuOpened,
    this.onMenuClosed,
    this.enabled = true,
    this.leading,
    this.trailing,
    this.showDropdownIcon = true,
    this.singleSelection = false,
    this.selectAllOption = false,
    this.controller,
    this.titleMenuStyle,
    this.itemMenuStyle,
    this.titleMenuPadding,
    this.chipSize,
  }) : super.internal();

  @override
  State<ChipMultiSelectField<T>> createState() =>
      _ChipMultiSelectFieldState<T>();
}

class _ChipMultiSelectFieldState<T> extends State<ChipMultiSelectField<T>> {
  late MenuController _menuController;
  bool _isOpen = false;
  List<Choice<T>> _selectedChoices = [];
  bool _selectAllActive = false;

  @override
  void initState() {
    super.initState();
    _menuController = widget.controller ?? MenuController();

    if (widget.defaultData != null && widget.defaultData!.isNotEmpty) {
      _selectedChoices = List.from(widget.defaultData!);
    }
  }

  @override
  void didUpdateWidget(covariant ChipMultiSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null &&
        widget.controller != oldWidget.controller) {
      _menuController = widget.controller!;
    }

    if (widget.defaultData != oldWidget.defaultData &&
        widget.defaultData != null) {
      _selectedChoices = List.from(widget.defaultData!);
    }
  }

  void _handleMenuStateChange(bool isOpen) {
    if (_isOpen != isOpen) {
      setState(() => _isOpen = isOpen);
      if (isOpen) {
        widget.onMenuOpened?.call();
      } else {
        widget.onMenuClosed?.call();
      }
    }
  }

  ChipStyle get _chipStyle =>
      widget.chipStyle ?? ChipStyle.withColor(Theme.of(context).primaryColor);

  ChipSize get _chipSize => widget.chipSize ?? ChipSize.medium;

  ({Color background, Color border, Color? text, Color icon}) get _colors =>
      context.resolveChipColors(isOpen: _isOpen, chipStyle: _chipStyle);

  ({EdgeInsetsGeometry padding, BorderRadius borderRadius, double iconSize, double fontSize, double spacing})
      get _dimensions =>
          context.resolveChipDimensions(chipStyle: _chipStyle, chipSize: _chipSize);

  String get _displayLabel => context.resolveChipDisplayLabel<T>(
    label: widget.label,
    selectedChoices: _selectedChoices,
    singleSelection: widget.singleSelection,
    hasData: widget.data != null,
  );

  bool _isSelected(Choice<T> choice) {
    return _selectedChoices.any((c) => c.key == choice.key);
  }

  void _toggleSelection(Choice<T> choice) {
    setState(() {
      if (widget.singleSelection) {
        if (_isSelected(choice)) {
          _selectedChoices.clear();
        } else {
          _selectedChoices = [choice];
        }
      } else {
        if (_isSelected(choice)) {
          _selectedChoices.removeWhere((c) => c.key == choice.key);
        } else {
          _selectedChoices.add(choice);
        }
      }

      if (widget.data != null) {
        final allData = widget.data!()
            .where((e) => e.key != null && e.key!.isNotEmpty)
            .toList();
        _selectAllActive = isSameData(_selectedChoices, allData);
      }
    });

    widget.onSelect?.call(_selectedChoices, false);
    widget.onChanged?.call(_selectedChoices);

    if (widget.singleSelection) {
      _menuController.close();
    }
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAllActive = !_selectAllActive;
      if (_selectAllActive && widget.data != null) {
        _selectedChoices = widget.data!()
            .where((e) => e.key != null && e.key!.isNotEmpty)
            .toList();
      } else {
        _selectedChoices.clear();
      }
    });
    widget.onSelect?.call(_selectedChoices, false);
    widget.onChanged?.call(_selectedChoices);
  }

  @override
  Widget build(BuildContext context) {

    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: widget.menuStyle?.offset ?? const Offset(0, 5),
      onOpen: () => _handleMenuStateChange(true),
      onClose: () => _handleMenuStateChange(false),
      style:
          widget.menuStyle?.menuStyle ??
          MenuStyle(
            elevation: const WidgetStatePropertyAll<double>(8),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
            maximumSize:
                widget.menuStyle?.width != null ||
                    widget.menuStyle?.height != null
                ? WidgetStatePropertyAll<Size>(
                    Size(
                      widget.menuStyle?.width ?? double.infinity,
                      widget.menuStyle?.height ?? double.infinity,
                    ),
                  )
                : null,
          ),
      menuChildren: [
        IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.menuHeader != null) widget.menuHeader!,
              ChipMenuContent<T>(
                menuContent: widget.menuContent,
                data: widget.data,
                selectAllOption: widget.selectAllOption,
                singleSelection: widget.singleSelection,
                selectAllActive: _selectAllActive,
                selectedChoices: _selectedChoices,
                titleMenuStyle: widget.titleMenuStyle,
                itemMenuStyle: widget.itemMenuStyle,
                titleMenuPadding: widget.titleMenuPadding,
                onToggleSelection: _toggleSelection,
                onToggleSelectAll: _toggleSelectAll,
                isSelected: _isSelected,
              ),
              if (widget.menuFooter != null) widget.menuFooter!,
            ],
          ),
        ),
      ],
      builder: (context, controller, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.enabled
                ? () => controller.isOpen
                    ? controller.close()
                    : controller.open()
                : null,
            borderRadius: _dimensions.borderRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: _dimensions.padding,
              decoration: BoxDecoration(
                color: _colors.background,
                borderRadius: _dimensions.borderRadius,
                border: Border.all(color: _colors.border, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    SizedBox(width: _dimensions.spacing),
                  ],
                  Text(
                    _displayLabel,
                    style: TextStyle(
                      fontSize: _dimensions.fontSize,
                      color: _colors.text,
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    SizedBox(width: _dimensions.spacing),
                    widget.trailing!,
                  ],
                  if (widget.showDropdownIcon) ...[
                    SizedBox(width: _dimensions.spacing),
                    AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        _chipStyle.icon ?? Icons.arrow_drop_down,
                        size: _dimensions.iconSize,
                        color: _colors.icon,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Backward-compatible alias for [SelectionContent].
///
/// Use [SelectionContent] directly for new code.
typedef ChipMenuContent<T> = SelectionContent<T>;
