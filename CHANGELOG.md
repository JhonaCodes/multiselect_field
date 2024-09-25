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
