import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/tvseason.dart';
import 'package:flutter_cinematic/util/navigator.dart';
import 'package:flutter_cinematic/util/styles.dart';
import 'package:flutter_cinematic/widgets/utilviews/bottom_gradient.dart';

class SeasonCard extends StatelessWidget {
  SeasonCard(this.show, this.season, {this.height = 140.0, this.width = 100.0});

  final double height;
  final double width;
  final TvSeason season;
  final MediaItem show;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToSeasonDetails(context, show, season),
      child: Container(
        height: height,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: 'Season-Hero-${season.id}',
              child: CachedNetworkImage(
                placeholder: (context, url) => Image.asset('assets/poster_placeholder.jpg'),
                imageUrl: season.getPosterUrl(),
                fit: BoxFit.cover,
                height: height,
                width: width,
              ),
            ),
            BottomGradient.noOffset(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    season.getFormattedTitle(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 10.0),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Icon(
                        Icons.confirmation_number,
                        color: salmon,
                        size: 10.0,
                      )),
                      Container(
                        width: 4.0,
                      ),
                      Expanded(
                        flex: 8,
                        child: Text('${season.episodeCount} Episodes',
                            softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(color: Colors.grey, fontSize: 8.0)),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
