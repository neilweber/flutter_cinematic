import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/util/navigator.dart';
import 'package:flutter_cinematic/util/utils.dart';

class MediaListItem extends StatelessWidget {
  MediaListItem(this.mediaItem);

  final MediaItem mediaItem;

  Widget _getTitleSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    mediaItem.title,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    getGenreString(mediaItem.genreIds),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 12.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    mediaItem.voteAverage.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Container(
                    width: 4.0,
                  ),
                  const Icon(
                    Icons.star,
                    size: 16.0,
                  )
                ],
              ),
              Container(
                height: 4.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    mediaItem.getReleaseYear().toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Container(
                    width: 4.0,
                  ),
                  const Icon(
                    Icons.date_range,
                    size: 16.0,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => goToMediaDetails(context, mediaItem),
        child: Column(
          children: <Widget>[
            // This SizedBox is needed because CachedNetworkImage ignores width&height until cached image is loaded
            // https://github.com/renefloor/flutter_cached_network_image/issues/328
            SizedBox(
              width: double.infinity,
              height: 200.0,
              child: Hero(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Image.asset('assets/placeholder.jpg'),
                  imageUrl: mediaItem.getBackDropUrl(),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                  fadeInDuration: Duration(milliseconds: 50),
                ),
                tag: 'Movie-Tag-${mediaItem.id}',
              ),
            ),
            _getTitleSection(context),
          ],
        ),
      ),
    );
  }
}
