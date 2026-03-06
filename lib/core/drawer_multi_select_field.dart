import 'package:flutter/material.dart';

import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/multi_select_key_store.dart';
import 'package:multiselect_field/core/selection_content.dart';

/// Drawer variant implementation of [MultiSelectField].
///
/// Behaves differently depending on whether [scaffoldKey] is provided:
///
/// **With [scaffoldKey]** — Renders the selection content directly.
/// Place it inside your Scaffold's `endDrawer` or `drawer`:
/// ```dart
/// Scaffold(
///   key: scaffoldKey,
///   endDrawer: Drawer(
///     child: MultiSelectField<String>.drawer(
///       label: 'Filter',
///       keyDrawer: 'myFilter',
///       scaffoldKey: scaffoldKey,
///       data: () => choices,
///       onSelect: (selected, _) => print(selected),
///     ),
///   ),
/// )
/// ```
///
/// **Without [scaffoldKey]** — Renders a trigger widget that opens a
/// standalone overlay drawer on tap:
/// ```dart
/// MultiSelectField<String>.drawer(
///   label: 'Filter',
///   data: () => choices,
///   onSelect: (selected, _) => print(selected),
/// )
/// ```
class DrawerMultiSelectField<T> extends MultiSelectField<T> {
  final String label;
  final List<Choice<T>> Function()? data;
  final void Function(List<Choice<T>> choiceList, bool isFromDefaultData)?
  onSelect;
  final void Function(List<Choice<T>> selectedItems)? onChanged;
  final List<Choice<T>>? defaultData;
  final Widget? menuContent;
  final Widget? menuHeader;
  final Widget? menuFooter;
  final DrawerStyle? drawerStyle;
  final String? keyDrawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
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

  const DrawerMultiSelectField({
    super.key,
    required this.label,
    this.data,
    this.onSelect,
    this.onChanged,
    this.defaultData,
    this.menuContent,
    this.menuHeader,
    this.menuFooter,
    this.drawerStyle,
    this.keyDrawer,
    this.scaffoldKey,
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
  }) : super.internal();

  @override
  State<DrawerMultiSelectField<T>> createState() =>
      _DrawerMultiSelectFieldState<T>();
}

class _DrawerMultiSelectFieldState<T> extends State<DrawerMultiSelectField<T>> {
  List<Choice<T>> _selectedChoices = [];
  bool _selectAllActive = false;

  /// Whether this widget acts as scaffold drawer content or as a trigger.
  bool get _isScaffoldMode => widget.scaffoldKey != null;

  @override
  void initState() {
    super.initState();
    if (widget.defaultData != null && widget.defaultData!.isNotEmpty) {
      _selectedChoices = List.from(widget.defaultData!);
    }
    _registerStore();
  }

  @override
  void didUpdateWidget(covariant DrawerMultiSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultData != oldWidget.defaultData &&
        widget.defaultData != null) {
      _selectedChoices = List.from(widget.defaultData!);
    }
    _registerStore();
  }

  void _registerStore() {
    if (widget.keyDrawer == null) return;
    final store = MultiSelectKeyStore.of<T>(widget.keyDrawer!);
    if (widget.scaffoldKey != null) {
      store.registerScaffold(
        widget.scaffoldKey!,
        position: widget.drawerStyle?.position ?? DrawerPosition.right,
      );
    }
  }

  bool _isSelected(Choice<T> choice) {
    return _selectedChoices.any((c) => c.key == choice.key);
  }

  void _toggleSelection(Choice<T> choice, [StateSetter? overlaySetState]) {
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

    overlaySetState?.call(() {});
    widget.onSelect?.call(_selectedChoices, false);
    widget.onChanged?.call(_selectedChoices);

    if (widget.closeOnSelect) {
      _closeDrawer();
    }
  }

  void _closeDrawer() {
    if (_isScaffoldMode) {
      final position = widget.drawerStyle?.position ?? DrawerPosition.right;
      if (position == DrawerPosition.left) {
        widget.scaffoldKey!.currentState?.closeDrawer();
      } else {
        widget.scaffoldKey!.currentState?.closeEndDrawer();
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  void _toggleSelectAll([StateSetter? overlaySetState]) {
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

    overlaySetState?.call(() {});
    widget.onSelect?.call(_selectedChoices, false);
    widget.onChanged?.call(_selectedChoices);
  }

  String get _displayLabel {
    if (_selectedChoices.isEmpty) return widget.label;
    if (widget.singleSelection) return _selectedChoices.first.value;
    return '${widget.label} (${_selectedChoices.length})';
  }

  // -- Selection content shared by both modes --

  Widget _buildSelectionContent({StateSetter? overlaySetState}) {
    return SelectionContent<T>(
      menuContent: widget.menuContent,
      data: widget.data,
      selectAllOption: widget.selectAllOption,
      singleSelection: widget.singleSelection,
      selectAllActive: _selectAllActive,
      selectedChoices: _selectedChoices,
      titleMenuStyle: widget.titleMenuStyle,
      itemMenuStyle: widget.itemMenuStyle,
      titleMenuPadding: widget.titleMenuPadding,
      onToggleSelection: (choice) => _toggleSelection(choice, overlaySetState),
      onToggleSelectAll: () => _toggleSelectAll(overlaySetState),
      isSelected: _isSelected,
    );
  }

  Widget _buildDrawerBody({StateSetter? overlaySetState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.menuHeader != null) widget.menuHeader!,
        Expanded(
          child: SingleChildScrollView(
            child: _buildSelectionContent(overlaySetState: overlaySetState),
          ),
        ),
        if (widget.menuFooter != null) widget.menuFooter!,
      ],
    );
  }

  // -- Overlay mode --

  Future<void> _openOverlayDrawer() async {
    if (!widget.enabled) return;

    widget.onOpened?.call();

    final style = widget.drawerStyle;
    final position = style?.position ?? DrawerPosition.right;
    final beginOffset = position == DrawerPosition.right
        ? const Offset(1, 0)
        : const Offset(-1, 0);

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: style?.barrierColor ?? Colors.black54,
      transitionDuration:
          style?.animationDuration ?? const Duration(milliseconds: 300),
      pageBuilder: (_, animation2, secondaryAnimation) =>
          const SizedBox.shrink(),
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: style?.animationCurve ?? Curves.easeInOut,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(curved),
          child: Align(
            alignment: position == DrawerPosition.right
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: SafeArea(
              child: StatefulBuilder(
                builder: (_, overlaySetState) {
                  return Material(
                    elevation: 16,
                    borderRadius: style?.borderRadius,
                    child: Container(
                      width: style?.width ?? 300,
                      decoration: BoxDecoration(
                        color:
                            style?.backgroundColor ??
                            Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: style?.borderRadius,
                        boxShadow: style?.boxShadow,
                      ),
                      child: _buildDrawerBody(overlaySetState: overlaySetState),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    widget.onClosed?.call();
  }

  // -- Build --

  @override
  Widget build(BuildContext context) {
    // Scaffold mode: render content directly
    if (_isScaffoldMode) {
      return _buildDrawerBody();
    }

    // Overlay mode: render trigger widget
    if (widget.child != null) {
      return GestureDetector(
        onTap: widget.enabled ? _openOverlayDrawer : null,
        child: widget.child,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.enabled ? _openOverlayDrawer : null,
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
                Icons.menu,
                size: 18,
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
