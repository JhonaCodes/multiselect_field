import 'package:flutter/material.dart';

import 'package:multiselect_field/core/multi_select.dart';

/// Singleton registry for programmatic drawer control.
///
/// Example:
/// ```dart
/// final store = MultiSelectKeyStore.of<String>("myFilter");
///
/// // Open/close from anywhere
/// store.openDrawer();
/// store.closeDrawer();
/// ```
class MultiSelectKeyStore {
  MultiSelectKeyStore._();

  static final Map<String, DrawerStore<dynamic>> _stores = {};

  /// Gets or creates a [DrawerStore] for the given [keyName].
  static DrawerStore<T> of<T>(String keyName) {
    return _stores.putIfAbsent(keyName, () => DrawerStore<T>())
        as DrawerStore<T>;
  }

  /// Removes a store by name. Call this to clean up when no longer needed.
  static void dispose(String keyName) {
    _stores.remove(keyName);
  }

  /// Removes all stores.
  static void disposeAll() {
    _stores.clear();
  }
}

/// Holds a reference to the Scaffold for programmatic drawer open/close.
class DrawerStore<T> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  DrawerPosition _position = DrawerPosition.right;

  /// Registers the scaffold key for programmatic drawer control.
  void registerScaffold(
    GlobalKey<ScaffoldState> scaffoldKey, {
    DrawerPosition position = DrawerPosition.right,
  }) {
    _scaffoldKey = scaffoldKey;
    _position = position;
  }

  /// Opens the Scaffold drawer programmatically.
  void openDrawer() {
    final state = _scaffoldKey?.currentState;
    if (state == null) return;
    if (_position == DrawerPosition.right) {
      state.openEndDrawer();
    } else {
      state.openDrawer();
    }
  }

  /// Closes the Scaffold drawer programmatically.
  void closeDrawer() {
    final state = _scaffoldKey?.currentState;
    if (state == null) return;
    if (state.isEndDrawerOpen || state.isDrawerOpen) {
      Navigator.of(state.context).pop();
    }
  }
}
