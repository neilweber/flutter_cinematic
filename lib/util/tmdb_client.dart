import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache/dio_cache.dart';
import 'package:flutter_cinematic/model/episode.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/mediaitemdetails.dart';
import 'package:flutter_cinematic/model/searchresult.dart';
import 'package:flutter_cinematic/util/constants.dart';
import 'package:logging/logging.dart';

// https://developers.themoviedb.org/3/getting-started/introduction

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
    _dio.interceptors.add(LogInterceptor());

    var cutoff = DateTime.now().subtract(Duration(days: 7));
    log.info('Deleting cached responses before $cutoff');
    fileCacheStore.deleteOldEntries(cutoff);
  }

  Future<dynamic> _getJson(Uri uri) async {
    final stopwatch = Stopwatch()
      ..start();
    final response = (await _dio.get(uri.toString())).data;
    stopwatch.stop();
    log.info('GET $uri; elapsed: ${stopwatch.elapsed}');
    return response;
  }

  Future<List<MediaItem>> fetchMedia(MediaType mediaType, {int page = 1, String category = 'popular'}) async {
    final uri = Uri.https(_baseUrl, '3/${mediaType.tmdbType}/$category', {'api_key': API_KEY, 'page': page.toString()});

    return _getJson(uri).then<dynamic>((dynamic json) => json['results']).then((dynamic data) {
      final stopwatch = Stopwatch()
        ..start();
      var list = data.map<MediaItem>((dynamic item) => MediaItem(item, mediaType)).toList();
      log.info('Parsing $uri; elapsed: ${stopwatch.elapsed}; length: ${list.length}');
      return list;
    });
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) async {
    // TODO look into getting combined credits
    // TODO why isn't this using movie_credits?
    final url = Uri.https(_baseUrl, '3/discover/movie', {'api_key': API_KEY, 'with_cast': actorId.toString(), 'sort_by': 'popularity.desc'});

    return _getJson(url)
        .then<dynamic>((dynamic json) => json['results'])
        .then((dynamic data) => data.map<MediaItem>((dynamic item) => MediaItem(item, MediaType.movie)).toList());
  }

  Future<List<MediaItem>> getShowsForActor(int actorId) async {
    final url = Uri.https(_baseUrl, '3/person/$actorId/tv_credits', {'api_key': API_KEY});

    return _getJson(url)
        .then<dynamic>((dynamic json) => json['cast'])
        .then((dynamic data) => data.map<MediaItem>((dynamic item) => MediaItem(item, MediaType.show)).toList());
  }

  Future<MediaItemDetails> getMediaDetails(MediaType mediaType, int mediaId) async {
    final url = Uri.https(_baseUrl, '3/${mediaType.tmdbType}/$mediaId', {'api_key': API_KEY, 'append_to_response': 'credits,similar,seasons'});

    return _getJson(url).then<MediaItemDetails>((dynamic json) => MediaItemDetails(mediaType, json));
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    final url = Uri.https(_baseUrl, '3/search/multi', {'api_key': API_KEY, 'query': query});

    return _getJson(url).then((dynamic json) => json['results'].map<SearchResult>((dynamic item) => SearchResult.fromJson(item)).toList());
  }

  Future<List<Episode>> fetchEpisodes(int showId, int seasonNumber) {
    final url = Uri.https(_baseUrl, '3/tv/$showId/season/$seasonNumber', {'api_key': API_KEY});

    return _getJson(url)
        .then<dynamic>((dynamic json) => json['episodes'])
        .then((dynamic data) => data.map<Episode>((dynamic item) => Episode.fromJson(item)).toList());
  }
}
