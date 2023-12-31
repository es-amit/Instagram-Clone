

import 'package:flutter/material.dart';

extension DismissKeyboad on Widget{
  void dismissKeyboad() => FocusManager.instance.primaryFocus?.unfocus();
}