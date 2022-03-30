import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_shows.dart';
import 'package:flutter/cupertino.dart';

class TVShowListNotifier extends ChangeNotifier {
  var _nowPlayingTVShows = <TVShow>[];
  List<TVShow> get nowPlayingTVShows => _nowPlayingTVShows;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  String _message = '';
  String get message => _message;

  final GetNowPlayingTVShows getNowPlayingTVShows;
  TVShowListNotifier({
    required this.getNowPlayingTVShows,
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
}
