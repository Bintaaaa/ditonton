import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/bloc/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/movie_bloc_test_helpers.mocks.dart';

void main() {
  late MockGetMovieDetail usecase;
  late MovieDetailBloc movieDetailBloc;

  const testId = 1;

  setUp(() {
    usecase = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(usecase);
  });

  test('the initial state should be empty', () {
    expect(movieDetailBloc.state, MovieDetailEmpty());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(usecase.execute(testId))
          .thenAnswer((_) async => Right(testMovieDetail));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(OnMovieDetailCalled(testId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailHasData(testMovieDetail),
    ],
    verify: (bloc) {
      verify(usecase.execute(testId));
      return OnMovieDetailCalled(testId).props;
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit Loading state and then Error state when dat failed to fetched',
    build: () {
      when(usecase.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(OnMovieDetailCalled(testId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailError('Server Failure'),
    ],
    verify: (bloc) => MovieDetailLoading(),
  );
}
