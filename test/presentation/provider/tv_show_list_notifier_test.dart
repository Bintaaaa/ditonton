import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_shows.dart';
import 'package:ditonton/presentation/provider/tv_show_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_show_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVShows])
void main() {
  late TVShowListNotifier provider;
  late MockGetNowPlayingTVShows mockGetNowPlayingTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTVShows = MockGetNowPlayingTVShows();

    provider = TVShowListNotifier(
      getNowPlayingTVShows: mockGetNowPlayingTVShows,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('now playing tv shows', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      //arrage
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      //act
      await provider.fetchNowPlayingTVShows();
      //arrage
      verify(mockGetNowPlayingTVShows.execute());
    });

    test('should  change state to Loading State when usecase is called',
        () async {
      //arrage
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      //act
      provider.fetchNowPlayingTVShows();
      //assert
      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test('should return tv shows when data is successfully', () async {
      //arrage
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      //act
      await provider.fetchNowPlayingTVShows();
      //assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlayingTVShows, testTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      //arrage
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      //act
      await provider.fetchNowPlayingTVShows();
      //assert
      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
