import 'package:about/about.dart' show AboutPage;
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/ssl_pinning/http_ssl_pinning.dart';
import 'package:ditonton/common/utils.dart';
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
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_shows_search_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<NowPlayingMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingTVShowsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTVShowsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTVShowsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TVShowDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieRecommendationsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TVShowRecommendationsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTVShowsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TVShowDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTVShowsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case HomeTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTVPage());
            case TVShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                  builder: (_) => TVShowDetailPage(id: id));
            case PopularTVShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => PopularTVShowsPage());
            case TopRatedTVShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TopRatedTVShowsPage());
            case SearchTVShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => SearchTVShowsPage());
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
