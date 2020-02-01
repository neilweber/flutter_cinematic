import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/episode.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/tvseason.dart';
import 'package:flutter_cinematic/util/mediaprovider.dart';
import 'package:flutter_cinematic/util/styles.dart';
import 'package:flutter_cinematic/widgets/season_detail/episode_card.dart';
import 'package:provider/provider.dart';

class SeasonDetailScreen extends StatelessWidget {
  final MediaItem show;
  final TvSeason season;

  SeasonDetailScreen(this.show, this.season);

  @override
  Widget build(BuildContext context) {
    final MediaProvider mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: primary,
        body: CustomScrollView(
          slivers: <Widget>[_buildAppBar(), _buildEpisodesList(mediaProvider)],
        ));
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            Column(
              children: <Widget>[
                CachedNetworkImage(
                    placeholder: (context, url) => Image.asset('assets/placeholder.jpg'),
                    fit: BoxFit.cover,
                    height: 230.0,
                    width: double.infinity,
                    imageUrl: show.getBackDropUrl()),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            show.title,
                            style: captionStyle,
                          ),
                          Container(
                            height: 4.0,
                          ),
                          Text('Season ${season.seasonNumber}', style: whiteBody.copyWith(fontSize: 18.0)),
                          Container(
                            height: 4.0,
                          ),
                          Text(
                            '${season.getReleaseYear()} - ${season.episodeCount} Episodes',
                            style: captionStyle,
                          )
                        ],
                      ),
                    ),
                    color: primaryDark,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Hero(
                tag: 'Season-Hero-${season.id}',
                child: CachedNetworkImage(
                  placeholder: (context, url) => Image.asset('assets/poster_placeholder.jpg'),
                  width: 100.0,
                  imageUrl: season.getPosterUrl(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodesList(MediaProvider mediaProvider) {
    return SliverList(
        delegate: SliverChildListDelegate(<Widget>[
      FutureBuilder(
          future: mediaProvider.fetchEpisodes(show.id, season.seasonNumber),
          builder: (BuildContext context, AsyncSnapshot<List<Episode>> snapshot) => snapshot.connectionState != ConnectionState.done
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: const CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: snapshot.data.map((Episode episode) => EpisodeCard(episode)).toList(),
                ))
    ]));
  }
}
