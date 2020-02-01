import 'package:flutter/material.dart';
import 'package:flutter_cinematic/widgets/home_page.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Users/Neil/Projects/flutter_cinematic/lib/model/app_model.dart';

class CinematicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cinematic',
      theme: Provider.of<AppModel>(context).theme,
      home: HomePage(),
    );
  }
}
