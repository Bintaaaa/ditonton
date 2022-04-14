import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_shows/watchlist_tv_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  _WatchlistTVShowsPageState createState() => _WatchlistTVShowsPageState();
}

class _WatchlistTVShowsPageState extends State<WatchlistTVShowsPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistTVShowsBloc>().add(OnFetchTVShowWatchlist());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTVShowsBloc>().add(OnFetchTVShowWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
      child: BlocBuilder<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        builder: (context, watchlistState) {
          if (watchlistState is TVShowWatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (watchlistState is TVShowWatchlistHasData) {
            final watchlistTVShows = watchlistState.result;

            return ListView.builder(
              itemBuilder: (context, index) {
                final tvShow = watchlistTVShows[index];

                return CardList(
                  tvShow: tvShow,
                );
              },
              itemCount: watchlistTVShows.length,
            );
          } else if (watchlistState is TVShowWatchlistEmpty) {
            return Center(
              child: Text('No watchlist tv show yet!', style: kBodyText),
            );
          } else {
            return const Center(
              key: Key('error_message'),
              child: Text('Failed to fetch data'),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
