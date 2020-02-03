import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/app_model.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/mediaitemdetails.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: SafeArea(
          top: true,
          bottom: false,
          child: CustomScrollView(
            shrinkWrap: false,
            slivers: <Widget>[
              _buildAppBar(),
              _buildSynopsisSection(),
              _buildContentSection(),
            ],
          ),
        ));
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 240.0,
      title: Text(widget._mediaItem.title),
      pinned: true,
      actions: <Widget>[
        Consumer<AppModel>(
          builder: (BuildContext context, AppModel appModel, Widget child) {
            return IconButton(
                icon: Icon(appModel.isItemFavorite(widget._mediaItem) ? Icons.favorite : Icons.favorite_border),
                onPressed: () => appModel.toggleFavorites(widget._mediaItem));
          },
        )
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
            _buildMetaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaSection() {
    // TODO does this animation add any value?
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(seconds: 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextBubble(
                  widget._mediaItem.getReleaseYear().toString(),
                  backgroundColor: const Color(0xffF47663),
                ),
                Container(
                  width: 8.0,
                ),
                TextBubble(widget._mediaItem.voteAverage.toString(), backgroundColor: const Color(0xffF47663)),
              ],
            ),
            Container(
              height: 50.0,
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: widget._mediaItem.genres.map((String genre) {
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

  Widget _buildSynopsisSection() {
    return SliverList(
        delegate: SliverChildListDelegate.fixed(<Widget>[
          Container(
            decoration: BoxDecoration(color: const Color(0xff222128)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('SYNOPSIS', style: const TextStyle(color: Colors.white)),
                  Container(height: 8.0),
                  Text(widget._mediaItem.overview, style: const TextStyle(color: Colors.white, fontSize: 12.0)),
                  Container(height: 8.0),
                ],
              ),
            ),
          ),
        ]));
  }

  Widget _buildContentSection() {
    final MediaProvider mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    return FutureBuilder<MediaItemDetails>(
      future: mediaProvider.getDetails(widget._mediaItem),
      builder: (BuildContext context, AsyncSnapshot<MediaItemDetails> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // TODO how to center the progress indicator in the remaining space?
          return SliverList(
              delegate: SliverChildListDelegate.fixed(
                  <Widget>[Padding(padding: const EdgeInsets.all(20), child: Center(child: const CircularProgressIndicator()))]));
        }

        // TODO need to check for error
        MediaItemDetails mediaItemDetails = snapshot.data;
        return SliverList(
          delegate: SliverChildListDelegate.fixed(<Widget>[
            Container(
              decoration: BoxDecoration(color: primary),
              child: Padding(padding: const EdgeInsets.all(16.0), child: CastSection(mediaItemDetails.actors)),
            ),
            Container(
              decoration: BoxDecoration(color: primaryDark),
              child: Padding(padding: const EdgeInsets.all(16.0), child: MetaSection(widget._mediaItem, mediaItemDetails)),
            ),
            (widget._mediaItem.type != MediaType.show || mediaItemDetails.seasons == null)
                ? Container()
                : Container(
              decoration: BoxDecoration(color: primary),
              child: Padding(padding: const EdgeInsets.all(16.0), child: SeasonSection(widget._mediaItem, mediaItemDetails.seasons)),
            ),
            Container(
                decoration: BoxDecoration(color: widget._mediaItem.type == MediaType.movie ? primary : primaryDark),
                child: mediaItemDetails?.similarMedia == null ? Container() : SimilarSection(mediaItemDetails.similarMedia))
          ]),
        );
      },
    );
  }
}
