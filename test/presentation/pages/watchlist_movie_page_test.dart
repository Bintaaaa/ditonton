import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieNotifier])
void main() {
  late MockWatchlistMovieNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistMovieNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistMovieNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('watchlist movies', () {
    testWidgets('watchlist movies should display', (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
      when(mockNotifier.watchlistMovies).thenReturn(testMovieList);

      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CardList), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('message for feedback should display when data is empty',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
      when(mockNotifier.watchlistMovies).thenReturn(<Movie>[]);

      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      expect(find.text('Add your favorite movie!'), findsOneWidget);
    });

    testWidgets('loading indicator should display when getting data',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.Loading);

      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
