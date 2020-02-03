import 'package:flutter_cinematic/model/cast.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/tvseason.dart';
import 'package:flutter_cinematic/util/utils.dart';

class MediaItemDetails {
  final String imdbId;
  final String originalTitle;
  final String status;
  final String homepage;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final int runtime;
  final String premiereDate;
  final String lastAirDate;
  final int budget;
  final int revenue;
  final String creators; // comma separated list
  final String networks; // comma separated list
  List<Actor> actors;
  List<TvSeason> seasons;
  List<MediaItem> similarMedia;

  factory MediaItemDetails(MediaType type, Map jsonMap) => MediaItemDetails._internalFromJson(type, jsonMap);

  MediaItemDetails._internalFromJson(MediaType mediaType, Map jsonMap)
      : imdbId = jsonMap['imdb_id'],
        originalTitle = jsonMap[mediaType.originalTitleProperty],
        status = jsonMap['status'],
        numberOfSeasons = jsonMap['number_of_seasons']?.toInt(),
        numberOfEpisodes = jsonMap['number_of_episodes']?.toInt(),
        runtime = jsonMap['runtime']?.toInt(),
        premiereDate = jsonMap[mediaType.startDateProperty],
        lastAirDate = jsonMap['last_air_date'],
        budget = jsonMap['budget']?.toInt(),
        revenue = jsonMap['revenue']?.toInt(),
        creators = concatListToString(jsonMap['created_by'], 'name'),
        networks = concatListToString(jsonMap['networks'], 'name'),
        homepage = toNonNullString(jsonMap['homepage']),
        actors = get(jsonMap, 'credits', 'cast')?.map<Actor>((dynamic item) => Actor.fromJson(item))?.toList(),
        similarMedia = get(jsonMap, 'similar', 'results')?.map<MediaItem>((dynamic item) => MediaItem(item, mediaType))?.toList(),
        seasons = jsonMap['seasons']?.map<TvSeason>((dynamic item) => TvSeason.fromMap(item))?.toList();

  static dynamic get(Map map, String key, String subkey) {
    Map submap = map[key];
    if (submap == null) {
      return null;
    }

    return submap[subkey];
  }

  static String toNonNullString(dynamic val) {
    var str = val?.toString();
    return str == null || str.isEmpty ? null : str;
  }
}
