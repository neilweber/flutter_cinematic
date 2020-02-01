import 'package:flutter/material.dart';
import 'package:flutter_cinematic/model/searchresult.dart';
import 'package:flutter_cinematic/util/mediaprovider.dart';
import 'package:flutter_cinematic/util/utils.dart';
import 'package:flutter_cinematic/widgets/search/search_item.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchScreen> {
  _SearchPageState() {
    searchBar =
        SearchBar(inBar: true, controller: textController, setState: setState, buildDefaultAppBar: _buildAppBar, onSubmitted: querySubject.add);
  }

  List<SearchResult> _resultList = List<SearchResult>();
  SearchBar searchBar;
  LoadingState _currentState = LoadingState.WAITING;
  PublishSubject<String> querySubject = PublishSubject<String>();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final MediaProvider mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    textController.addListener(() {
      querySubject.add(textController.text);
    });

    // TODO this is the only usage of rxdart; remove it
    querySubject.stream
        .where((String query) => query.isNotEmpty)
        .debounceTime(Duration(milliseconds: 250))
        .distinct()
        .switchMap((String query) => Observable.fromFuture(mediaProvider.getSearchResults(query)))
        .listen(_setResults);
  }

  void _setResults(List<SearchResult> results) {
    setState(() {
      _resultList = results;
      _currentState = LoadingState.DONE;
    });
  }

  @override
  void dispose() {
    super.dispose();
    querySubject.close();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: searchBar.build(context), body: _buildContentSection());
  }

  Widget _buildContentSection() {
    switch (_currentState) {
      case LoadingState.WAITING:
        return Center(child: const Text('Search for movies, shows and actors'));
      case LoadingState.ERROR:
        return Center(child: const Text('An error occured'));
      case LoadingState.LOADING:
        return Center(
          child: const CircularProgressIndicator(),
        );
      case LoadingState.DONE:
        return (_resultList == null || _resultList.isEmpty)
            ? Center(child: const Text("Unforunately there aren't any matching results!"))
            : ListView.builder(itemCount: _resultList.length, itemBuilder: (BuildContext context, int index) => SearchItemCard(_resultList[index]));
      default:
        return Container();
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Search Movies'), actions: <Widget>[searchBar.getSearchAction(context)]);
  }
}
