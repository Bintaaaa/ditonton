import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/movie_bloc_test_helpers.mocks.dart';

void main() {
  late MockGetPopularMovies usecase;
  late PopularMoviesBloc popularMoviesBloc;

  setUp(() {
    usecase = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(usecase);
  });

  test('the initial state should be empty', () {
    expect(popularMoviesBloc.state, PopularMoviesEmpty());
  });
  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(usecase.execute()).thenAnswer((_) async => Right(testMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(OnPopularMoviesCalled()),
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(usecase.execute());
      return OnPopularMoviesCalled().props;
    },
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(usecase.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(OnPopularMoviesCalled()),
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesError('Server Failure'),
    ],
    verify: (bloc) => PopularMoviesLoading(),
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
      'should emit Loading state then Empty state when the retrieved data is Empty',
      build: () {
        when(usecase.execute()).thenAnswer((_) async => Right([]));
        return popularMoviesBloc;
      },
      act: (bloc) => bloc.add(OnPopularMoviesCalled()),
      expect: () => [
            PopularMoviesLoading(),
            PopularMoviesEmpty(),
          ]);
}
