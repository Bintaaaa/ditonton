import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_shows/popular_tv_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularTVShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTVShowsPageState createState() => _PopularTVShowsPageState();
}

class _PopularTVShowsPageState extends State<PopularTVShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PopularTVShowsBloc>().add(OnPopularTVShowsCalled()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVShowsBloc, PopularTVShowsState>(
          key: const Key('popular_page'),
          builder: (context, state) {
            if (state is PopularTVShowsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTVShowsHasData) {
              final tvShows = state.result;

              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = tvShows[index];
                  return CardList(
                    tvShow: tvShow,
                  );
                },
                itemCount: tvShows.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text((state as PopularTVShowsError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
