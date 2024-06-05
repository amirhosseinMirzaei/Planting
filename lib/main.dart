import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:plant/PlantingPage/presentation/page/planting_page.dart';
import 'package:plant/alert_dialog_service/overlay_widget.dart';
import 'package:plant/alertdialog.dart';
import 'package:plant/database/database_service.dart';
import 'package:plant/main_app_ui/home.dart';
import 'package:plant/main_app_ui/permissions_screen.dart';
import 'package:plant/notification/local_notifictions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:usage_stats/usage_stats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await onStart();
  tz.initializeTimeZones();
  await NotificationService().initNotification();
  DatabaseService dbService = await DatabaseService.instance();
  bool permissionsAvailable = (await UsageStats.checkUsagePermission())! &&
      await FlutterOverlayWindow.isPermissionGranted();
  runApp(MyApp(
      permissionsAvailable ? Home(dbService) : PermissionsScreen(dbService),
      dbService));
}

@pragma("vm:entry-point")
void overlayMain() async {
  debugPrint("Starting Alerting Window Isolate!");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: OverlayWidget()));
}


onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();


}

class MyApp extends StatelessWidget {
  Widget screenToDisplay;

  DatabaseService dbService;
  MyApp(this.screenToDisplay, this.dbService);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),

        home:  screenToDisplay);
  }
}
