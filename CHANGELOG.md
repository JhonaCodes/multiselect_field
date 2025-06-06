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
