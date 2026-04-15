import 'package:flutter/material.dart';

import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/selection_content.dart';
import 'package:multiselect_field/core/bottom_sheet_multi_select_extension.dart';

/// Bottom sheet variant implementation of [MultiSelectField].
///
/// Displays a trigger widget that opens a modal bottom sheet with
/// the selection list when tapped.
class BottomSheetMultiSelectField<T> extends MultiSelectField<T> {
  final String label;
  final List<Choice<T>> Function()? data;
  final void Function(List<Choice<T>> choiceList, bool isFromDefaultData)?
  onSelect;
  final void Function(List<Choice<T>> selectedItems)? onChanged;
  final List<Choice<T>>? defaultData;
  final Widget? menuContent;
  final Widget? menuHeader;
  final Widget? menuFooter;
  final BottomSheetStyle? bottomSheetStyle;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;
  final bool enabled;
  final Widget? child;
  final bool singleSelection;
  final bool selectAllOption;
  final bool useTextFilter;
  final bool closeOnSelect;
  final TextStyle? titleMenuStyle;
  final TextStyle? itemMenuStyle;
  final EdgeInsetsGeometry? titleMenuPadding;

  /// Custom search widget builder. Receives [onSearch] callback to filter items.
  /// When null and [useTextFilter] is true, uses a default [TextField].
  final Widget Function(void Function(String query) onSearch)? searchBuilder;

  /// Hint text for the default search field. Only used when [searchBuilder] is null.
  final String? searchHint;

  /// Style for the default search hint text. Only used when [searchBuilder] is null.
  final TextStyle? searchHintStyle;

  /// Minimum height of the bottom sheet when [useTextFilter] is true.
  /// Prevents the sheet from collapsing too much when few results match.
  /// Defaults to 200.
  final double? searchMinHeight;

  const BottomSheetMultiSelectField({
    super.key,
    required this.label,
    this.data,
    this.onSelect,
    this.onChanged,
    this.defaultData,
    this.menuContent,
    this.menuHeader,
    this.menuFooter,
    this.bottomSheetStyle,
    this.onOpened,
    this.onClosed,
    this.enabled = true,
    this.child,
    this.singleSelection = false,
    this.selectAllOption = false,
    this.useTextFilter = false,
    this.closeOnSelect = false,
    this.titleMenuStyle,
    this.itemMenuStyle,
    this.titleMenuPadding,
    this.searchBuilder,
    this.searchHint,
    this.searchHintStyle,
    this.searchMinHeight,
  }) : super.internal();

  @override
  State<BottomSheetMultiSelectField<T>> createState() =>
      _BottomSheetMultiSelectFieldState<T>();
}

class _BottomSheetMultiSelectFieldState<T>
    extends State<BottomSheetMultiSelectField<T>> {
  List<Choice<T>> _selectedChoices = [];
  bool _selectAllActive = false;

  @override
  void initState() {
    super.initState();
    if (widget.defaultData != null && widget.defaultData!.isNotEmpty) {
      _selectedChoices = List.from(widget.defaultData!);
    }
  }

  @override
  void didUpdateWidget(covariant BottomSheetMultiSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultData != oldWidget.defaultData &&
        widget.defaultData != null) {
      _selectedChoices = List.from(widget.defaultData!);
    }
  }

  bool _isSelected(Choice<T> choice) {
    return _selectedChoices.any((c) => c.key == choice.key);
  }

  void _toggleSelection(Choice<T> choice, StateSetter sheetSetState) {
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

    sheetSetState(() {});
    widget.onSelect?.call(_selectedChoices, false);
    widget.onChanged?.call(_selectedChoices);

    if (widget.closeOnSelect) {
      Navigator.of(context).pop();
    }
  }

  void _toggleSelectAll(StateSetter sheetSetState) {
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

    sheetSetState(() {});
    widget.onSelect?.call(_selectedChoices, false);
    widget.onChanged?.call(_selectedChoices);
  }

  String get _displayLabel {
    if (_selectedChoices.isEmpty) return widget.label;
    if (widget.singleSelection) return _selectedChoices.first.value;
    return '${widget.label} (${_selectedChoices.length})';
  }

  Future<void> _openBottomSheet() async {
    if (!widget.enabled) return;

    widget.onOpened?.call();

    final style = widget.bottomSheetStyle;
    String searchQuery = '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: style?.showDragHandle ?? true,
      backgroundColor: context.resolveBottomSheetBackgroundColor(style: style),
      barrierColor: style?.barrierColor,
      shape: RoundedRectangleBorder(
        borderRadius: context.resolveBottomSheetBorderRadius(style: style),
      ),
      constraints: BoxConstraints(
        maxHeight: context.resolveBottomSheetMaxHeight(style: style),
        minHeight: widget.useTextFilter ? (widget.searchMinHeight ?? 200) : 0,
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            List<Choice<T>> Function()? filteredData = widget.data;

            if (widget.useTextFilter &&
                searchQuery.isNotEmpty &&
                widget.data != null) {
              filteredData = () => widget.data!()
                  .where((c) => c.value
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList();
            }

            void onSearch(String query) {
              sheetSetState(() => searchQuery = query);
            }

            return SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.menuHeader != null) widget.menuHeader!,
                  if (widget.useTextFilter)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: widget.searchBuilder?.call(onSearch) ??
                          TextField(
                            autofocus: false,
                            onChanged: onSearch,
                            decoration: InputDecoration(
                              hintText: widget.searchHint ?? 'Search...',
                              hintStyle: widget.searchHintStyle,
                              prefixIcon: const Icon(Icons.search, size: 20),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => onSearch(''),
                                      child: const Icon(Icons.close, size: 20),
                                    )
                                  : null,
                            ),
                          ),
                    ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: SelectionContent<T>(
                        menuContent: widget.menuContent,
                        data: filteredData,
                        selectAllOption: widget.selectAllOption,
                        singleSelection: widget.singleSelection,
                        selectAllActive: _selectAllActive,
                        selectedChoices: _selectedChoices,
                        titleMenuStyle: widget.titleMenuStyle,
                        itemMenuStyle: widget.itemMenuStyle,
                        titleMenuPadding: widget.titleMenuPadding,
                        onToggleSelection: (choice) =>
                            _toggleSelection(choice, sheetSetState),
                        onToggleSelectAll: () =>
                            _toggleSelectAll(sheetSetState),
                        isSelected: _isSelected,
                      ),
                    ),
                  ),
                  if (widget.menuFooter != null) widget.menuFooter!,
                ],
              ),
            );
          },
        );
      },
    );

    widget.onClosed?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child != null) {
      return GestureDetector(
        onTap: widget.enabled ? _openBottomSheet : null,
        child: widget.child,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.enabled ? _openBottomSheet : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.enabled
                  ? Theme.of(context).colorScheme.outline
                  : Theme.of(context).disabledColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _displayLabel,
                style: TextStyle(
                  color: widget.enabled
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).disabledColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_up,
                color: widget.enabled
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
