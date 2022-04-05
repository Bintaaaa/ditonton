import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/search_tv_shows.dart';
import 'package:flutter/foundation.dart';

class TVShowsSearchNotifier extends ChangeNotifier {
  final SearchTVShows searchTVShows;

  TVShowsSearchNotifier({required this.searchTVShows});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TVShow> _searchResult = [];
  List<TVShow> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTVShowsSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTVShows.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
