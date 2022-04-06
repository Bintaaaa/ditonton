import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

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
      Provider.of<TVShowDetailNotifier>(context, listen: false)
        ..fetchTVShowDetail(widget.id)
        ..loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
            Consumer<TVShowDetailNotifier>(builder: (context, provider, child) {
          if (provider.tvShowState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvShowState == RequestState.Loaded) {
            return DetailContent(
              tvshow: provider.tvShowDetail,
              provider: provider,
              isAddedWatchlist: provider.isAddedToWatchlist,
            );
          } else {
            return Center(
              child: Text(provider.message),
            );
          }
        }),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVShowDetail tvshow;
  final TVShowDetailNotifier provider;
  final bool isAddedWatchlist;
  const DetailContent(
      {Key? key,
      required this.tvshow,
      required this.provider,
      required this.isAddedWatchlist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500${tvshow.posterPath}'),
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
                              tvshow.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!provider.isAddedToWatchlist) {
                                  await provider.addWatchlist(tvshow);
                                } else {
                                  await provider.removeFromWatchlist(tvshow);
                                }

                                final message = provider.watchlistMessage;

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
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tvshow.genres),
                            ),
                            Text(
                              _formattedDuration(tvshow.episodeRunTime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvshow.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvshow.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 14.0),
                            Text(
                              'Total Episodes: ' +
                                  tvshow.numberOfEpisodes.toString(),
                            ),
                            Text(
                              'Total Seasons: ' +
                                  tvshow.numberOfSeasons.toString(),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvshow.overview.isNotEmpty
                                  ? tvshow.overview
                                  : "-",
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            provider.tvShowRecommendations.isNotEmpty
                                ? Container(
                                    margin: EdgeInsets.only(top: 8.0),
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tvShowRecoms = provider
                                            .tvShowRecommendations[index];
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
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$BASE_IMAGE_URL${tvShowRecoms.posterPath}',
                                                placeholder: (context, url) =>
                                                    Padding(
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
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount:
                                          provider.tvShowRecommendations.length,
                                    ),
                                  )
                                : Text('No recommendations found'),
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            tvshow.seasons.isNotEmpty
                                ? Container(
                                    height: 150,
                                    margin: EdgeInsets.only(top: 8.0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, index) {
                                        final season = tvshow.seasons[index];

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
                                      itemCount: tvshow.seasons.length,
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
