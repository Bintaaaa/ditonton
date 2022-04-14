import 'package:ditonton/presentation/bloc/tv/watchlist_tv_shows/watchlist_tv_shows_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_shows_page.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/tv_show_page_test_helpers.dart';

void main() {
  late FakeWatchlistTVShowsBloc fakeWatchlistTVShowsBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTVShowsEvent());
    registerFallbackValue(FakeWatchlistTVShowsState());
    fakeWatchlistTVShowsBloc = FakeWatchlistTVShowsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTVShowsBloc>(
      create: (_) => fakeWatchlistTVShowsBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeWatchlistTVShowsBloc.close();
  });

  group('watchlist tv shows', () {
    testWidgets('loading indicator should display when getting data',
        (WidgetTester tester) async {
      when(() => fakeWatchlistTVShowsBloc.state)
          .thenReturn(TVShowWatchlistLoading());

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('watchlist tv shows should display',
        (WidgetTester tester) async {
      when(() => fakeWatchlistTVShowsBloc.state)
          .thenReturn(TVShowWatchlistHasData(testTVShowList));

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CardList), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('message for feedback should display when data is empty',
        (WidgetTester tester) async {
      when(() => fakeWatchlistTVShowsBloc.state)
          .thenReturn(TVShowWatchlistEmpty());

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(find.text('No watchlist tv show yet!'), findsOneWidget);
    });
  });
}
