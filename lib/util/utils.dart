import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

enum LoadingState { DONE, LOADING, WAITING, ERROR }

final dollarFormat = NumberFormat('#,##0.00', 'en_US');
final sourceFormat = DateFormat('yyyy-MM-dd');
final dateFormat = DateFormat.yMMMMd('en_US');

String concatListToString(List<dynamic> data, String mapKey) {
  if (data == null) {
    return null;
  }

  final buffer = StringBuffer();
  buffer.writeAll(data.map<String>((dynamic map) => map[mapKey]).toList(), ', ');
  return buffer.toString();
}

String formatSeasonsAndEpisodes(int numberOfSeasons, int numberOfEpisodes) => '$numberOfSeasons Seasons and $numberOfEpisodes Episodes';

String formatNumberToDollars(int amount) => '\$${dollarFormat.format(amount)}';

String formatDate(String date) {
  try {
    return dateFormat.format(sourceFormat.parse(date));
  } catch (Exception) {
    return '';
  }
}

String formatRuntime(int runtime) {
  final hours = runtime ~/ 60;
  final minutes = runtime % 60;

  return '$hours\h $minutes\m';
}

Future<void> launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

String getImdbUrl(String imdbId) => 'http://www.imdb.com/title/$imdbId';

const String _imageUrlLarge = 'https://image.tmdb.org/t/p/w500/';
const String _imageUrlMedium = 'https://image.tmdb.org/t/p/w300/';

String getMediumPictureUrl(String path) => _imageUrlMedium + path;

String getLargePictureUrl(String path) => _imageUrlLarge + path;
