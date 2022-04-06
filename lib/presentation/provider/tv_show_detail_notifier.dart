import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_show.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:flutter/cupertino.dart';

class TVShowDetailNotifier extends ChangeNotifier {
  final GetTVShowDetail getTVShowDetail;
  final GetTVShowRecommendations getTVShowRecommendations;
  final GetWatchListStatusTVShow getWatchListStatusTVShow;
  final SaveWatchlistTVShow saveWatchlist;
  final RemoveWatchlistTVShow removeWatchlist;

  TVShowDetailNotifier({
    required this.getTVShowDetail,
    required this.getTVShowRecommendations,
    required this.saveWatchlist,
    required this.getWatchListStatusTVShow,
    required this.removeWatchlist,
  });

  late TVShowDetail _tvShowDetail;
  TVShowDetail get tvShowDetail => _tvShowDetail;

  RequestState _tvShowState = RequestState.Empty;
  RequestState get tvShowState => _tvShowState;

  List<TVShow> _tvShowRecommendations = [];
  List<TVShow> get tvShowRecommendations => _tvShowRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTVShowDetail(int id) async {
    _tvShowState = RequestState.Loading;
    notifyListeners();
    final detailTVResult = await getTVShowDetail.execute(id);
    final recommendationResult = await getTVShowRecommendations.execute(id);
    detailTVResult.fold((failure) {
      _tvShowState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvShow) {
      _recommendationState = RequestState.Loading;
      _tvShowDetail = tvShow;
      notifyListeners();

      recommendationResult.fold(
        (failure) {
          _recommendationState = RequestState.Error;
          _message = failure.message;
        },
        (tvShows) {
          _recommendationState = RequestState.Loaded;
          _tvShowRecommendations = tvShows;
        },
      );
      _tvShowState = RequestState.Loaded;
      notifyListeners();
    });
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TVShowDetail tvShow) async {
    final result = await saveWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> removeFromWatchlist(TVShowDetail tvShow) async {
    final result = await removeWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTVShow.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
