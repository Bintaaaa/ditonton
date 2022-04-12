import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_recommendations/tv_show_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_show_detail_notifier_test.mocks.dart';

void main() {
  late MockGetTVShowRecommendations usecase;
  late TVShowRecommendationsBloc tvShowRecommendationsBloc;

  const testId = 1;

  setUp(() {
    usecase = MockGetTVShowRecommendations();
    tvShowRecommendationsBloc = TVShowRecommendationsBloc(usecase);
  });

  test('the initial state should be empty', () {
    expect(tvShowRecommendationsBloc.state, TVShowRecommendationsEmpty());
  });

  blocTest<TVShowRecommendationsBloc, TVShowRecommendationsState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(usecase.execute(testId))
          .thenAnswer((_) async => Right(testTVShowList));
      return tvShowRecommendationsBloc;
    },
    act: (bloc) => bloc.add(OnTVShowRecommendationsCalled(testId)),
    expect: () => [
      TVShowRecommendationsLoading(),
      TVShowRecommendationsHasData(testTVShowList),
    ],
    verify: (bloc) {
      verify(usecase.execute(testId));
      return OnTVShowRecommendationsCalled(testId).props;
    },
  );

  blocTest<TVShowRecommendationsBloc, TVShowRecommendationsState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(usecase.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvShowRecommendationsBloc;
    },
    act: (bloc) => bloc.add(OnTVShowRecommendationsCalled(testId)),
    expect: () => [
      TVShowRecommendationsLoading(),
      TVShowRecommendationsError('Server Failure'),
    ],
    verify: (bloc) => TVShowRecommendationsLoading(),
  );

  blocTest<TVShowRecommendationsBloc, TVShowRecommendationsState>(
    'should emit Loading state and then Empty state when the retrieved data is empty',
    build: () {
      when(usecase.execute(testId)).thenAnswer((_) async => const Right([]));
      return tvShowRecommendationsBloc;
    },
    act: (bloc) => bloc.add(OnTVShowRecommendationsCalled(testId)),
    expect: () => [
      TVShowRecommendationsLoading(),
      TVShowRecommendationsEmpty(),
    ],
  );
}
