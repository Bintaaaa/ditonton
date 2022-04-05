import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_tv_shows.dart';
import 'package:ditonton/presentation/provider/tv_show_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_shows_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTVShows])
void main() {
  late TVShowsSearchNotifier provider;
  late MockSearchTVShows mockSearchTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTVShows = MockSearchTVShows();
    provider = TVShowsSearchNotifier(
      searchTVShows: mockSearchTVShows,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tQuery = 'squid game';

  group('search tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      provider.fetchTVShowsSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      await provider.fetchTVShowsSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, testTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTVShowsSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
