
---

# MultiSelectField

![multiselect_field](https://github.com/user-attachments/assets/447968f9-2256-47d2-afef-8b3da5ab108b)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![text_field_validation](https://img.shields.io/pub/v/multiselect_field.svg)](https://pub.dev/packages/multiselect_field)
[![Dart 3](https://img.shields.io/badge/Dart-3%2B-blue.svg)](https://dart.dev/)
[![Flutter 3.10](https://img.shields.io/badge/Flutter-3%2B-blue.svg)](https://flutter.dev/)

`MultiSelectField` is a custom implementation of a multi-select field for Flutter applications. This library provides a flexible and highly configurable solution for projects that require native multi-selection, real-time text filtering, and more advanced features.

## Features

- **Flexibility**: Complete control over the widget's design and behavior, allowing precise customizations according to project requirements.
- **Native multi-selection**: Implements multi-select functionality natively without the need for additional packages or complex modifications.
- **Advanced features**: Includes real-time text filtering and the display of selected items as chips, enhancing the user experience.
- **Maintenance and evolution**: As a custom implementation, it allows easy adaptation and evolution as project needs change.
- **Independence**: Avoids third-party dependencies, improving project stability and long-term control.

## Library

Check out the library on [pub.dev](https://pub.dev/packages/multiselect_field).


## Installation

Add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  multiselect_field: ^1.5.3
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
    return MultiSelectField<Car>(
      data: () => [
        Choice<Car>('Ferrari'),
        Choice<Car>('2', '488 GTB', metadata: Car(103, 27.500, 2015)),
        Choice<Car>('3', '458 Italia', metadata: Car(99, 22.000, 2009)),
        Choice<Car>('4', 'Portofino', metadata: Car(105, 31.000, 2017)),
        Choice<Car>('5', 'California T', metadata: Car(102, 25.000, 2016)),
        Choice<Car>('6', 'F8 Tributo', metadata: Car(104, 30.000, 2019)),
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

- **`data`**: `List<Choice<T>> Function()`. Function that returns a list of `Choice` elements for selection.
- **`onSelect`**: `Function(List<Choice<T>> ChoiceList)`. Callback invoked when items are selected.
- **`title`**: `Widget Function(bool isEmpty)?`. Optional widget that displays a title, depending on whether the selection is empty.
- **`footer`**: `Widget?`. Optional widget displayed at the bottom.
- **`singleSelectWidget`**: `Widget Function(Choice<T> ChoiceList)?`. Optional widget for displaying a single selected item.
- **`multiSelectWidget`**: `Widget Function(Choice<T> ChoiceList)?`. Optional widget for displaying multiple selected items.
- **`defaultData`**: `List<Choice<T>>?`. Optional function that returns the default list of selected items.
- **`singleSelection`**: `bool`. Defines if the widget should allow only a single selection. Defaults to `false`.
- **`useTextFilter`**: `bool`. Enables or disables real-time text filtering.
- **`decoration`**: `Decoration?`. Custom decoration for the widget.
- **`padding`**: `EdgeInsetsGeometry?`. Defines the internal padding of the widget.
- **`textStyleSingleSelection`**: `TextStyle?`. Text style for single selection.

### Advanced Example

```dart
MultiSelectField<String>(
  data: () => [
    Choice(key: 'apple', value: 'Apple'),
    Choice(key: 'banana', value: 'Banana'),
    Choice(key: 'orange', value: 'Orange'),
  ],
  defaultData: [Choice(key: 'banana', value: 'Banana')],
  ///[isFromDefault] Helps to know if current selected element is from default data or not.
  onSelect: (selectedItems, isFromDefaultData) {
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

## Some screen captures
### With grouping list.
<img width="284" alt="Screenshot 2024-09-04 at 9 45 32 PM" src="https://github.com/user-attachments/assets/63dcf1f3-7e17-478c-bc6b-7576b35cf03b">

### Multiple selection.
<img width="282" alt="Screenshot 2024-09-04 at 9 54 57 PM" src="https://github.com/user-attachments/assets/b481dcb4-1e0a-444e-bb0a-06c7b98e40d7">

### Multiple selection custom widget.
<img width="281" alt="Screenshot 2024-09-04 at 9 55 49 PM" src="https://github.com/user-attachments/assets/515e49ae-a216-4fb1-bf1c-c054d07afa97">

### Text Filtering.
<img width="283" alt="Screenshot 2024-09-04 at 9 56 50 PM" src="https://github.com/user-attachments/assets/34fb2ea0-140f-4375-8625-bf9439208094">

### With title and footer.
<img width="287" alt="Screenshot 2024-09-04 at 9 54 03 PM" src="https://github.com/user-attachments/assets/72800d4d-e2f8-44ef-8147-46fe145db6ac">


### Video example
![ScreenRecording2024-09-05at12 19 59AM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/43841493-b8ba-4a3c-a1a7-7ba899f7b567)


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
