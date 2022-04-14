import 'package:ditonton/domain/usecases/get_now_playing_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/search_tv_shows.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  GetTVShowDetail,
  GetTVShowRecommendations,
  GetNowPlayingTVShows,
  GetPopularTVShows,
  GetTopRatedTVShows,
  GetWatchListStatusTVShow,
  GetWatchlistTVShows,
  SaveWatchlistTVShow,
  RemoveWatchlistTVShow,
  SearchTVShows,
])
void main() {}
