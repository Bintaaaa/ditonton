import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:flutter/cupertino.dart';

class TVShowDetailNotifier extends ChangeNotifier {
  final GetTVShowDetail getTVShowDetail;
  final GetTVShowRecommendations getTVShowRecommendations;
  TVShowDetailNotifier({
    required this.getTVShowDetail,
    required this.getTVShowRecommendations,
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
}
