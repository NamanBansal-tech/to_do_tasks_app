import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_tasks/screens/home_page.dart';
import 'package:to_do_tasks/utils/app_strings.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (_, child) {
          return MaterialApp(
            title: AppStrings.toDoTasks,
            navigatorKey: navigatorKey,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                color: Colors.blueAccent,
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.blue,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
              radioTheme: RadioThemeData(
                fillColor: WidgetStateProperty.all(Colors.blue),
                overlayColor:
                    WidgetStateProperty.all(Colors.blue.withOpacity(0.2)),
              ),
              switchTheme: SwitchThemeData(
                trackColor: WidgetStateProperty.resolveWith(
                  (state) {
                    if (state.contains(WidgetState.selected)) {
                      return Colors.blue;
                    }
                    return Colors.blue.withOpacity(0.2);
                  },
                ),
              ),
              progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: Colors.blueAccent,
              ),
              inputDecorationTheme: InputDecorationTheme(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                ),
                hintStyle: TextStyle(color: Colors.grey[400]),
                labelStyle: TextStyle(color: Colors.blueAccent[400]),
              ),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        });
  }
}
