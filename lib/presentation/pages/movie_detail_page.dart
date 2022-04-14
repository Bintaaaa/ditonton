import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/bloc/movie_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../bloc/movie/movie_recommendations/movie_recommendations_bloc.dart';
import '../bloc/movie/watchlist_movies/watchlist_movies_bloc.dart';
import '../bloc/tv/watchlist_tv_shows/watchlist_tv_shows_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(OnMovieDetailCalled(widget.id));
      context
          .read<MovieRecommendationsBloc>()
          .add(OnMovieRecommendationsCalled(widget.id));
      context
          .read<WatchlistMoviesBloc>()
          .add(FetchWatchlistStatusMovies(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAddedWatchlist = context.select<WatchlistMoviesBloc, bool>((bloc) {
      if (bloc.state is MovieIsAddedToWatchlist) {
        return (bloc.state as MovieIsAddedToWatchlist).isAdded;
      }
      return false;
    });
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        key: const Key('movie_content'),
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieDetailHasData) {
            final movie = state.result;
            return DetailContent(movie, isAddedWatchlist);
          } else {
            return const Center(
              child: Text('Failed to fetch data'),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final MovieDetail movie;
  late bool isAddedWatchlist;

  DetailContent(this.movie, this.isAddedWatchlist);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
            width: screenWidth,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.movie.title,
                                style: kHeading5,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (!widget.isAddedWatchlist) {
                                    context
                                        .read<WatchlistMoviesBloc>()
                                        .add(AddMovieToWatchlist(widget.movie));
                                  } else {
                                    context.read<WatchlistMoviesBloc>().add(
                                        RemoveMovieFromWatchlist(widget.movie));
                                  }

                                  final state =
                                      BlocProvider.of<WatchlistMoviesBloc>(
                                              context)
                                          .state;
                                  String message = "";

                                  if (state is MovieIsAddedToWatchlist) {
                                    final isAdded = state.isAdded;
                                    message = isAdded == false
                                        ? 'Added to Watchlist'
                                        : 'Removed from Watchlist';
                                  } else {
                                    message = !widget.isAddedWatchlist
                                        ? 'Added to Watchlist'
                                        : 'Removed from Watchlist';
                                  }

                                  if (message == 'Added to Watchlist' ||
                                      message == 'Removed from Watchlist') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(message),
                                          );
                                        });
                                  }

                                  setState(() {
                                    widget.isAddedWatchlist =
                                        !widget.isAddedWatchlist;
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.isAddedWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                ),
                              ),
                              Text(
                                _showGenres(widget.movie.genres),
                              ),
                              Text(
                                _showDuration(widget.movie.runtime),
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: widget.movie.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text('${widget.movie.voteAverage}')
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: kHeading6,
                              ),
                              Text(
                                widget.movie.overview,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Recommendations',
                                style: kHeading6,
                              ),
                              BlocBuilder<MovieRecommendationsBloc,
                                  MovieRecommendationsState>(
                                key: const Key('recommendation_movie'),
                                builder: (context, state) {
                                  if (state is MovieRecommendationsLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state
                                      is MovieRecommendationsHasData) {
                                    final recommendationMovies = state.result;

                                    return Container(
                                      margin: const EdgeInsets.only(top: 8.0),
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final movieRecoms =
                                              recommendationMovies[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  MovieDetailPage.ROUTE_NAME,
                                                  arguments: movieRecoms.id,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://image.tmdb.org/t/p/w500${movieRecoms.posterPath}',
                                                  placeholder: (context, url) =>
                                                      const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 12.0),
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: recommendationMovies.length,
                                      ),
                                    );
                                  } else if (state
                                      is MovieRecommendationsEmpty) {
                                    return const Text('-');
                                  } else {
                                    return const Text('Failed to fetch data');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          height: 4,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                );
              },
              // initialChildSize: 0.5,
              minChildSize: 0.25,
              // maxChildSize: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kRichBlack,
              foregroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
