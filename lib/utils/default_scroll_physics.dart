import 'dart:io';

import 'package:flutter/material.dart';

ScrollPhysics defaultScrollPhysics() {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return NeverScrollableScrollPhysics();
  }

  return null;
}
