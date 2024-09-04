
---

# MultiSelectField

`MultiSelectField` is a custom implementation of a multi-select field for Flutter applications. This library provides a flexible and highly configurable solution for projects that require native multi-selection, real-time text filtering, and more advanced features.

## Features

- **Flexibility**: Complete control over the widget's design and behavior, allowing precise customizations according to project requirements.
- **Native multi-selection**: Implements multi-select functionality natively without the need for additional packages or complex modifications.
- **Advanced features**: Includes real-time text filtering and the display of selected items as chips, enhancing the user experience.
- **Maintenance and evolution**: As a custom implementation, it allows easy adaptation and evolution as project needs change.
- **Independence**: Avoids third-party dependencies, improving project stability and long-term control.

## Installation

Add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  multiselect_field: ^1.0.0
```

Then, install the dependencies using:

```bash
flutter pub get
```
### Or
```bash
flutter pub add multiselect_field
```

## Usage

### Basic Example

```dart
import 'package:multi_select_field/multiselect_field.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiSelectField<String>(
      data: () => [
        Pick(key: '1', value: 'Option 1'),
        Pick(key: '2', value: 'Option 2'),
        Pick(key: '3', value: 'Option 3'),
      ],
      onSelect: (selectedItems) {
        // Handle selected items here
        print(selectedItems.map((item) => item.value).toList());
      },
      useTextFilter: true, // Enables real-time text filtering
    );
  }
}
```

### Properties

- **`data`**: `List<Pick<T>> Function()`. Function that returns a list of `Pick` elements for selection.
- **`onSelect`**: `Function(List<Pick<T>> pickList)`. Callback invoked when items are selected.
- **`title`**: `Widget Function(bool isEmpty)?`. Optional widget that displays a title, depending on whether the selection is empty.
- **`footer`**: `Widget?`. Optional widget displayed at the bottom.
- **`singleSelectWidget`**: `Widget Function(Pick<T> pickList)?`. Optional widget for displaying a single selected item.
- **`multiSelectWidget`**: `Widget Function(Pick<T> pickList)?`. Optional widget for displaying multiple selected items.
- **`defaultData`**: `List<Pick<T>> Function()?`. Optional function that returns the default list of selected items.
- **`singleSelection`**: `bool`. Defines if the widget should allow only a single selection. Defaults to `false`.
- **`useTextFilter`**: `bool`. Enables or disables real-time text filtering.
- **`decoration`**: `Decoration?`. Custom decoration for the widget.
- **`padding`**: `EdgeInsetsGeometry?`. Defines the internal padding of the widget.
- **`textStyleSingleSelection`**: `TextStyle?`. Text style for single selection.

### Advanced Example

```dart
MultiSelectField<String>(
  data: () => [
    Pick(key: 'apple', value: 'Apple'),
    Pick(key: 'banana', value: 'Banana'),
    Pick(key: 'orange', value: 'Orange'),
  ],
  defaultData: () => [Pick(key: 'banana', value: 'Banana')],
  onSelect: (selectedItems) {
    // Update selection state
  },
  title: (isEmpty) => Text(isEmpty ? 'Select a fruit' : 'Selected fruits'),
  singleSelection: false,
  useTextFilter: true,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.blue),
    borderRadius: BorderRadius.circular(5),
  ),
  padding: EdgeInsets.all(10),
  multiSelectWidget: (item) => Chip(
    label: Text(item.value),
    onDeleted: () {
      // Remove selected item
    },
  ),
);
```



## Some test:
![default_data.png](test%2Fgoldens%2Fmacos%2Fdefault_data.png)
![title_footer.png](test%2Fgoldens%2Fmacos%2Ftitle_footer.png)
![title_footer_custom.png](test%2Fgoldens%2Fmacos%2Ftitle_footer_custom.png)

## Contribution

Contributions are welcome! If you have ideas for new features or improvements, please open an [issue](https://github.com/JhonaCodes/multiselect_field/issues) or submit a pull request.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---