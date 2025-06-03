import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app/app.dart';
import 'app/di/injector.dart';
import 'app/di/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependencies
  await configureDependencies();

  // Verify all dependencies are registered
  try {
    GetIt.instance.allReady().then((_) {
      final router = createRouter();
      runApp(MyApp(router: router));
    });
  } catch (e) {
    print('Error configuring dependencies: $e');
    rethrow;
  }
}