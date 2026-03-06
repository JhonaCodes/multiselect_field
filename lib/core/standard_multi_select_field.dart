import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/chip_multiselect_field.dart';
import 'package:multiselect_field/core/search_multiselect_field.dart';
import 'package:multiselect_field/core/standard_multi_select_extension.dart';

/// Standard implementation of [MultiSelectField].
///
/// Displays selected items as chips within the field area with full
/// multiselect functionality including search, grouping, and custom widgets.
class StandardMultiSelectField<T> extends MultiSelectField<T> {
  final Widget Function(bool isEmpty)? title;
  final Widget? footer;
  final Widget Function(Choice<T> choiceList)? singleSelectWidget;
  final Widget Function(Choice<T> choiceList)? multiSelectWidget;
  final bool cleanCurrentSelection;
  final List<Choice<T>> Function() data;
  final void Function(List<Choice<T>> choiceList, bool isFromDefaultData)?
  onSelect;
  final void Function(List<Choice<T>> selectedItems)? onChanged;
  final List<Choice<T>>? defaultData;
  final bool isMandatory;
  final bool singleSelection;
  final bool useTextFilter;
  final Decoration? decoration;
  final double? menuWidth;
  final double? menuHeight;
  final bool menuWidthBaseOnContent;
  final bool menuHeightBaseOnContent;
  final TextStyle? textStyleSingleSelection;
  final MenuStyle? menuStyle;
  final Widget Function(bool menuState, Choice<T> choice)? iconLeft;
  final Widget Function(bool menuState, Choice<T> choice)? iconRight;
  final ButtonStyle? buttonStyle;
  final bool mergeSelectedStyle;
  final ButtonStyle? selectedItemButtonStyle;
  final EdgeInsetsGeometry? itemPadding;
  final EdgeInsetsGeometry? selectedItemPadding;
  final Widget Function(Choice<T> choice)? itemMenuButton;
  final TextStyle? titleMenuStyle;
  final TextStyle? itemMenuStyle;
  final String? label;
  final bool staticLabel;
  final TextStyle? textStyleLabel;
  final bool selectAllOption;
  final ItemColor? itemColor;
  final ScrollbarConfig? scrollbarConfig;
  final double iconSpacing;
  final FieldWidth? fieldWidth;

  const StandardMultiSelectField({
    super.key,
    required this.data,
    this.onSelect,
    this.onChanged,
    this.title,
    this.defaultData,
    this.useTextFilter = false,
    this.decoration,
    this.singleSelection = false,
    this.menuHeightBaseOnContent = false,
    this.menuWidthBaseOnContent = false,
    this.itemMenuButton,
    this.buttonStyle,
    this.mergeSelectedStyle = false,
    this.selectedItemButtonStyle,
    this.itemPadding,
    this.selectedItemPadding,
    this.iconLeft,
    this.iconRight,
    this.menuStyle,
    this.menuHeight,
    this.menuWidth,
    this.footer,
    this.multiSelectWidget,
    this.singleSelectWidget,
    this.isMandatory = false,
    this.itemMenuStyle,
    this.titleMenuStyle,
    this.textStyleSingleSelection,
    this.cleanCurrentSelection = false,
    this.selectAllOption = false,
    this.itemColor,
    this.label,
    this.staticLabel = false,
    this.textStyleLabel,
    this.scrollbarConfig,
    this.iconSpacing = 0,
    this.fieldWidth,
  }) : super.internal();

  @override
  State<StandardMultiSelectField<T>> createState() =>
      _StandardMultiSelectFieldState<T>();
}

class _StandardMultiSelectFieldState<T>
    extends State<StandardMultiSelectField<T>>
    with AutomaticKeepAliveClientMixin {
  final bool _isMobile =
      (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android);
  final GlobalKey _selectedItemKey = GlobalKey();

  List<Choice<T>> _selectedChoice = [];
  List<Choice<T>> _onFilteredChoice = [];

  bool _isTap = false;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeTextField = FocusNode();
  final MenuController _menuController = MenuController();

  bool _onSelected = false;
  bool _selectAllActive = false;

  List<Choice<T>> get _cleanData => widget
      .data()
      .where((ele) => ele.key != null || ele.key!.isNotEmpty)
      .toList();

  @override
  void initState() {
    super.initState();

    if (widget.defaultData != null && widget.defaultData!.isNotEmpty) {
      _selectedChoice.clear();
      _selectedChoice.addAll(widget.defaultData!);
    }
  }

  @override
  void didUpdateWidget(covariant StandardMultiSelectField<T> oldWidget) {
    if (widget.defaultData != null &&
        widget.defaultData!.isNotEmpty &&
        widget.singleSelection) {
      if (!listEquals(_selectedChoice, widget.defaultData!) &&
          oldWidget.defaultData != widget.defaultData) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          log('didUpdateWidget from multiselect lib was called');
          _selectedChoice = widget.defaultData!;
          widget.onSelect?.call(_selectedChoice, true);
        });
      }
    }

    if (_selectedChoice.isNotEmpty && widget.cleanCurrentSelection) {
      _selectedChoice.clear();
    }

    bool equalData = isSameData(_selectedChoice, widget.data());

    if (equalData) {
      _selectAllActive = true;
    } else if (_selectAllActive && widget.selectAllOption && !equalData) {
      _selectAllActive = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    _focusNodeTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double currentMenuHeight = widget.menuHeight ?? 300;

    WidgetsBinding.instance.addPostFrameCallback((obs) {
      final isKeyboardOpen = View.of(context).viewInsets.bottom > 0;

      if (_menuController.isOpen && isKeyboardOpen) {
        _menuController.open(position: Offset(0, double.infinity));
      } else if (_menuController.isOpen && !isKeyboardOpen) {
        _menuController.close();
        _menuController.open();
      }
    });

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) widget.title!(_selectedChoice.isEmpty),
          LayoutBuilder(
            builder: (context, size) {
              final effectiveScrollbarConfig =
                  widget.scrollbarConfig ??
                  ScrollbarConfig(
                    visible: true,
                    themeData: ScrollbarThemeData(
                      thickness: WidgetStateProperty.all(6.0),
                      thumbColor: WidgetStateProperty.all(
                        Colors.blue.withValues(alpha: 0.7),
                      ),
                      trackColor: WidgetStateProperty.all(
                        Colors.grey.withValues(alpha: 0.3),
                      ),
                      radius: const Radius.circular(4.0),
                    ),
                  );

              final scrollbarThemeData = effectiveScrollbarConfig.visible
                  ? effectiveScrollbarConfig.themeData ?? ScrollbarThemeData()
                  : ScrollbarThemeData(
                      thickness: WidgetStateProperty.all(0.0),
                      thumbVisibility: WidgetStateProperty.all(false),
                      trackVisibility: WidgetStateProperty.all(false),
                    );

              return ScrollbarTheme(
                data: scrollbarThemeData,
                child: MenuAnchor(
                  alignmentOffset: const Offset(0, 5),
                  controller: _menuController,
                  builder: (context, menu, child) {
                    currentMenuHeight = widget.menuHeightBaseOnContent
                        ? size.maxHeight
                        : widget.menuHeight ?? double.infinity;

                    return InkWell(
                      hoverColor: Colors.transparent,
                      overlayColor: const WidgetStatePropertyAll<Color>(
                        Colors.transparent,
                      ),
                      onTap: () {
                        if (!menu.isOpen) menu.open();

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToSelectedItem();
                        });

                        if (!_focusNodeTextField.hasFocus) {
                          _focusNodeTextField.requestFocus();
                        }
                        _arrowEnableOrNot();
                      },
                      onTapDown: (down) {
                        _textController.clear();
                        _arrowEnableOrNot();
                        _onFilteredChoice = widget.data();
                      },
                      child: KeyboardListener(
                        focusNode: _focusNode,
                        onKeyEvent: (event) {
                          if (event.runtimeType == KeyDownEvent) {
                            if (event.logicalKey ==
                                LogicalKeyboardKey.backspace) {
                              if (_selectedChoice.isNotEmpty &&
                                  _textController.text.isEmpty) {
                                _addOrRemove(
                                  _selectedChoice[_selectedChoice.length - 1],
                                );
                              }
                            }

                            if (event.logicalKey == LogicalKeyboardKey.enter) {
                              if (_textController.text.isNotEmpty) {
                                Choice<T> elementFiltered = widget
                                    .data()
                                    .firstWhere(
                                      (filter) =>
                                          filter.value.toLowerCase() ==
                                          _textController.text.toLowerCase(),
                                    );
                                _addOrRemove(elementFiltered);
                              }
                            }
                          }
                        },
                        child: Container(
                          width: widget.fieldWidth == null
                              ? size.maxWidth
                              : widget.fieldWidth!.value,
                          constraints: const BoxConstraints(minHeight: 45),
                          decoration: widget.decoration,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(top: 2),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisSize: widget.fieldWidth == FieldWidth.fitContent
                                ? MainAxisSize.min
                                : MainAxisSize.max,
                            mainAxisAlignment: widget.fieldWidth == FieldWidth.fitContent
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (widget.iconLeft != null)
                                widget.iconLeft!(_menuController.isOpen, _selectedChoice.first),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.center,
                                  spacing: 7,
                                  runSpacing: _isMobile ? 0 : 7,
                                  children: [
                                    if ((_selectedChoice.isEmpty || widget.staticLabel) &&
                                        !widget.useTextFilter &&
                                        widget.label != null)
                                      Text(
                                        widget.label!,
                                        style: widget.textStyleLabel,
                                      ),
                                    if (_selectedChoice.isNotEmpty)
                                      ..._selectedChoice.map((element) {



                                        if (!widget.singleSelection) {
                                          return widget.multiSelectWidget !=
                                                  null
                                              ? widget.multiSelectWidget!(
                                                  element,
                                                )
                                              : ChipMultiselectField(
                                                  title: element.value,
                                                  onDeleted: () =>
                                                      _addOrRemove(element),
                                                );
                                        } else if(!widget.staticLabel){
                                          return widget.singleSelectWidget != null ? widget.singleSelectWidget!(element,)
                                              : Text(
                                                  element.value,
                                                  style:
                                                      widget
                                                          .textStyleSingleSelection ??
                                                      Theme.of(
                                                        context,
                                                      ).textTheme.labelLarge,
                                                );
                                        }else{
                                          return SizedBox.shrink();
                                        }

                                      }),
                                    if (widget.useTextFilter &&
                                        _menuController.isOpen)
                                      SearchMultiselectField(
                                        focusNodeTextField: _focusNodeTextField,
                                        isMobile: _isMobile,
                                        label: widget.label,
                                        textStyleLabel: widget.textStyleLabel,
                                        onTap: () {
                                          if (!menu.isOpen) menu.open();
                                        },
                                        onChange: (value) {
                                          _textController.text = value;
                                          if (!menu.isOpen) menu.open();
                                          _onSelected = false;
                                          _searchElement(_textController.text);
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              widget.iconRight == null
                                  ? Padding(
                                      padding: EdgeInsets.only(left: widget.iconSpacing),
                                      child: GestureDetector(
                                        onTap: () {
                                          _menuController.isOpen
                                              ? _menuController.close()
                                              : _menuController.open();
                                        },
                                        child: Icon(
                                          menu.isOpen
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                    )
                                  : widget.iconRight!(_menuController.isOpen, _selectedChoice.first),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  menuChildren: [
                    if (widget.selectAllOption && widget.data().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CheckboxMenuButton(
                          value: _selectAllActive,
                          onChanged: (vale) {
                            _selectAllActive = !_selectAllActive;
                            _selectedChoice = _selectAllActive
                                ? _cleanData
                                : [];
                            widget.onSelect?.call(_selectedChoice, false);
                            widget.onChanged?.call(_selectedChoice);
                          },
                          child: Text("All"),
                        ),
                      ),
                    ..._onFilteredChoice
                        .where((element) => element.value.isNotEmpty)
                        .map((result) {
                          bool isGroupingTitle =
                              result.key == null || result.key!.isEmpty;
                          final isSelected = !isGroupingTitle && _isSelected(result);

                          return SizedBox(
                            width: widget.menuWidthBaseOnContent
                                ? null
                                : size.maxWidth,
                            child: Padding(
                              padding: (isSelected && widget.selectedItemPadding != null)
                                  ? widget.selectedItemPadding!
                                  : widget.itemPadding ?? EdgeInsets.zero,
                              child: MenuItemButton(
                                closeOnActivate:
                                    widget.singleSelection ||
                                    widget.data().length == 1,
                                key: isSelected &&
                                        _selectedChoice.indexOf(result) == 0
                                    ? _selectedItemKey
                                    : null,
                                trailingIcon: !widget.selectAllOption
                                    ? isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                              size: 12,
                                            )
                                          : null
                                    : null,
                                leadingIcon:
                                    widget.selectAllOption && !isGroupingTitle
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check_box,
                                                color: Colors.green,
                                              )
                                            : Icon(Icons.check_box_outline_blank),
                                      )
                                    : null,
                                style: context.resolveItemStyle(
                                  isGroupingTitle: isGroupingTitle,
                                  isSelected: isSelected,
                                  isMobile: _isMobile,
                                  selectedItemButtonStyle: widget.selectedItemButtonStyle,
                                  mergeSelectedStyle: widget.mergeSelectedStyle,
                                  buttonStyle: widget.buttonStyle,
                                  itemColor: widget.itemColor,
                                ),
                                onPressed: isGroupingTitle
                                    ? null
                                    : () {
                                        _addOrRemove(result);
                                        if (!widget.singleSelection &&
                                            widget.useTextFilter) {
                                          _textController.clear();
                                        }
                                      },
                                child: switch (widget.itemMenuButton) {
                                  null => Padding(
                                    padding: EdgeInsets.only(
                                      left: isGroupingTitle ? 0 : 10,
                                    ),
                                    child: Text(
                                      result.value,
                                      style: isGroupingTitle
                                          ? widget.titleMenuStyle ??
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium
                                          : widget.itemMenuStyle ??
                                                Theme.of(
                                                  context,
                                                ).textTheme.labelMedium,
                                    ),
                                  ),
                                  _ => widget.itemMenuButton!(result),
                                },
                              ),
                            ),
                          );
                        }),
                  ],
                  style:
                      widget.menuStyle ??
                      MenuStyle(
                        elevation: const WidgetStatePropertyAll<double>(5),
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        maximumSize:
                            widget.menuWidthBaseOnContent &&
                                widget.menuHeightBaseOnContent
                            ? null
                            : WidgetStatePropertyAll<Size>(
                                Size(
                                  widget.menuWidth ?? size.maxWidth,
                                  currentMenuHeight,
                                ),
                              ),
                      ),
                ),
              );
            },
          ),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }

  void _arrowEnableOrNot() => setState(() => _isTap = !_isTap);

  bool _isSelected(Choice val) {
    return _selectedChoice
        .where(
          (element) =>
              (val.key != null || val.key!.isNotEmpty) &&
              element.key == val.key,
        )
        .isNotEmpty;
  }

  Future<void> _scrollToSelectedItem() async {
    if (_selectedItemKey.currentContext != null) {
      await Scrollable.ensureVisible(
        _selectedItemKey.currentContext!,
        alignment: 0.5,
      );
    }
  }

  void _searchElement(String text) {
    setState(() {
      _onFilteredChoice = _onSelected
          ? widget.data()
          : widget
                .data()
                .where(
                  (e) => e.value.toLowerCase().contains(
                    text.toLowerCase().toString(),
                  ),
                )
                .toList();
    });
  }

  void _addOrRemove(Choice<T>? va) {
    if (va != null) {
      if (widget.singleSelection) {
        if (_selectedChoice.isNotEmpty &&
            _isSelected(va) &&
            !widget.isMandatory) {
          _selectedChoice.clear();
          _textController.clear();
        } else {
          _selectedChoice = [va];
          _textController.text = va.value;
          _onSelected = true;

          if (widget.useTextFilter && !_focusNodeTextField.hasFocus) {
            _focusNodeTextField.requestFocus();
          }
        }
        _onSelected = _selectedChoice.isNotEmpty;
      } else {
        if (_isSelected(va)) {
          if (widget.isMandatory) {
            if (_selectedChoice.isNotEmpty) {
              _selectedChoice.remove(va);
            }
          } else {
            _selectedChoice.remove(va);
          }
        } else {
          _selectedChoice.add(va);

          if (widget.useTextFilter && !_focusNodeTextField.hasFocus) {
            _focusNodeTextField.requestFocus();
          }
        }
      }

      widget.onSelect?.call(_selectedChoice, false);
      widget.onChanged?.call(_selectedChoice);
      _onFilteredChoice = _cleanData;
      setState(() {});
    }
  }
}
