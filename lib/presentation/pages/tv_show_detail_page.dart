import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_detail/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_recommendations/tv_show_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_shows/watchlist_tv_shows_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVShowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tvshow';
  final int id;
  TVShowDetailPage({Key? key, required this.id}) : super(key: key);
  @override
  State<TVShowDetailPage> createState() => _TVShowDetailPageState();
}

class _TVShowDetailPageState extends State<TVShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TVShowDetailBloc>().add(OnTVShowDetailCalled(widget.id));
      context
          .read<TVShowRecommendationsBloc>()
          .add(OnTVShowRecommendationsCalled(widget.id));
      context
          .read<WatchlistTVShowsBloc>()
          .add(FetchWatchlistStatusTVShow(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTVShowAddedToWatchlist = context.select<WatchlistTVShowsBloc, bool>(
        (bloc) => (bloc.state is TVShowIsAddedToWatchlist)
            ? (bloc.state as TVShowIsAddedToWatchlist).isAdded
            : false);

    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<TVShowDetailBloc, TVShowDetailState>(
          key: const Key('tv_show_content'),
          builder: (ctx, tvShowState) {
            if (tvShowState is TVShowDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (tvShowState is TVShowDetailHasData) {
              final tvShow = tvShowState.result;
              return DetailContent(
                tvshow: tvShow,
                isAddedToWatchlist: isTVShowAddedToWatchlist,
              );
            } else {
              return const Center(child: Text('Failed to fetch data'));
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  late bool isAddedToWatchlist;
  final TVShowDetail tvshow;

  DetailContent({
    Key? key,
    required this.tvshow,
    required this.isAddedToWatchlist,
  }) : super(key: key);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
            imageUrl:
                'https://image.tmdb.org/t/p/w500${widget.tvshow.posterPath}'),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
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
                              widget.tvshow.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!widget.isAddedToWatchlist) {
                                  context
                                      .read<WatchlistTVShowsBloc>()
                                      .add(AddTVShowToWatchlist(widget.tvshow));
                                } else {
                                  context.read<WatchlistTVShowsBloc>().add(
                                      RemoveTVShowFromWatchlist(widget.tvshow));
                                }

                                final state =
                                    BlocProvider.of<WatchlistTVShowsBloc>(
                                            context)
                                        .state;
                                String message = "";

                                if (state is TVShowIsAddedToWatchlist) {
                                  final isAdded = state.isAdded;
                                  message = isAdded == false
                                      ? 'Added to Watchlist'
                                      : 'Removed from Watchlist';
                                } else {
                                  message = !widget.isAddedToWatchlist
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
                                  widget.isAddedToWatchlist =
                                      !widget.isAddedToWatchlist;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.isAddedToWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.tvshow.genres),
                            ),
                            Text(
                              _formattedDuration(widget.tvshow.episodeRunTime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tvshow.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tvshow.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 14.0),
                            Text(
                              'Total Episodes: ' +
                                  widget.tvshow.numberOfEpisodes.toString(),
                            ),
                            Text(
                              'Total Seasons: ' +
                                  widget.tvshow.numberOfSeasons.toString(),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tvshow.overview.isNotEmpty
                                  ? widget.tvshow.overview
                                  : "-",
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TVShowRecommendationsBloc,
                                TVShowRecommendationsState>(
                              key: const Key('recommendation_tv_show'),
                              builder: (context, state) {
                                if (state is TVShowRecommendationsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state
                                    is TVShowRecommendationsHasData) {
                                  final tvShowRecommendations = state.result;

                                  return Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tvShowRecoms =
                                            tvShowRecommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TVShowDetailPage.ROUTE_NAME,
                                                arguments: tvShowRecoms.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tvShowRecoms.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 12.0),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: tvShowRecommendations.length,
                                    ),
                                  );
                                } else {
                                  return const Text('No recommendations found');
                                }
                              },
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            widget.tvshow.seasons.isNotEmpty
                                ? Container(
                                    height: 150,
                                    margin: EdgeInsets.only(top: 8.0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, index) {
                                        final season =
                                            widget.tvshow.seasons[index];

                                        return Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: Stack(
                                              children: [
                                                season.posterPath == null
                                                    ? Container(
                                                        width: 96.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kGrey,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'No Image',
                                                            style: TextStyle(
                                                                color:
                                                                    kRichBlack),
                                                          ),
                                                        ),
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            '$BASE_IMAGE_URL${season.posterPath}',
                                                        placeholder:
                                                            (context, url) =>
                                                                Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                Positioned.fill(
                                                  child: Container(
                                                    color: kRichBlack
                                                        .withOpacity(0.65),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 8.0,
                                                  top: 4.0,
                                                  child: Text(
                                                    (index + 1).toString(),
                                                    style: kHeading5.copyWith(
                                                        fontSize: 26.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: widget.tvshow.seasons.length,
                                    ),
                                  )
                                : Text('-'),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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

  String _formattedDuration(List<int> runtimes) =>
      runtimes.map((runtime) => _showDuration(runtime)).join(", ");
}
