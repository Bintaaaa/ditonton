import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_shows.dart';
import 'package:flutter/cupertino.dart';

class TVShowListNotifier extends ChangeNotifier {
  var _nowPlayingTVShows = <TVShow>[];
  List<TVShow> get nowPlayingTVShows => _nowPlayingTVShows;

  var _popularTVShows = <TVShow>[];
  List<TVShow> get popularTVShows => _popularTVShows;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  RequestState _popularTVShowsState = RequestState.Empty;
  RequestState get popularTVShowsState => _popularTVShowsState;

  String _message = '';
  String get message => _message;

  final GetNowPlayingTVShows getNowPlayingTVShows;
  final GetPopularTVShows getPopularTVShows;
  TVShowListNotifier({
    required this.getNowPlayingTVShows,
    required this.getPopularTVShows,
  });

  Future<void> fetchNowPlayingTVShows() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTVShows.execute();
    result.fold((failure) {
      _nowPlayingState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvShows) {
      _nowPlayingState = RequestState.Loaded;
      _nowPlayingTVShows = tvShows;
      notifyListeners();
    });
  }

  Future<void> fetchPopularTVShows() async {
    _popularTVShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();
    result.fold(
      (failure) {
        _popularTVShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _popularTVShowsState = RequestState.Loaded;
        _popularTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }
}
