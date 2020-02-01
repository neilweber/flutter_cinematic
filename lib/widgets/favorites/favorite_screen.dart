import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'file:///C:/Users/Neil/Projects/flutter_cinematic/lib/model/app_model.dart';
import 'package:flutter_cinematic/widgets/media_list/media_list_item.dart';
import 'package:flutter_cinematic/widgets/utilviews/toggle_theme_widget.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appModel = Provider.of<AppModel>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          actions: const <Widget>[ToggleThemeButton()],
          bottom: TabBar(
            tabs: [
              const Tab(
                icon: Icon(Icons.movie),
              ),
              const Tab(
                icon: Icon(Icons.tv),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _FavoriteList(appModel.favoriteMovies),
            _FavoriteList(appModel.favoriteShows),
          ],
        ),
      ),
    );
  }
}

class _FavoriteList extends StatelessWidget {
  final List<MediaItem> _media;

  const _FavoriteList(this._media, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _media.isEmpty
        ? Center(child: const Text('You have no favorites yet!'))
        : ListView.builder(
            itemCount: _media.length,
            itemBuilder: (BuildContext context, int index) {
              return MediaListItem(_media[index]);
            });
  }
}
