## 2.0.0
### Breaking Changes
- **`onSelect` is now optional** in the Standard variant. Previously `required`, it is now nullable across all variants. You can use `onSelect`, `onChanged`, or both.

### New Feature: `closeOnSelect` — Auto-close menu on selection
Automatically close the menu after each item selection. Available in all variants: Standard, BottomSheet, and Drawer.

- **`closeOnSelect`**: `bool`, defaults to `false`. When `true`, the menu/sheet/drawer closes immediately after an item is selected.
- Callbacks (`onSelect`, `onChanged`) fire before closing.

### New Feature: `onChanged` callback
Simple callback that fires **only on user interaction**, never on default data changes. Available in all 4 variants.

- **`onChanged: (List<Choice<T>> selectedItems) {}`**: No `isFromDefaultData` flag — just the selected items.
- **`onSelect`** remains unchanged (still receives the `isFromDefaultData` flag).
- Both are optional. Use `onChanged` when you only care about user-driven selections, `onSelect` when you need to distinguish default data.

### New Feature: `FieldWidth` — Field width control
Control the Standard variant width without wrapping in `SizedBox`.

- **`FieldWidth.fitContent`**: Field shrinks to fit its label/chips (compact inline selector).
- **`FieldWidth.fixed(double)`**: Field uses a specific width in pixels.
- **Default (`null`)**: Fills available width (unchanged behavior).

### New Feature: `iconSpacing` — Dropdown icon spacing
Control the gap between the label/chips area and the dropdown arrow icon in the Standard variant.

- **`iconSpacing`**: `double`, defaults to `0` (minimal gap). Only applies when `iconRight` is null.
- The default dropdown icon no longer uses a fixed `SizedBox(40x20)` wrapper, resulting in a tighter layout by default.

### Bugfix
- Fixed `_cleanData` crash when using `selectAllOption` with grouped data (null key caused null check error).

## 1.8.0
### New Display Modes: `.drawer()` and `.bottomSheet()`
Two new factory constructors for opening the selection menu in a drawer or bottom sheet.

#### `MultiSelectField<T>.bottomSheet()`
Modal bottom sheet with drag handle, customizable height, and full style control.

- **`BottomSheetStyle`**: Configure `maxHeightFraction`, `fixedHeight`, `backgroundColor`, `borderRadius`, `showDragHandle`, `dragHandleColor`, `dragHandleWidth`, `barrierColor`, and animation parameters.
- **Custom trigger**: Pass any `child` widget as the tap target, or use the built-in default trigger with label.
- **Header/footer**: `menuHeader` and `menuFooter` widgets inside the sheet.
- Supports all existing selection features: single/multi selection, groups, select all, custom `menuContent`.

#### `MultiSelectField<T>.drawer()`
Two modes depending on whether `scaffoldKey` is provided:

- **Scaffold mode** (`scaffoldKey` provided): Renders selection content directly. Place inside `Scaffold.endDrawer` or `Scaffold.drawer`. Use `MultiSelectKeyStore` to open/close programmatically.
- **Overlay mode** (no `scaffoldKey`): Renders a trigger button that opens a standalone overlay drawer on tap. Respects `SafeArea`, dismissible by tapping outside. Custom trigger via `child`.
- **`DrawerStyle`**: Configure `width`, `backgroundColor`, `borderRadius`, `boxShadow`, `barrierColor`, `position` (left/right), and animation parameters.
- **`DrawerPosition`**: Enum to control which side the drawer slides in from (`left` or `right`).

#### `MultiSelectKeyStore` — Programmatic drawer control
Singleton key store for sharing state between trigger and content widgets.

- **`MultiSelectKeyStore.of<T>("keyName")`**: Get or create a shared `DrawerStore`.
- **`store.openDrawer()`** / **`store.closeDrawer()`**: Open or close the Scaffold drawer programmatically from anywhere.
- **`MultiSelectKeyStore.dispose("keyName")`**: Clean up a store when no longer needed.
- **`MultiSelectKeyStore.disposeAll()`**: Remove all stores.

#### Shared `SelectionContent<T>` widget
Extracted the selection list rendering into a reusable `SelectionContent<T>` widget. `ChipMenuContent<T>` is now a backward-compatible typedef.

## 1.7.0
### New Feature: `MultiSelectField.chip()`
Compact chip-style dropdown for space-constrained areas like filter bars.

- **`MultiSelectField<T>.chip()`**: New factory constructor for chip variant.
- **`ChipSize`**: Proportional sizing system (extraSmall, small, medium, large, extraLarge) or custom sizes.
- **`ChipStyle`**: Color and appearance configuration with `withColor()` and `styled()` factories.
- **`ChipMenuStyle`**: Menu dimensions and style configuration.
- **Customizable menu**: `titleMenuStyle`, `itemMenuStyle`, `titleMenuPadding` for group titles.
- **Flexible content**: Use `data` for auto-generated lists or `menuContent` for custom widgets.

## 1.6.8
- New feature `ScrollbarConfig`, Now we can modify the size, color, margins, etc. of our scrollbar in a very easy way.

## 1.6.7
- Improve documentation.
- Update menu `currentMenuHeight`.

## 1.6.6
- Fix margin on section title.

## 1.6.5
- Fix: Resolved the issue where the menu was not adjusting correctly when the keyboard was active and there wasn't enough space below for its display. Now, the menu opens at the top in such cases.
Related to issue: (https://github.com/JhonaCodes/multiselect_field/issues/8)

## 1.6.4
## 1.6.3
## 1.6.2
- UI enhancements, including padding and layout adjustments.

## 1.6.1
- New feature `itemColor`, Customize the colors for selected, hovered, and unselected items.

## 1.6.0
- New feature `selectAllOption`, You will have a default option to select all the items on your list.
- Solve transparent color on `x` delete widget. 

## 1.5.5
- Some format tweaks.
- Update to `withValues` on colors.

## 1.5.4
- Use withValues on style.

## 1.5.3
- Upgrade dev lib.
- upgrade sdk version.

## 1.5.2
- Attribute label text.

## 1.5.1
- Format.

## 1.5.0
- New functionality added, now you can clear the entire current selection using `cleanCurrentSelection`.

## 1.4.2
- Remove unnecessary validation on `didUpdateWidget`, in favour `isFromDefaultData`

## 1.4.1
- `isFromDefaultData`, Helps to know if onSelect data comes from defaultData.

## 1.4.0
### Breaking changes:
- DefaultValue is no longer a function; it should now be used as `defaultData: []`.
- If you update the data in `defaultData`, it triggers the execution of `onSelect(element)`.
- Small change on logic for `didUpdateWidget`.
- Improve logic for default value.
- Improve validation for selected element and title of elements. 
- More improvements.

## 1.3.0
- `Pick` was removed in favor of `Choice`
- The `key` value can now be null to determine the group title.

## 1.2.1
- Remove default color on list background and surface
- Implement dispose for Time render `Help for your testing`

## 1.2.0
- New feature `isMandatory`.
- Edit style Title and item from list items.

## 1.1.1
- Validate value on `didUpdateWidget`, helps to avoid continuous calling.

## 1.1.0
### You can now:
- Set fixed menu width.
- Set fixed menu height.
- Set max menu width.
- Set max menu height.
- Set menu styles.
- Set menu options widget.
- Set menu options margins.
- Set left icon of main search widget.
- Set right icon of main search widget.
- Some logging to keep clear the current lifecycle status.
- Improved some logic parts, and more.

## 1.0.2
- Avoid dispose when using ListView.

## 1.0.1
- Update info.

## 1.0.0
- Initial version.
