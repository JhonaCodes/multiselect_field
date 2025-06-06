import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_field/core/chip_multiselect_field.dart';
import 'package:multiselect_field/core/search_multiselect_field.dart';

/// A customizable [MultiSelectField] widget that allows users to select
/// multiple options from a list with a search capability.
///
/// The [MultiSelectField] provides a user interface for selecting multiple
/// items from a predefined list. It features a search bar to help users
/// filter and find the options they are looking for quickly.
///
/// This widget is particularly useful in forms where users need to select
/// multiple categories, tags, or options from a large dataset. It supports
/// mobile and desktop platforms with responsive design adjustments.
///
/// Example usage:
/// ```dart
/// class Demo extends StatelessWidget {
///   const Demo({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return MultiSelectField<Car>(
///       data: () => [
///         Choice<Car>('', 'Ferrari'),
///         Choice<Car>('2', '488 GTB', metadata: Car(103, 27.500, 2015)),
///         Choice<Car>('3', '458 Italia'),
///         Choice<Car>('4', 'Portofino', metadata: Car(105, 31.000, 2017)),
///         Choice<Car>('5', 'California T', metadata: Car(102, 25.000, 2016)),
///         Choice<Car>('6', 'F8 Tributo',),
///       ],
///       onSelect: (selectedItems) {
///         // Handle selected items here
///         print(selectedItems.map((item) => item.value).toList());
///       },
///       useTextFilter: true, // Enables real-time text filtering
///     );
///   }
/// }
///```
///
/// Properties:
/// - `options`: A list of all available options.
/// - `selectedOptions`: A list of options that are currently selected.
/// - `onSelectionChanged`: A callback that is triggered when the selection changes.
///
/// Customization:
/// - The search bar allows users to quickly filter options.
/// - The layout adapts to different screen sizes and devices.
///
class MultiSelectField<T> extends StatefulWidget {
  final Widget Function(bool isEmpty)? title;
  final Widget? footer;
  final Widget Function(Choice<T> choiceList)? singleSelectWidget;
  final Widget Function(Choice<T> choiceList)? multiSelectWidget;

  /// [cleanCurrentSelection]
  /// When set to true, the current selection will be cleared immediately.
  /// The check verifies if the current list is empty, so after the selection is cleared,
  /// it won't be executed again until there are items in the selection list.
  /// It's recommended not to have a constant true condition for clearing.
  /// Instead, you could validate if the list is null or if a process returns a specific result,
  /// thus preventing unnecessary clearing.
  /// Keeping this value constantly true will cause the selection to always be cleared immediately.
  ///
  final bool cleanCurrentSelection;

  final List<Choice<T>> Function() data;

  /// Callback triggered when one or more options are selected.
  ///
  /// - [choiceList] is the list of selected items.
  /// - [isFromDefaultData] indicates whether the selection was derived from [defaultData].
  ///
  /// This value will be `true` when:
  /// - The selection is initialized using [defaultData].
  /// - [defaultData] is updated dynamically at runtime from an external state source.
  ///
  /// It will be `false` when the selection is made directly by the user (e.g., tapping an option).
  ///
  /// This flag helps distinguish between automatic selections (driven by logic or external state)
  /// and manual selections performed by the user.
  ///
  /// ### Example usage:
  /// ```dart
  /// onSelect: (choiceList, isFromDefaultData) {
  ///   if (!isFromDefaultData) {
  ///     // Handle selections made manually by the user.
  ///     handleUserSelection(choiceList);
  ///   } else {
  ///     // Apply logic for selections coming from defaultData.
  ///     updateFromExternalState(choiceList);
  ///   }
  /// }
  /// ```
  final void Function(List<Choice<T>> choiceList, bool isFromDefaultData)
  onSelect;

  /// A list of preselected choices that serve as the default selection
  /// when the widget is first built or when externally updated.
  ///
  /// If [defaultData] is provided:
  /// - The widget will initialize the selected state based on this list.
  /// - When [defaultData] is changed externally at runtime (e.g., through a state management update),
  ///   the selection will automatically update and trigger [onSelect] with `isFromDefaultData = true`.
  ///
  /// If [defaultData] is `null`, no selection will be applied by default.
  ///
  /// This is useful for syncing the selection state with an external source
  /// or for pre-filling selections when rendering the widget.
  ///
  /// Example:
  /// ```dart
  /// MySelectorWidget(
  ///   defaultData: [Choice(id: 1, label: 'Apple')],
  ///   onSelect: (choices, isFromDefaultData) {
  ///     if (isFromDefaultData) {
  ///       // Handle programmatic selection
  ///     } else {
  ///       // Handle user-initiated selection
  ///     }
  ///   },
  /// )
  /// ```
  final List<Choice<T>>? defaultData;

  final bool isMandatory;
  final bool singleSelection;
  final bool useTextFilter;
  final Decoration? decoration;

  /// Sets a fixed width for the menu.
  final double? menuWidth;

  /// Sets a fixed height for the menu.
  final double? menuHeight;

  /// If set to true, the menu will have a width equal to the length of the content.
  final bool menuWidthBaseOnContent;

  /// If set to true, the menu will have a height equal to the length of the content.
  final bool menuHeightBaseOnContent;

  /// Or just modify a [Theme.of(context).textTheme.labelLarge].
  final TextStyle? textStyleSingleSelection;

  /// MultiselectField Style
  final MenuStyle? menuStyle;
  final Widget Function(bool menuState)? iconLeft;
  final Widget Function(bool menuState)? iconRight;

  /// MenuItemButton Style
  final ButtonStyle? buttonStyle;

  /// Selectable child of MenuItemButton
  final Widget? itemMenuButton;

  /// Text style items, title and value.
  final TextStyle? titleMenuStyle;
  final TextStyle? itemMenuStyle;

  final String? label;
  final TextStyle? textStyleLabel;

  /// Set to `true` to display an [All] option in the multiselect list.
  final bool selectAllOption;

  /// Customize the colors for [selected], [hovered], and [unselected] items.
  final ItemColor? itemColor;

  const MultiSelectField({
    super.key,
    required this.data,
    required this.onSelect,
    this.title,
    this.defaultData,
    this.useTextFilter = false,
    this.decoration,
    this.singleSelection = false,
    this.menuHeightBaseOnContent = false,
    this.menuWidthBaseOnContent = false,
    this.itemMenuButton,
    this.buttonStyle,
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
    this.textStyleLabel,
  });

  @override
  State<MultiSelectField<T>> createState() => _MultiSelectFieldState<T>();
}

class _MultiSelectFieldState<T> extends State<MultiSelectField<T>>
    with AutomaticKeepAliveClientMixin {
  final bool _isMobile =
      (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android);
  final GlobalKey _selectedItemKey = GlobalKey();

  List<Choice<T>> _selectedChoice = [];
  List<Choice<T>> _onFilteredChoice = [];

  /// Something rustic and without animation, but simple and functional,
  /// it will need some time in transition and a little smoothness when changing state.
  ///
  bool _isTap = false;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeTextField = FocusNode();
  final MenuController _menuController = MenuController();

  /// It helps to show the complete list of elements after selecting an element using the text filter.
  bool _onSelected = false;
  bool _selectAllActive = false;

  List<Choice<T>> get _cleanData => widget
      .data()
      .where((ele) => ele.key != null || ele.key!.isNotEmpty)
      .toList();

  ItemColor get _currentItemColor => ItemColor(
    selected: Colors.blueAccent.shade100.withAlpha(50),
    unSelected: Colors.transparent,
    hovered: Colors.blueAccent.shade100.withAlpha(30),
  );

  @override
  void initState() {
    super.initState();

    if (widget.defaultData != null && widget.defaultData!.isNotEmpty) {
      _selectedChoice.clear();
      _selectedChoice.addAll(widget.defaultData!);
    }
  }

  @override
  void didUpdateWidget(covariant MultiSelectField<T> oldWidget) {
    if (widget.defaultData != null &&
        widget.defaultData!.isNotEmpty &&
        widget.singleSelection) {
      /// If the current action is not removing an element, update [_selectedElements]
      /// with [defaultData]. Otherwise, keep the previous value of [_selectedElements],
      /// preventing it from being updated by [defaultData].
      ///
      /// Note: [didUpdateWidget] is called whenever the widget is updated,
      /// so it's important to control when [_selectedElements] should be updated.
      /// This is also executed if and only if we do not have any elements selected,
      /// because in this way we will only have an update if an element is selected after the widget is built.
      ///
      /// Recommendation:
      /// Over time this entire implementation should be migrated to [ValueNotifier], with a singleton abstraction.
      ///

      if (!listEquals(_selectedChoice, widget.defaultData!) &&
          oldWidget.defaultData != widget.defaultData) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          log('didUpdateWidget from multiselect lib was called');
          _selectedChoice = widget.defaultData!;
          widget.onSelect(_selectedChoice, true);
        });
      }
    }

    /// [cleanCurrentSelection]
    ///
    if (_selectedChoice.isNotEmpty && widget.cleanCurrentSelection) {
      _selectedChoice.clear();
    }

    /// Verification for select all data, if you select one per one and you have select all option, you nee to si is you're selected all data.
    bool equalData = isSameData(_selectedChoice, widget.data());

    if (equalData) {
      _selectAllActive = true;
    } else if (_selectAllActive && widget.selectAllOption && !equalData) {
      _selectAllActive = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  /// Temporal solution for dispose in case of use ListView.
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    _focusNodeTextField.dispose();
    super.dispose();
  }

  ///Todo: Next update, ValueNotifier implementation.
  @override
  Widget build(BuildContext context) {
    /// Maintain state, special when you are using ListView.
    /// This avoid unnecessary dispose.
    super.build(context);

    double currentMenuHeight = widget.menuHeight ?? 300;

    /// Ensures that the widget tree is rendered correctly after the current frame is drawn.
    /// This is used to handle keyboard visibility and adjust the pop-up menu position accordingly.
    WidgetsBinding.instance.addPostFrameCallback((obs) {
      // Step 1: Verify if the keyboard is open based on the bottom inset.
      final isKeyboardOpen = View.of(context).viewInsets.bottom > 0;

      // Step 3: Handle the pop-up menu behavior based on keyboard visibility.
      if (_menuController.isOpen && isKeyboardOpen) {
        // If the menu is open and the keyboard is visible, adjust the menu's position upwards
        // to avoid overlapping with the keyboard.
        _menuController.open(position: Offset(0, double.infinity));
      } else if (_menuController.isOpen && !isKeyboardOpen) {
        // If the menu is open and the keyboard is not visible, reset the menu's position.
        _menuController.close();

        // Re-open the menu at its default position.
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
              return MenuAnchor(
                alignmentOffset: const Offset(0, 5),
                controller: _menuController,
                builder: (context, menu, child) {
                  // Step 2: Determine the height of the pop-up menu based on content or predefined value.
                  currentMenuHeight = widget.menuHeightBaseOnContent
                      ? size
                            .maxHeight // If the menu height depends on content, use the max height.
                      : widget.menuHeight ??
                            double
                                .infinity; // Otherwise, use a predefined height or default to 300.

                  return InkWell(
                    hoverColor: Colors.transparent,
                    overlayColor: const WidgetStatePropertyAll<Color>(
                      Colors.transparent,
                    ),

                    /// Help to open menu when click in any part of the current widget.
                    /// But not when you tap on Edit text widget.
                    onTap: () {
                      if (!menu.isOpen) menu.open();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToSelectedItem();
                      });

                      /// Help to focus on textField when click on any part of the widget.
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
                        /// Verify if is keyboard event
                        if (event.runtimeType == KeyDownEvent) {
                          /// Back space is delete, this is used for delete element similar to delete text on the widget.
                          if (event.logicalKey ==
                              LogicalKeyboardKey.backspace) {
                            if (_selectedChoice.isNotEmpty &&
                                _textController.text.isEmpty) {
                              _addOrRemove(
                                _selectedChoice[_selectedChoice.length - 1],
                              );
                            }
                          }

                          /// Whe press enter, should be save the current filtered element.
                          ///
                          /// Help when you type the element on the widget
                          if (event.logicalKey == LogicalKeyboardKey.enter) {
                            if (_textController.text.isNotEmpty) {
                              ///Filtering element form general list.
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
                        width: size.maxWidth,
                        constraints: const BoxConstraints(minHeight: 45),
                        decoration: widget.decoration,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(top: 2),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.iconLeft != null)
                              widget.iconLeft!(_menuController.isOpen),
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
                                  if (_selectedChoice.isEmpty &&
                                      !widget.useTextFilter &&
                                      widget.label != null)
                                    Text(
                                      widget.label!,
                                      style: widget.textStyleLabel,
                                    ),
                                  if (_selectedChoice.isNotEmpty)
                                    ..._selectedChoice.map((element) {
                                      if (!widget.singleSelection) {
                                        return widget.multiSelectWidget != null
                                            ? widget.multiSelectWidget!(element)
                                            : ChipMultiselectField(
                                                title: element.value,
                                                onDeleted: () =>
                                                    _addOrRemove(element),
                                              );
                                      } else {
                                        return widget.singleSelectWidget != null
                                            ? widget.singleSelectWidget!(
                                                element,
                                              )
                                            : Text(
                                                element.value,
                                                style:
                                                    widget
                                                        .textStyleSingleSelection ??
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.labelLarge,
                                              );
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

                                        /// Editing text, open list.
                                        /// this is in case of list was closed, but you start to write.
                                        if (!menu.isOpen) menu.open();

                                        /// If we write data to the controller, it changes to false so we can see the elements that match our filter.
                                        _onSelected = false;

                                        _searchElement(_textController.text);
                                      },
                                    ),
                                ],
                              ),
                            ),
                            widget.iconRight == null
                                ? SizedBox(
                                    height: 40,
                                    width: 20,
                                    child: Center(
                                      child: GestureDetector(
                                        child: Icon(
                                          menu.isOpen
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                        onTap: () {
                                          _menuController.isOpen
                                              ? _menuController.close()
                                              : _menuController.open();
                                        },
                                      ),
                                    ),
                                  )
                                : widget.iconRight!(_menuController.isOpen),
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

                          _selectedChoice = _selectAllActive ? _cleanData : [];
                          widget.onSelect(_selectedChoice, false);
                        },
                        child: Text("All"),
                      ),
                    ),
                  ..._onFilteredChoice
                      .where((element) => element.value.isNotEmpty)
                      .map((result) {
                        bool isGroupingTitle =
                            result.key == null || result.key!.isEmpty;
                        return SizedBox(
                          width: widget.menuWidthBaseOnContent
                              ? null
                              : size.maxWidth,
                          child: MenuItemButton(
                            closeOnActivate:
                                widget.singleSelection ||
                                widget.data().length == 1,
                            key:
                                (!isGroupingTitle && _isSelected(result)) &&
                                    _selectedChoice.indexOf(result) == 0
                                ? _selectedItemKey
                                : null,
                            trailingIcon: !widget.selectAllOption
                                ? (!isGroupingTitle && _isSelected(result))
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
                                    child: _isSelected(result)
                                        ? const Icon(
                                            Icons.check_box,
                                            color: Colors.green,
                                          )
                                        : Icon(Icons.check_box_outline_blank),
                                  )
                                : null,
                            style:
                                widget.buttonStyle ??
                                ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  elevation:
                                      const WidgetStatePropertyAll<double>(7.5),
                                  overlayColor: const WidgetStatePropertyAll(
                                    Colors.transparent,
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith((state) {
                                        /// Hovered only on web version
                                        if ((state.contains(
                                              WidgetState.hovered,
                                            ) &&
                                            _isMobile)) {
                                          return widget.itemColor?.hovered ??
                                              _currentItemColor.hovered;
                                        }

                                        /// Color When is element selected
                                        if ((!isGroupingTitle &&
                                            _isSelected(result))) {
                                          return widget.itemColor?.selected ??
                                              _currentItemColor.selected;
                                        }

                                        /// Default color, No selected, no hovered.
                                        return widget.itemColor?.unSelected ??
                                            _currentItemColor.unSelected;
                                      }),
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
                            child:
                                widget.itemMenuButton ??
                                Padding(
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
              );
            },
          ),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }

  /// Define arrow down or Up.
  void _arrowEnableOrNot() => setState(() => _isTap = !_isTap);

  /// Define if the element is selected.
  bool _isSelected(Choice val) {
    return _selectedChoice
        .where(
          (element) =>
              (val.key != null || val.key!.isNotEmpty) &&
              element.key == val.key,
        )
        .isNotEmpty;
  }

  /// Scrolling to selected item.
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
        /// If there are already selected elements, clear the selection and the input field.
        /// Set `isUsingRemove` to true to indicate that a removal operation is occurring,
        /// preventing the selected elements from being updated by default data.
        if (_selectedChoice.isNotEmpty &&
            _isSelected(va) &&
            !widget.isMandatory) {
          _selectedChoice.clear();
          _textController.clear();
        } else {
          /// If no elements are selected, add the new Choice and update the input field with its value.
          _selectedChoice = [va];
          _textController.text = va.value;

          /// By changing this to true, the next time we open the dropdown, we will have all the items in the list.
          _onSelected = true;

          /// When select any element we need focus again on TextField if is in use.
          if (widget.useTextFilter && !_focusNodeTextField.hasFocus) {
            _focusNodeTextField.requestFocus();
          }
        }

        /// Ensure that when the dropdown is opened again, all items are available for selection.
        _onSelected = _selectedChoice.isNotEmpty;
      } else {
        /// If the item is already selected, remove it from the list and mark `isUsingRemove` as true.
        if (_isSelected(va)) {
          if (widget.isMandatory) {
            if (_selectedChoice.isNotEmpty) {
              _selectedChoice.remove(va);
            }
          } else {
            _selectedChoice.remove(va);
          }
        } else {
          /// Otherwise, add the new Choice to the list and reset `isUsingRemove` to false.
          _selectedChoice.add(va);

          if (widget.useTextFilter && !_focusNodeTextField.hasFocus) {
            _focusNodeTextField.requestFocus();
          }
        }
      }

      /// Trigger the `onSelect` callback with the updated list of selected elements if it's not empty.
      widget.onSelect(_selectedChoice, false);

      /// Clean filtering
      _onFilteredChoice = _cleanData;

      // Update the UI with the latest state.
      setState(() {});
    }
  }
}

/// [Choice]
/// A generic class that standardizes elements for consistent manipulation.
///
/// The `Choice` class provides a standardized way to handle different types of
/// elements within a list, menu, or selection field. Each instance of `Choice`
/// contains a unique key (`key`), a display value (`value`), and optional metadata
/// of any type, making it highly versatile.
///
/// This class is particularly useful in scenarios where selections, dropdowns,
/// or other user interface components require a consistent structure for the data
/// presented to the user.
///
/// ### Use of the `key` Field:
///
/// The `key` field serves a dual purpose:
///
/// 1. **Quick Validations**:
///    - **Unique Identification**: Each `Choice` can have a unique `key` that facilitates
///      the identification and validation of selected items.
///    - **Search and Filter Operations**: Enables efficient searches and filters based on the key.
///
/// 2. **Grouping of Elements**:
///    - **Contextual Grouping**: By assigning a specific `key` (e.g., an empty string `''` or null ),
///      it can be used to group the following elements under a unique context.
///    - **Group Title**: If a `Choice` has an empty `key` (`''` or `null`), it is interpreted as the title
///      of a group. All elements following this title, until another `Choice` with an empty `key`
///      is encountered, will be grouped under this title.
///    - That `null` value is recommended
///
/// ### Grouping Example:
///
/// ```dart
/// List<Choice<dynamic>> options = [
///   Choice('Group A'), // Group title
///   Choice('1', 'Option A1'),
///   Choice('2', 'Option A2'),
///   Choice('', 'Group B'), // New group title
///   Choice('3', 'Option B1'),
///   Choice('4', 'Option B2'),
/// ];
/// ```
/// In this example:
/// - "Group A" is the title of the first group containing "Option A1" and "Option A2".
/// - "Group B" is the title of the second group containing "Option B1" and "Option B2".
///
/// ### Parameters:
/// - **[key]** (`String` or `null`):
///   - **Description**: An optional and unique identifier for the Choice.
///   - **Usage in Validations**: Facilitates quick validations and search operations.
///   - **Usage in Grouping**: If left empty (`''`), the Choice will act as the title of a group.
///     The following Choices will be part of this group until another empty `key` is found.
///   - **Note**: The `key` cannot be null; it must have a value or be an empty string.
/// - **[value]** (`String`):
///   - **Description**: The text to be displayed in the user interface.
/// - **[metadata]** (`T?`):
///   - **Description**: Additional data associated with the Choice, which can be used to
///     store extra information related to this item.
///
/// ### Usage Examples:
///
/// ```dart
/// // A Choice with a string as metadata.
/// Choice<String> stringChoice = Choice('1', 'Option 1', metadata: 'This is a string');
///
/// // A Choice with a UserProfile object as metadata.
/// Choice<UserProfile> userProfileChoice = Choice('2', 'Jhonatan', metadata: UserProfile('Jhonatan', 30));
///
/// // A Choice without metadata, used as a group title.
/// Choice<void> groupTitle = Choice('User Group');
/// ```
///
/// ### Complete Class:
///
/// ```dart
/// class Choice<T> {
///   final String key;
///   final String value;
///   final T? metadata;
///
///   Choice(this.key, this.value, {this.metadata});
/// }
/// ```
class Choice<T> {
  final String? key;
  final String value;
  final T? metadata;

  Choice(this.key, this.value, {this.metadata});

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

bool isSameData<T>(List<Choice<T>> list1, List<Choice<T>> list2) {
  if (list1.length != list2.length) return false;

  return Set.from(list1).containsAll(list2);
}

class ItemColor {
  final Color? selected;
  final Color? hovered;
  final Color? unSelected;

  ItemColor({this.selected, this.hovered, this.unSelected});
}
