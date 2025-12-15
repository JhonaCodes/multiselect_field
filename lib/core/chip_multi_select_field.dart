import 'package:flutter/material.dart';

import 'package:multiselect_field/core/multi_select.dart';

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

  /// Callback when selection changes.
  final void Function(List<Choice<T>> choiceList, bool isFromDefaultData)? onSelect;

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

  const ChipMultiSelectField({
    super.key,
    required this.label,
    this.data,
    this.onSelect,
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
  }) : super.internal();

  @override
  State<ChipMultiSelectField<T>> createState() => _ChipMultiSelectFieldState<T>();
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
    if (widget.controller != null && widget.controller != oldWidget.controller) {
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

      // Update select all state
      if (widget.data != null) {
        final allData = widget.data!().where((e) => e.key != null && e.key!.isNotEmpty).toList();
        _selectAllActive = isSameData(_selectedChoices, allData);
      }
    });

    widget.onSelect?.call(_selectedChoices, false);

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
  }

  Widget _buildMenuContent() {
    // If custom content provided, use it
    if (widget.menuContent != null) {
      return widget.menuContent!;
    }

    // Otherwise, build from data
    if (widget.data == null) {
      return const SizedBox.shrink();
    }

    final choices = widget.data!();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.selectAllOption && choices.isNotEmpty)
          CheckboxListTile(
            title: const Text('All'),
            value: _selectAllActive,
            onChanged: (_) => _toggleSelectAll(),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
          ),
        ...choices.where((c) => c.value.isNotEmpty).map((choice) {
          final isGroupTitle = choice.key == null || choice.key!.isEmpty;

          if (isGroupTitle) {
            return Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
              child: Text(
                choice.value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (widget.singleSelection) {
            return RadioListTile<String>(
              title: Text(choice.value),
              value: choice.key!,
              groupValue: _selectedChoices.isNotEmpty ? _selectedChoices.first.key : null,
              onChanged: (_) => _toggleSelection(choice),
              dense: true,
            );
          }

          return CheckboxListTile(
            title: Text(choice.value),
            value: _isSelected(choice),
            onChanged: (_) => _toggleSelection(choice),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipStyle = widget.chipStyle ?? ChipStyle.withColor(theme.primaryColor);

    final effectiveBackgroundColor = _isOpen
        ? (chipStyle.activeBackgroundColor ?? chipStyle.backgroundColor ?? Colors.transparent)
        : (chipStyle.backgroundColor ?? Colors.transparent);

    final effectiveBorderColor = _isOpen
        ? (chipStyle.activeBorderColor ?? chipStyle.borderColor ?? Colors.grey.withValues(alpha: 0.4))
        : (chipStyle.borderColor ?? Colors.grey.withValues(alpha: 0.4));

    final effectiveTextColor = _isOpen
        ? (chipStyle.activeTextColor ?? chipStyle.textColor ?? theme.textTheme.labelLarge?.color)
        : (chipStyle.textColor ?? theme.textTheme.labelLarge?.color);

    final effectiveIconColor = _isOpen
        ? (chipStyle.activeIconColor ?? chipStyle.iconColor ?? Colors.grey.shade600)
        : (chipStyle.iconColor ?? Colors.grey.shade600);

    // Build display label with selection count
    String displayLabel = widget.label;
    if (_selectedChoices.isNotEmpty && widget.data != null) {
      if (widget.singleSelection) {
        displayLabel = _selectedChoices.first.value;
      } else {
        displayLabel = '${widget.label} (${_selectedChoices.length})';
      }
    }

    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: widget.menuStyle?.offset ?? const Offset(0, 5),
      onOpen: () => _handleMenuStateChange(true),
      onClose: () => _handleMenuStateChange(false),
      style: widget.menuStyle?.menuStyle ??
          MenuStyle(
            elevation: const WidgetStatePropertyAll<double>(8),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
            maximumSize: widget.menuStyle?.width != null || widget.menuStyle?.height != null
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
              _buildMenuContent(),
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
                ? () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            }
                : null,
            borderRadius: chipStyle.borderRadius ?? BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: chipStyle.padding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: chipStyle.borderRadius ?? BorderRadius.circular(20),
                border: Border.all(
                  color: effectiveBorderColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 6),
                  ],
                  Text(
                    displayLabel,
                    style: (chipStyle.textStyle ?? theme.textTheme.labelLarge)?.copyWith(
                      color: effectiveTextColor,
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    const SizedBox(width: 6),
                    widget.trailing!,
                  ],
                  if (widget.showDropdownIcon) ...[
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        chipStyle.icon ?? Icons.arrow_drop_down,
                        size: chipStyle.iconSize ?? 20,
                        color: effectiveIconColor,
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
