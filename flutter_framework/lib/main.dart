// Re-export app so consumers/tests can reference MyApp via
// `package:flutter_framework/main.dart`.
export 'src/app.dart';

import 'package:flutter/material.dart';
import 'src/app.dart';

void main() {
  runApp(const MyApp());
}
