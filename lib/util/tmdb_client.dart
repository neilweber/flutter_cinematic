import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache/dio_cache.dart';
import 'package:flutter_cinematic/model/cast.dart';
import 'package:flutter_cinematic/model/episode.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/searchresult.dart';
import 'package:flutter_cinematic/model/tvseason.dart';
import 'package:flutter_cinematic/util/constants.dart';
import 'package:logging/logging.dart';

class TmdbClient {
  static final log = Logger('TmdbClient');
  static final String _baseUrl = 'api.themoviedb.org';
  final Dio _dio = Dio();

  TmdbClient(Directory storageDirectory) {
    var cacheDirectory = Directory(storageDirectory.path + '/responses');
    log.info('Cache directory: $cacheDirectory');
    var fileCacheStore = FileCacheStore(cacheDirectory, log);
    _dio.interceptors.add(CacheInterceptor(
      logger: log,
      options: CacheOptions(store: fileCacheStore),
    ));

    var expiration = DateTime.now().subtract(Duration(days: 1));
    log.info('Deleting cached responses with expirations before $expiration');
    fileCacheStore.evictExpiredEntries(expiration);
  }

  Future<dynamic> _getJson(Uri uri) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    final response = (await _dio.get(uri.toString())).data;
    stopwatch.stop();
//    log.info('GET $uri; elapsed: ${stopwatch.elapsed}; length: ${response.length}');
//    print('GET $uri; elapsed: ${stopwatch.elapsed}; length: ${response.length}');
    return response;
  }

  Future<List<MediaItem>> fetchMovies({int page = 1, String category = 'popular'}) async {
    final url = Uri.https(_baseUrl, '3/movie/$category', {'api_key': API_KEY, 'page': page.toString()});

    return _getJson(url)
        .then<dynamic>((dynamic json) => json['results'])
        .then((dynamic data) => data.map<MediaItem>((dynamic item) => MediaItem(item, MediaType.movie)).toList());
  }

  Future<List<MediaItem>> getSimilarMedia(MediaType mediaType, int mediaId) async {
    final url = Uri.https(_baseUrl, '3/${mediaType.tmdbType}/$mediaId/similar', {
      'api_key': API_KEY,
    });

    return _getJson(url)
        .then<dynamic>((dynamic json) => json['results'])
        .then((dynamic data) => data.map<MediaItem>((dynamic item) => MediaItem(item, mediaType)).toList());
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) async {
    final url = Uri.https(_baseUrl, '3/discover/movie', {'api_key': API_KEY, 'with_cast': actorId.toString(), 'sort_by': 'popularity.desc'});

    return _getJson(url)
        .then<dynamic>((dynamic json) => json['results'])
        .then((dynamic data) => data.map<MediaItem>((dynamic item) => MediaItem(item, MediaType.movie)).toList());
  }

  Future<List<MediaItem>> getShowsForActor(int actorId) async {
    final url = Uri.https(_baseUrl, '3/person/$actorId/tv_credits', {
      'api_key': API_KEY,
    });

    return _getJson(url)
        .then<dynamic>((dynamic json) => json['cast'])
        .then((dynamic data) => data.map<MediaItem>((dynamic item) => MediaItem(item, MediaType.show)).toList());
  }

  Future<List<Actor>> getMediaCredits(MediaType mediaType, int mediaId) async {
    final url = Uri.https(_baseUrl, '3/${mediaType.tmdbType}/$mediaId/credits', {'api_key': API_KEY});

    return _getJson(url).then((dynamic json) => json['cast'].map<Actor>((dynamic item) => Actor.fromJson(item)).toList());
  }

  Future<dynamic> getMediaDetails(MediaType mediaType, int mediaId) async {
    final url = Uri.https(_baseUrl, '3/${mediaType.tmdbType}/$mediaId&append_to_response=credits,similar,seasons', {'api_key': API_KEY});

    return _getJson(url);
  }

  Future<List<TvSeason>> getShowSeasons(int showId) async {
    final dynamic detailJson = await getMediaDetails(MediaType.show, showId);
    return detailJson['seasons'].map<TvSeason>((dynamic item) => TvSeason.fromMap(item)).toList();
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    final url = Uri.https(_baseUrl, '3/search/multi', {'api_key': API_KEY, 'query': query});

    return _getJson(url).then((dynamic json) => json['results'].map<SearchResult>((dynamic item) => SearchResult.fromJson(item)).toList());
  }

  Future<List<MediaItem>> fetchShows({int page = 1, String category = 'popular'}) async {
    final url = Uri.https(_baseUrl, '3/tv/$category', {'api_key': API_KEY, 'page': page.toString()});

    return _getJson(url)
        .then<dynamic>((dynamic json) => json['results'])
        .then((dynamic data) => data.map<MediaItem>((dynamic item) => MediaItem(item, MediaType.show)).toList());
  }

  Future<List<Episode>> fetchEpisodes(int showId, int seasonNumber) {
    final url = Uri.https(_baseUrl, '3/tv/$showId/season/$seasonNumber', {
      'api_key': API_KEY,
    });

    return _getJson(url)
        .then<dynamic>((dynamic json) => json['episodes'])
        .then((dynamic data) => data.map<Episode>((dynamic item) => Episode.fromJson(item)).toList());
  }
}
