# Flutter Cinematic

This app began as a fork of [Aaron Oertel's](https://github.com/aaronoe) Flutter app [FlutterCinematic](https://github.com/aaronoe/FlutterCinematic).
That app has not seen any updates since June 2018.  As a learning exercise, I decided to copy the entire app, update, and then improve it.
Some of the initial changes include fixing lint warnings, replacing scoped_model with provider, code cleanup, and caching of TMDB responses and images. 

## Screenshots
<table>
<tbody>
<tr>
<td style="text-align:center"><img src="https://raw.githubusercontent.com/neilweber/flutter_cinematic/master/doc/images/Screenshot_main_movies.png" height = "500px"/></td>
<td style="text-align:center"><img src="https://raw.githubusercontent.com/neilweber/flutter_cinematic/master/doc/images/Screenshot_details_movie.png" height = "500px"/></td>
<td style="text-align:center"><img src="https://raw.githubusercontent.com/neilweber/flutter_cinematic/master/doc/images/Screenshot_similar_movie.png" height = "500px"/></td>
</tr>
</tbody>
</table>

## Overview

The app uses the [Movie DB Public API](https://www.themoviedb.org/documentation/api) as a data 
source.

## Building from Source

To build this app from source you will have to obtain an API-key from [TMDB right here](https://developers.themoviedb.org/3/getting-started/introduction).
Set this key to the constant `API_KEY` in `constants.dart` to compile and run the app.

You will also need to clone [my fork of the dio_cache project](https://github.com/neilweber/dio_cache).

## License

This project utilizes the [MIT License](https://github.com/neilweber/flutter_cinematic/blob/master/LICENSE "Project License")