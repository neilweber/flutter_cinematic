import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/app_model.dart';
import 'package:provider/provider.dart';

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
