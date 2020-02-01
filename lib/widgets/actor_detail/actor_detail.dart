import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/cast.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/util/mediaprovider.dart';
import 'package:flutter_cinematic/util/styles.dart';
import 'package:flutter_cinematic/widgets/media_list/media_list_item.dart';
import 'package:flutter_cinematic/widgets/utilviews/fitted_circle_avatar.dart';
import 'package:provider/provider.dart';

// TODO this widget should honor the selected theme
class ActorDetailScreen extends StatelessWidget {
  ActorDetailScreen(this._actor);

  final Actor _actor;

  @override
  Widget build(BuildContext context) {
    final MediaProvider mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    final movieFuture = mediaProvider.getMoviesForActor(_actor.id);
    final showFuture = mediaProvider.getShowsForActor(_actor.id);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: primary,
        body: NestedScrollView(
          body: TabBarView(
            children: <Widget>[
              _buildMoviesSection(movieFuture),
              _buildMoviesSection(showFuture),
            ],
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [_buildAppBar(context, _actor)],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Actor actor) {
    return SliverAppBar(
      expandedHeight: 210.0,
      title: Text(actor.name),
      bottom: TabBar(
        tabs: <Widget>[
          const Tab(
            icon: Icon(Icons.movie),
          ),
          const Tab(
            icon: Icon(Icons.tv),
          ),
        ],
      ),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            const Color(0xff2b5876),
            const Color(0xff4e4376),
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).padding.top,
              ),
              Hero(
                  tag: 'Cast-Hero-${actor.id}',
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    child: FittedCircleAvatar(
                      // TODO should deal with blank or missing profile pictures
                      backgroundImage: CachedNetworkImageProvider(actor.profilePictureUrl),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesSection(Future<List<MediaItem>> future) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<MediaItem>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) => MediaListItem(snapshot.data[index]),
                itemCount: snapshot.data.length,
              )
            : Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(child: const CircularProgressIndicator()),
              );
      },
    );
  }
}
