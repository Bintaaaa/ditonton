import 'package:ditonton/common/ssl_pinning/http_ssl_pinning.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_show_local_database.dart';
import 'package:ditonton/data/datasources/tv_show_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_show_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_show_repositiry.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_shows.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing_movies/bloc/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movies/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing_tv_shows/now_playing_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_shows/popular_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/search_tv_show/search_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_shows/top_rated_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_detail/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_recommendations/tv_show_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_shows/watchlist_tv_shows_bloc.dart';
import 'domain/usecases/save_watchlist.dart';

import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  //movie
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => MovieRecommendationsBloc(locator()));
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));
  locator.registerFactory(() => MovieDetailBloc(locator()));
  locator.registerFactory(() => WatchlistMoviesBloc(
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerFactory(() => NowPlayingTVShowsBloc(locator()));
  locator.registerFactory(() => PopularTVShowsBloc(locator()));
  locator.registerFactory(() => TVShowRecommendationsBloc(locator()));
  locator.registerFactory(() => TopRatedTVShowsBloc(locator()));
  locator.registerFactory(() => TVShowDetailBloc(locator()));
  locator.registerFactory(() => WatchlistTVShowsBloc(
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerFactory(() => SearchMoviesBloc(locator()));
  locator.registerFactory(() => SearchTVShowsBloc(locator()));

  // use case
  //movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  //tv
  locator.registerLazySingleton(() => GetNowPlayingTVShows(locator()));
  locator.registerLazySingleton(() => GetTVShowDetail(locator()));
  locator.registerLazySingleton(() => GetTVShowRecommendations(locator()));
  locator.registerLazySingleton(() => GetPopularTVShows(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVShows(locator()));
  locator.registerLazySingleton(() => SearchTVShows(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTVShow(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTVShow(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTVShow(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVShows(locator()));

  // repository
  //movie
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  //tv
  locator.registerLazySingleton<TVShowRepository>(
    () => TVShowRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  //movie
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  //tv
  locator.registerLazySingleton<TVShowRemoteDataSource>(
      () => TVShowRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TVShowLocalDataSource>(
      () => TVShowLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}
