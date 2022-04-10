import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_shows_page.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_show_notifier.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_shows_page_test.mocks.dart';

@GenerateMocks([WatchlistTVShowNotifier])
void main() {
  late MockWatchlistTVShowNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistTVShowNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistTVShowNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('watchlist tv shows', () {
    testWidgets('watchlist tv shows should display',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
      when(mockNotifier.watchlistTVShows).thenReturn(testTVShowList);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(find.byType(CardList), findsWidgets);
    });

    testWidgets('message for feedback should display when data is empty',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
      when(mockNotifier.watchlistTVShows).thenReturn(<TVShow>[]);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(find.text('Add your favorite movie!'), findsOneWidget);
    });

    testWidgets('loading indicator should display when getting data',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.Loading);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
