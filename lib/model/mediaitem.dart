import 'package:flutter_cinematic/util/utils.dart';

final Map<int, String> _genreMap = {
  28: 'Action',
  12: 'Adventure',
  16: 'Animation',
  35: 'Comedy',
  80: 'Crime',
  99: 'Documentary',
  18: 'Drama',
  10751: 'Family',
  10762: 'Kids',
  10759: 'Action & Adventure',
  14: 'Fantasy',
  36: 'History',
  27: 'Horror',
  10402: 'Music',
  9648: 'Mystery',
  10749: 'Romance',
  878: 'Science Fiction',
  10770: 'TV Movie',
  53: 'Thriller',
  10752: 'War',
  37: 'Western',
  10763: 'News',
  10764: 'Reality',
  10765: 'Sci-Fi & Fantasy',
  10766: 'Soap',
  10767: 'Talk',
  10768: 'War & Politics',
};

String getGenre(int id) {
  return _genreMap[id] ?? '$id';
}

List<String> getGenresForIds(List<int> genreIds) => genreIds.map((id) => _genreMap[id]).toList();

class MediaType {
  final String tmdbType;

  const MediaType(this.tmdbType);

  static const MediaType movie = MediaType('movie');
  static const MediaType show = MediaType('tv');
}

class MediaItem {
  MediaItem._internalFromJson(Map jsonMap, {MediaType type = MediaType.movie})
      : type = type,
        id = jsonMap['id'].toInt(),
        voteAverage = jsonMap['vote_average'].toDouble(),
        title = jsonMap[type == MediaType.movie ? 'title' : 'name'],
        posterPath = jsonMap['poster_path'] ?? '',
        backdropPath = jsonMap['backdrop_path'] ?? '',
        overview = jsonMap['overview'],
        releaseDate = jsonMap[type == MediaType.movie ? 'release_date' : 'first_air_date'],
        genreIds = (jsonMap['genre_ids'] as List<dynamic>).map<int>((dynamic value) => value.toInt()).toList(),
        genres = (jsonMap['genre_ids'] as List<dynamic>).map<String>((dynamic value) => getGenre(value.toInt())).toList();

  final MediaType type;
  final int id;
  final double voteAverage;
  final String title;
  final String posterPath;
  final String backdropPath;
  final String overview;
  final String releaseDate;
  final List<int> genreIds;
  List<String> genres;

  String getBackDropUrl() => getLargePictureUrl(backdropPath);

  String getPosterUrl() => getMediumPictureUrl(posterPath);

  int getReleaseYear() {
    return releaseDate == null || releaseDate == '' ? 0 : DateTime.parse(releaseDate).year;
  }

  factory MediaItem(Map jsonMap, MediaType type) => MediaItem._internalFromJson(jsonMap, type: type);

  Map toJson() => <String, dynamic>{
        'type': type == MediaType.movie ? 1 : 0,
        'id': id,
        'vote_average': voteAverage,
        'title': title,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'overview': overview,
        'release_date': releaseDate,
        'genre_ids': genreIds
      };

  factory MediaItem.fromPrefsJson(Map jsonMap) =>
      MediaItem._internalFromJson(jsonMap, type: (jsonMap['type'].toInt() == 1) ? MediaType.movie : MediaType.show);
}
