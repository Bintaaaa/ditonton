import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_show_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVShowDetail,
  GetTVShowRecommendations,
])
void main() {
  late TVShowDetailNotifier provider;
  late MockGetTVShowDetail mockGetTVShowDetail;
  late MockGetTVShowRecommendations mockGetTVShowRecommendations;
  late int listenerCallCount;

  setUp(() {
    mockGetTVShowDetail = MockGetTVShowDetail();
    mockGetTVShowRecommendations = MockGetTVShowRecommendations();
    listenerCallCount = 0;
    provider = TVShowDetailNotifier(
      getTVShowDetail: mockGetTVShowDetail,
      getTVShowRecommendations: mockGetTVShowRecommendations,
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
}
