import 'dart:async';

import 'package:flutter_cinematic/model/cast.dart';
import 'package:flutter_cinematic/model/episode.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/model/searchresult.dart';
import 'package:flutter_cinematic/model/tvseason.dart';
import 'package:flutter_cinematic/util/tmdb_client.dart';

class MediaProvider {
  final TmdbClient _tmdbClient;

  MediaProvider(this._tmdbClient);

  Future<List<MediaItem>> loadMedia(MediaType mediaType, String category, {int page = 1}) {
    if (mediaType == MediaType.movie) {
      return _tmdbClient.fetchMovies(category: category, page: page);
    } else {
      return _tmdbClient.fetchShows(category: category, page: page);
    }
  }

  Future<List<Actor>> loadCast(MediaItem mediaItem) {
    return _tmdbClient.getMediaCredits(mediaItem.type, mediaItem.id);
  }

  Future<List<MediaItem>> getSimilar(MediaItem mediaItem) {
    return _tmdbClient.getSimilarMedia(mediaItem.type, mediaItem.id);
  }

  Future<dynamic> getDetails(MediaItem mediaItem) {
    return _tmdbClient.getMediaDetails(mediaItem.type, mediaItem.id);
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) {
    return _tmdbClient.getMoviesForActor(actorId);
  }

  Future<List<MediaItem>> getShowsForActor(int actorId) {
    return _tmdbClient.getShowsForActor(actorId);
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    return _tmdbClient.getSearchResults(query);
  }

  Future<List<Episode>> fetchEpisodes(int showId, int seasonNumber) {
    return _tmdbClient.fetchEpisodes(showId, seasonNumber);
  }

  Future<List<TvSeason>> getShowSeasons(MediaItem mediaItem) {
    return _tmdbClient.getShowSeasons(mediaItem.id);
  }
}