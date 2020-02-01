import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/cast.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/tvseason.dart';
import 'package:flutter_cinematic/widgets/actor_detail/actor_detail.dart';
import 'package:flutter_cinematic/widgets/favorites/favorite_screen.dart';
import 'package:flutter_cinematic/widgets/media_detail/media_detail.dart';
import 'package:flutter_cinematic/widgets/search/search_page.dart';
import 'package:flutter_cinematic/widgets/season_detail/season_detail_screen.dart';

void goToMediaDetails(BuildContext context, MediaItem mediaItem) {
  _pushWidgetWithFade(context, MediaDetailScreen(mediaItem));
}

void goToSeasonDetails(BuildContext context, MediaItem show, TvSeason season) => _pushWidgetWithFade(context, SeasonDetailScreen(show, season));

void goToActorDetails(BuildContext context, Actor actor) {
  _pushWidgetWithFade(context, ActorDetailScreen(actor));
}

void goToSearch(BuildContext context) {
  _pushWidgetWithFade(context, SearchScreen());
}

void goToFavorites(BuildContext context) {
  _pushWidgetWithFade(context, FavoriteScreen());
}

void _pushWidgetWithFade(BuildContext context, Widget widget) {
  Navigator.of(context).push<Widget>(
    PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return widget;
        }),
  );
}
