import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/app_model.dart';
import 'package:flutter_cinematic/model/cast.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/tvseason.dart';
import 'package:flutter_cinematic/util/mediaprovider.dart';
import 'package:flutter_cinematic/util/styles.dart';
import 'package:flutter_cinematic/widgets/media_detail/cast_section.dart';
import 'package:flutter_cinematic/widgets/media_detail/meta_section.dart';
import 'package:flutter_cinematic/widgets/media_detail/season_section.dart';
import 'package:flutter_cinematic/widgets/media_detail/similar_section.dart';
import 'package:flutter_cinematic/widgets/utilviews/bottom_gradient.dart';
import 'package:flutter_cinematic/widgets/utilviews/text_bubble.dart';
import 'package:provider/provider.dart';

// TODO this widget should honor the selected theme
class MediaDetailScreen extends StatefulWidget {
  MediaDetailScreen(this._mediaItem);

  final MediaItem _mediaItem;

  @override
  MediaDetailScreenState createState() {
    return MediaDetailScreenState();
  }
}

class MediaDetailScreenState extends State<MediaDetailScreen> {
  List<Actor> _actorList;
  List<TvSeason> _seasonList;
  List<MediaItem> _similarMedia;
  dynamic _mediaDetails;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // TODO these can be all loaded together in one query (see https://developers.themoviedb.org/3/getting-started/append-to-response)
    final MediaProvider mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    _loadCast(mediaProvider);
    _loadDetails(mediaProvider);
    _loadSimilar(mediaProvider);
    if (widget._mediaItem.type == MediaType.show) {
      _loadSeasons(mediaProvider);
    }

    Timer(Duration(milliseconds: 100), () => setState(() => _visible = true));
  }

  Future<void> _loadCast(MediaProvider mediaProvider) async {
    try {
      final cast = await mediaProvider.loadCast(widget._mediaItem);
      setState(() => _actorList = cast);
    } catch (e) {
      //No debería generar excepcion
    }
  }

  Future<void> _loadDetails(MediaProvider mediaProvider) async {
    try {
      final dynamic details = await mediaProvider.getDetails(widget._mediaItem);
      setState(() => _mediaDetails = details);
    } catch (e) {
      e.toString();
    }
  }

  Future<void> _loadSeasons(MediaProvider mediaProvider) async {
    try {
      final seasons = await mediaProvider.getShowSeasons(widget._mediaItem);
      setState(() => _seasonList = seasons);
    } catch (e) {
      //No debería generar excepcion
    }
  }

  Future<void> _loadSimilar(MediaProvider mediaProvider) async {
    try {
      final similar = await mediaProvider.getSimilar(widget._mediaItem);
      setState(() => _similarMedia = similar);
    } catch (e) {
      //No debería generar excepcion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: SafeArea(
          top: true,
          bottom: false,
          child: CustomScrollView(
            slivers: <Widget>[
              _buildAppBar(context, widget._mediaItem),
              _buildContentSection(widget._mediaItem),
            ],
          ),
        ));
  }

  Widget _buildAppBar(BuildContext context, MediaItem movie) {
    var appModel = Provider.of<AppModel>(context);
    return SliverAppBar(
      expandedHeight: 240.0,
      title: Text(widget._mediaItem.title),
      pinned: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(appModel.isItemFavorite(widget._mediaItem) ? Icons.favorite : Icons.favorite_border),
            onPressed: () => appModel.toggleFavorites(widget._mediaItem))
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: 'Movie-Tag-${widget._mediaItem.id}',
              child: CachedNetworkImage(
                placeholder: (context, url) => Image.asset('assets/placeholder.jpg'),
                fit: BoxFit.cover,
                width: double.infinity,
                imageUrl: widget._mediaItem.getBackDropUrl(),
              ),
            ),
            BottomGradient(),
            _buildMetaSection(movie)
          ],
        ),
      ),
    );
  }

  Widget _buildMetaSection(MediaItem mediaItem) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextBubble(
                  mediaItem.getReleaseYear().toString(),
                  backgroundColor: const Color(0xffF47663),
                ),
                Container(
                  width: 8.0,
                ),
                TextBubble(mediaItem.voteAverage.toString(), backgroundColor: const Color(0xffF47663)),
              ],
            ),
            Container(
              height: 50.0,
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: mediaItem.genres.map((String genre) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
                      child: Chip(
                        label: Text(genre, style: TextStyle(color: Colors.white, fontSize: 12.0)),
                        backgroundColor: const Color(0xFF424242),
                      ),
                    );
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(MediaItem media) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: BoxDecoration(color: const Color(0xff222128)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'SYNOPSIS',
                  style: const TextStyle(color: Colors.white),
                ),
                Container(
                  height: 8.0,
                ),
                Text(media.overview, style: const TextStyle(color: Colors.white, fontSize: 12.0)),
                Container(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: primary),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _actorList == null
                  ? Center(
                      child: const CircularProgressIndicator(),
                    )
                  : CastSection(_actorList)),
        ),
        Container(
          decoration: BoxDecoration(color: primaryDark),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _mediaDetails == null
                  ? Center(
                      child: const CircularProgressIndicator(),
                    )
                  : MetaSection(_mediaDetails)),
        ),
        (widget._mediaItem.type == MediaType.show)
            ? Container(
                decoration: BoxDecoration(color: primary),
                child: Padding(
                    padding: const EdgeInsets.all(16.0), child: _seasonList == null ? Container() : SeasonSection(widget._mediaItem, _seasonList)),
              )
            : Container(),
        Container(
            decoration: BoxDecoration(color: widget._mediaItem.type == MediaType.movie ? primary : primaryDark),
            child: _similarMedia == null ? Container() : SimilarSection(_similarMedia))
      ]),
    );
  }
}
