import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/mediaitemdetails.dart';
import 'package:flutter_cinematic/util/utils.dart';

class MetaSection extends StatelessWidget {
  MetaSection(this._mediaItem, this._mediaItemDetails);

  final MediaItem _mediaItem;
  final MediaItemDetails _mediaItemDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'About',
          style: TextStyle(color: Colors.white),
        ),
        Container(
          height: 8.0,
        ),
        _getMetaInfoSection('Original Title', _mediaItemDetails.originalTitle),
        _getSectionOrContainer('Status', _mediaItemDetails.status),
        _getSectionOrContainer('Runtime', _mediaItemDetails.runtime, formatterFunction: formatRuntime),
        _getSectionOrContainer('Genres', _mediaItem.genres?.join(', ')),
        _getSectionOrContainer('Creators', _mediaItemDetails.creators),
        _getSectionOrContainer('Networks', _mediaItemDetails.networks),
        (_mediaItemDetails.numberOfSeasons != null && _mediaItemDetails.numberOfEpisodes != null)
            ? _getMetaInfoSection('Seasons', formatSeasonsAndEpisodes(_mediaItemDetails.numberOfSeasons, _mediaItemDetails.numberOfEpisodes))
            : Container(),
        _getSectionOrContainer('Premiere', _mediaItemDetails.premiereDate, formatterFunction: formatDate),
        _getSectionOrContainer('Latest/Next Episode', _mediaItemDetails.lastAirDate, formatterFunction: formatDate),
        _getSectionOrContainer('Budget', _mediaItemDetails.budget, formatterFunction: formatNumberToDollars),
        _getSectionOrContainer('Revenue', _mediaItemDetails.revenue, formatterFunction: formatNumberToDollars),
        _getSectionOrContainer('Homepage', _mediaItemDetails.homepage, isLink: true),
        _getSectionOrContainer('Imdb', _mediaItemDetails.imdbId, formatterFunction: getImdbUrl, isLink: true),
      ],
    );
  }

  Widget _getSectionOrContainer(String title, dynamic content, {dynamic formatterFunction, bool isLink = false}) {
    return content == null ? Container() : _getMetaInfoSection(
        title, formatterFunction == null ? content : formatterFunction(content), isLink: isLink);
  }

  Widget _getMetaInfoSection(String title, String content, {bool isLink = false}) {
    if (content == null) {
      return Container();
    }

    final contentSection = Expanded(
      flex: 4,
      child: GestureDetector(
        onTap: () => isLink ? launchUrl(content) : null,
        child: Text(
          content,
          style: TextStyle(color: isLink ? Colors.blue : Colors.white, fontSize: 11.0),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                '$title:',
                style: TextStyle(color: Colors.grey, fontSize: 11.0),
              ),
            ),
            contentSection
          ],
        ));
  }
}
