import 'package:flutter/services.dart';

/// Copie une chaîne dans le presse-papiers (encapsulée pour être testable).
class SupportClipboard {
  const SupportClipboard();

  Future<bool> copy(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (_) {
      return false;
    }
  }
}
