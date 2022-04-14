import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing_movies/bloc/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movies/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/widgets/drawer.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/movie';
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMoviesBloc>().add(OnNowPlayingMoviesCalled());
      context.read<PopularMoviesBloc>().add(OnPopularMoviesCalled());
      context.read<TopRatedMoviesBloc>().add(OnTopRatedMoviesCalled());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerDitonton(),
        appBar: AppBar(
          title: Text('Ditonton'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Now Playing',
                  style: kHeading6,
                ),
                BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
                  builder: (context, state) {
                    if (state is NowPlayingMoviesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is NowPlayingMoviesHasData) {
                      final data = state.result;
                      return MovieList(
                        movies: data,
                        key: Key('now_playing_movies'),
                      );
                    } else if (state is NowPlayingMoviesError) {
                      return const Text(
                        'Failed to fetch data',
                        key: Key('error_message'),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SubHeading(
                  key: const Key('see_more_popular_movies'),
                  title: 'Popular',
                  onTap: () => Navigator.pushNamed(
                      context, PopularMoviesPage.ROUTE_NAME),
                ),
                BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                  builder: (context, state) {
                    if (state is PopularMoviesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is PopularMoviesHasData) {
                      final data = state.result;
                      return MovieList(
                        movies: data,
                        key: Key('popular_movies'),
                      );
                    } else if (state is PopularMoviesError) {
                      return Text(
                        'Failed to fetch data',
                        key: Key('error_message'),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SubHeading(
                  key: const Key('see_more_top_rated_movies'),
                  title: 'Top Rated',
                  onTap: () => Navigator.pushNamed(
                      context, TopRatedMoviesPage.ROUTE_NAME),
                ),
                BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                  builder: (context, state) {
                    if (state is TopRatedMoviesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TopRatedMoviesHasData) {
                      final data = state.result;
                      return MovieList(
                        movies: data,
                        key: Key('top_rated_movies'),
                      );
                    } else if (state is TopRatedMoviesError) {
                      return Text(
                        'Failed to fetch data',
                        key: Key('error_message'),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
