import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/search_movies_bloc.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      .read<SearchMoviesBloc>()
                      .add(OnQueryMoviesChange(query));
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
              BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
                key: const Key('search_movies'),
                builder: (context, state) {
                  if (state is SearchMoviesLoading) {
                    return Container(
                      margin: EdgeInsets.only(top: 32.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is SearchMoviesHasData) {
                    final movies = state.result;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return CardList(
                            movie: movie,
                          );
                        },
                        itemCount: movies.length,
                      ),
                    );
                  } else if (state is SearchMoviesEmpty) {
                    return Container();
                  } else if (state is SearchMoviesError) {
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
