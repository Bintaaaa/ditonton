import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing_tv_shows/now_playing_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_shows/popular_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_shows/top_rated_tv_shows_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_shows_search_page.dart';
import 'package:ditonton/presentation/widgets/drawer.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-tv';
  const HomeTVPage({Key? key}) : super(key: key);

  @override
  State<HomeTVPage> createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingTVShowsBloc>().add(OnNowPlayingTVShowsCalled());
      context.read<PopularTVShowsBloc>().add(OnPopularTVShowsCalled());
      context.read<TopRatedTVShowsBloc>().add(OnTopRatedTVShowsCalled());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerDitonton(),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTVShowsPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Now Playing",
                style: kHeading6,
              ),
              BlocBuilder<NowPlayingTVShowsBloc, NowPlayingTVShowsState>(
                key: const Key('now_playing_tv_shows'),
                builder: (context, state) {
                  if (state is NowPlayingTVShowsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingTVShowsHasData) {
                    return TVList(state.result);
                  } else {
                    return const Text(
                      'Failed to fetch data',
                      key: Key('error_message'),
                    );
                  }
                },
              ),
              SubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTVShowsPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTVShowsBloc, PopularTVShowsState>(
                key: const Key('popular_tv_shows'),
                builder: (context, state) {
                  if (state is PopularTVShowsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularTVShowsHasData) {
                    return TVList(state.result);
                  } else {
                    return const Text(
                      'Failed to fetch data',
                      key: Key('error_message'),
                    );
                  }
                },
              ),
              SubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedTVShowsPage.ROUTE_NAME,
                ),
              ),
              BlocBuilder<TopRatedTVShowsBloc, TopRatedTVShowsState>(
                key: const Key('top_rated_tv_shows'),
                builder: (context, state) {
                  if (state is TopRatedTVShowsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedTVShowsHasData) {
                    return TVList(state.result);
                  } else {
                    return const Text(
                      'Failed to fetch data',
                      key: Key('error_message'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
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

class TVList extends StatelessWidget {
  final List<TVShow> tvShows;

  TVList(this.tvShows);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TVShowDetailPage.ROUTE_NAME,
                  arguments: tvShow.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
