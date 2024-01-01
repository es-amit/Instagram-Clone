

import 'package:flutter/material.dart';

extension DismissKeyboad on Widget{
  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}