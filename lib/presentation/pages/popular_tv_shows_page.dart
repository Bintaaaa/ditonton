import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/popular_tv_shows_notifier.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
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
    Future.microtask(() =>
        Provider.of<PopularTVShowsNotifier>(context, listen: false)
            .fetchPopularTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTVShowsNotifier>(
          builder: (context, data, child) {
            if (data.requestState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.requestState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.popularTVShows[index];
                  return CardList(
                    tvShow: tv,
                  );
                },
                itemCount: data.popularTVShows.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
