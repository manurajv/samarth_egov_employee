import 'package:flutter/material.dart';
import 'package:samarth_egov_employee/app/app.dart';
import 'package:samarth_egov_employee/app/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppInitializer());
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: configureDependencies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Error initializing app: ${snapshot.error}'),
                ),
              ),
            );
          }
          return const MyApp();
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}