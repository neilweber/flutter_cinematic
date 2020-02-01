import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Users/Neil/Projects/flutter_cinematic/lib/model/app_model.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.color_lens,
          color: Colors.white,
        ),
        onPressed: () => Provider.of<AppModel>(context, listen: false).toggleTheme());
  }
}
