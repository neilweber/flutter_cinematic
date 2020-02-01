import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cinematic/app.dart';
import 'package:flutter_cinematic/model/app_model.dart';
import 'package:flutter_cinematic/util/mediaprovider.dart';
import 'package:flutter_cinematic/util/tmdb_client.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // See https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = kReleaseMode ? Level.WARNING : Level.ALL;
  Logger.root.onRecord.listen((record) {
    developer.log('${record.level.name}: ${record.message}', name: record.loggerName, time: record.time, level: record.level.value);
  });

  final sharedPreferences = await SharedPreferences.getInstance();
  final storageDirectory = await getExternalStorageDirectory();
  final tmdbClient = TmdbClient(storageDirectory);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppModel>(create: (_) => AppModel(sharedPreferences)),
      Provider<MediaProvider>(create: (_) => MediaProvider(tmdbClient)),
    ],
    child: CinematicApp(),
  ));
}
