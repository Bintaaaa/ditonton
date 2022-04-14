import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing_tv_shows/now_playing_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_shows/popular_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_shows/top_rated_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_detail/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_recommendations/tv_show_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_shows/watchlist_tv_shows_bloc.dart';
import 'package:mocktail/mocktail.dart';

/// fake now playing tv shows bloc
class FakeNowPlayingTVShowsEvent extends Fake
    implements NowPlayingTVShowsEvent {}

class FakeNowPlayingTVShowsState extends Fake
    implements NowPlayingTVShowsState {}

class FakeNowPlayingTVShowsBloc
    extends MockBloc<NowPlayingTVShowsEvent, NowPlayingTVShowsState>
    implements NowPlayingTVShowsBloc {}

/// fake popular tv shows bloc
class FakePopularTVShowsEvent extends Fake implements PopularTVShowsEvent {}

class FakePopularTVShowsState extends Fake implements PopularTVShowsState {}

class FakePopularTVShowsBloc
    extends MockBloc<PopularTVShowsEvent, PopularTVShowsState>
    implements PopularTVShowsBloc {}

/// fake top rated tv shows bloc
class FakeTopRatedTVShowsEvent extends Fake implements TopRatedTVShowsEvent {}

class FakeTopRatedTVShowsState extends Fake implements TopRatedTVShowsState {}

class FakeTopRatedTVShowsBloc
    extends MockBloc<TopRatedTVShowsEvent, TopRatedTVShowsState>
    implements TopRatedTVShowsBloc {}

/// fake detail tv show bloc
class FakeTVShowDetailEvent extends Fake implements TVShowDetailEvent {}

class FakeTVShowDetailState extends Fake implements TVShowDetailState {}

class FakeTVShowDetailBloc
    extends MockBloc<TVShowDetailEvent, TVShowDetailState>
    implements TVShowDetailBloc {}

/// fake tv show recommendations bloc
class FakeTVShowRecommendationsEvent extends Fake
    implements TVShowRecommendationsEvent {}

class FakeTVShowRecommendationsState extends Fake
    implements TVShowRecommendationsState {}

class FakeTVShowRecommendationsBloc
    extends MockBloc<TVShowRecommendationsEvent, TVShowRecommendationsState>
    implements TVShowRecommendationsBloc {}

/// fake watchlist tv shows bloc
class FakeWatchlistTVShowsEvent extends Fake implements WatchlistTVShowsEvent {}

class FakeWatchlistTVShowsState extends Fake implements WatchlistTVShowsState {}

class FakeWatchlistTVShowsBloc
    extends MockBloc<WatchlistTVShowsEvent, WatchlistTVShowsState>
    implements WatchlistTVShowsBloc {}
