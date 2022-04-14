import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv/search_tv_show/search_tv_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SearchTVShowsPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context
                    .read<SearchTVShowsBloc>()
                    .add(OnQueryTVShowsChange(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchTVShowsBloc, SearchTVShowsState>(
              key: const Key('search_tv_shows'),
              builder: (context, state) {
                if (state is SearchTVShowsLoading) {
                  return Container(
                    margin: EdgeInsets.only(top: 32.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is SearchTVShowsHasData) {
                  final tvShows = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = tvShows[index];
                        return CardList(
                          tvShow: tv,
                        );
                      },
                      itemCount: tvShows.length,
                    ),
                  );
                } else if (state is SearchTVShowsEmpty) {
                  return Container();
                } else if (state is SearchTVShowsError) {
                  return Center(
                    child: Text(
                      'Movies not found!',
                      style: kBodyText,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
