import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/mediaitem.dart';
import 'package:flutter_cinematic/util/mediaprovider.dart';
import 'package:flutter_cinematic/util/utils.dart';
import 'package:flutter_cinematic/widgets/media_list/media_list_item.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class MediaList extends StatefulWidget {
  MediaList(this.mediaType, this.category, {Key key}) : super(key: key);

  final MediaType mediaType;
  final String category;

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  static final log = Logger('MediaList');
  final List<MediaItem> _movies = List<MediaItem>();
  int _pageNumber = 1;
  LoadingState _loadingState = LoadingState.LOADING;
  bool _isLoading = false;

  Future<void> _loadNextPage() async {
    _isLoading = true;
    try {
      final MediaProvider mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      final nextMovies = await mediaProvider.loadMedia(widget.mediaType, widget.category, page: _pageNumber);
      setState(() {
        _loadingState = LoadingState.DONE;
        _movies.addAll(nextMovies);
        _isLoading = false;
        _pageNumber++;
      });
    } catch (e) {
      // TODO this occasionally fails with this error: Unhandled Exception: setState() called after dispose(): _MediaListState#6970f(lifecycle state: defunct, not mounted)
      // This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
      // The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
      // This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
      // See https://stackoverflow.com/questions/17552757/is-there-any-way-to-cancel-a-dart-future
      // And https://dart.academy/how_cancel_future/
      log.warning('Error loading next page', e);
      _isLoading = false;
      if (_loadingState == LoadingState.LOADING) {
        setState(() => _loadingState = LoadingState.ERROR);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: _getContentSection());
  }

  Widget _getContentSection() {
    switch (_loadingState) {
      case LoadingState.DONE:
        return ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext context, int index) {
              if (!_isLoading && index > (_movies.length * 0.7)) {
                _loadNextPage();
              }

              return MediaListItem(_movies[index]);
            });
      case LoadingState.ERROR:
        return Column(
          children: <Widget>[
            const Text('Sorry, there was an error loading the data!'),
            RaisedButton(
              child: Text('Retry'),
              onPressed: () {
                _loadNextPage();
              },
            ),
          ],
        );
      case LoadingState.LOADING:
        return const CircularProgressIndicator();
      default:
        return Container();
    }
  }
}
