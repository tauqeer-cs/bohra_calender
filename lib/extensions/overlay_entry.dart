import 'package:flutter/material.dart';

extension OverlayEntryExtension on OverlayEntry {
  void removeAnyWay() {
    try {
      this.remove();
    } catch (_) {}
  }
}
