import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_show_detail_page_test.mocks.dart';

@GenerateMocks([TVShowDetailNotifier])
void main() {
  late MockTVShowDetailNotifier mockTVShowDetailNotifier;

  setUp(() {
    mockTVShowDetailNotifier = MockTVShowDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVShowDetailNotifier>.value(
      value: mockTVShowDetailNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('All required widget should display',
      (WidgetTester tester) async {
    //arrange
    when(mockTVShowDetailNotifier.tvShowState).thenReturn(RequestState.Loaded);
    when(mockTVShowDetailNotifier.tvShowDetail)
        .thenReturn(testTVShowDetailResponseEntity);
    when(mockTVShowDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(mockTVShowDetailNotifier.tvShowRecommendations).thenReturn(<TVShow>[]);
    //act
    await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

    //assert
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(RatingBarIndicator), findsOneWidget);
    expect(find.byType(Row), findsWidgets);
    expect(find.byType(Text), findsWidgets);
  });
}
