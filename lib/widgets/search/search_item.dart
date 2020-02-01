import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/searchresult.dart';
import 'package:flutter_cinematic/util/navigator.dart';
import 'package:flutter_cinematic/util/styles.dart';

class SearchItemCard extends StatelessWidget {
  SearchItemCard(this.item);

  final SearchResult item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
                placeholder: (context, url) => Image.asset('assets/placeholder.jpg'),
                fit: BoxFit.cover,
                width: 100.0,
                height: 150.0,
                imageUrl: item.imageUrl),
            Container(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color: primaryDark, borderRadius: const BorderRadius.all(Radius.circular(4.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(item.mediaType.toUpperCase(), style: TextStyle(color: colorAccent)),
                    ),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(item.subtitle, style: captionStyle)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    switch (item.mediaType) {
      case 'movie':
        goToMediaDetails(context, item.asMovie);
        return;
      case 'tv':
        goToMediaDetails(context, item.asShow);
        return;
      case 'person':
        goToActorDetails(context, item.asActor);
        return;
    }
  }
}
