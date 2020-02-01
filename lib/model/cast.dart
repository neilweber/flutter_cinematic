import 'package:flutter_cinematic/util/utils.dart';

class Actor {
  String character;
  String name;
  String profilePicture;
  int id;

  String get profilePictureUrl => getMediumPictureUrl(profilePicture ?? '');

  Actor.fromJson(Map jsonMap)
      : character = jsonMap['character'],
        name = jsonMap['name'],
        profilePicture = jsonMap['profile_path'],
        id = jsonMap['id'];
}
