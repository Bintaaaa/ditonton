import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_show.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_show_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVShowDetail,
  GetTVShowRecommendations,
  GetWatchListStatusTVShow,
  SaveWatchlistTVShow,
  RemoveWatchlistTVShow,
])
void main() {
  late TVShowDetailNotifier provider;
  late MockGetTVShowDetail mockGetTVShowDetail;
  late MockGetTVShowRecommendations mockGetTVShowRecommendations;
  late MockGetWatchListStatusTVShow mockGetWatchlistStatus;
  late MockSaveWatchlistTVShow mockSaveWatchlist;
  late MockRemoveWatchlistTVShow mockRemoveWatchlist;

  late int listenerCallCount;

  setUp(() {
    mockGetTVShowDetail = MockGetTVShowDetail();
    mockGetTVShowRecommendations = MockGetTVShowRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTVShow();
    mockSaveWatchlist = MockSaveWatchlistTVShow();
    mockRemoveWatchlist = MockRemoveWatchlistTVShow();
    listenerCallCount = 0;
    provider = TVShowDetailNotifier(
      getTVShowDetail: mockGetTVShowDetail,
      getTVShowRecommendations: mockGetTVShowRecommendations,
      getWatchListStatusTVShow: mockGetWatchlistStatus,
      removeWatchlist: mockRemoveWatchlist,
      saveWatchlist: mockSaveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  void _arrageUseCase() {
    when(mockGetTVShowDetail.execute(tId))
        .thenAnswer((_) async => Right(testTVShowDetailResponseEntity));
    when(mockGetTVShowRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTVShowList));
  }

  group('Get TVShow Detail', () {
    test('should get data from the usecase', () async {
      //arrage
      _arrageUseCase();
      //act
      await provider.fetchTVShowDetail(tId);
      //assert
      verify(mockGetTVShowDetail.execute(tId));
    });

    test('should change state to loading when usecase is called', () {
      //arrage
      _arrageUseCase();
      //act
      provider.fetchTVShowDetail(tId);
      //assert
      expect(provider.tvShowState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv show when data is gotten successfully', () async {
      //arrage
      _arrageUseCase();
      //act
      await provider.fetchTVShowDetail(tId);
      //assert
      expect(provider.tvShowState, RequestState.Loaded);
      expect(provider.tvShowDetail, testTVShowDetailResponseEntity);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      _arrageUseCase();
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.tvShowState, RequestState.Loaded);
      expect(provider.tvShowRecommendations, testTVShowList);
    });
  });

  group('Get TVShow Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrageUseCase();
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      verify(mockGetTVShowRecommendations.execute(tId));
      expect(provider.tvShowRecommendations, testTVShowList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrageUseCase();
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvShowRecommendations, testTVShowList);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVShowDetailResponseEntity));
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVShowDetailResponseEntity))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTVShowDetailResponseEntity);
      // assert
      verify(mockSaveWatchlist.execute(testTVShowDetailResponseEntity));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testTVShowDetailResponseEntity))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testTVShowDetailResponseEntity);
      // assert
      verify(mockRemoveWatchlist.execute(testTVShowDetailResponseEntity));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVShowDetailResponseEntity))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTVShowDetailResponseEntity);
      // assert
      verify(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVShowDetailResponseEntity))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testTVShowDetailResponseEntity);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.tvShowState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
