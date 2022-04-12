import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/tv/tv_show_detail/tv_show_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_show_detail_notifier_test.mocks.dart';

void main() {
  late MockGetTVShowDetail usecase;
  late TVShowDetailBloc tvShowDetailBloc;

  const testId = 1;

  setUp(() {
    usecase = MockGetTVShowDetail();
    tvShowDetailBloc = TVShowDetailBloc(usecase);
  });

  test('the initial state should be empty', () {
    expect(tvShowDetailBloc.state, TVShowDetailEmpty());
  });

  blocTest<TVShowDetailBloc, TVShowDetailState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(usecase.execute(testId))
          .thenAnswer((_) async => Right(testTVShowDetailEntity));
      return tvShowDetailBloc;
    },
    act: (bloc) => bloc.add(OnTVShowDetailCalled(testId)),
    expect: () => [
      TVShowDetailLoading(),
      TVShowDetailHasData(testTVShowDetailEntity),
    ],
    verify: (bloc) {
      verify(usecase.execute(testId));
      return OnTVShowDetailCalled(testId).props;
    },
  );

  blocTest<TVShowDetailBloc, TVShowDetailState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(usecase.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvShowDetailBloc;
    },
    act: (bloc) => bloc.add(OnTVShowDetailCalled(testId)),
    expect: () => [
      TVShowDetailLoading(),
      TVShowDetailError('Server Failure'),
    ],
    verify: (bloc) => TVShowDetailLoading(),
  );
}
