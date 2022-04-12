import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_shows/top_rated_tv_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../provider/top_rated_tv_shows_notifier_test.mocks.dart';

void main() {
  late MockGetTopRatedTVShows usecase;
  late TopRatedTVShowsBloc topRatedTVShowsBloc;

  setUp(() {
    usecase = MockGetTopRatedTVShows();
    topRatedTVShowsBloc = TopRatedTVShowsBloc(usecase);
  });

  test('the initial state should be empty', () {
    expect(topRatedTVShowsBloc.state, TopRatedTVShowsEmpty());
  });

  blocTest<TopRatedTVShowsBloc, TopRatedTVShowsState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(usecase.execute()).thenAnswer((_) async => Right(testTVShowList));
      return topRatedTVShowsBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedTVShowsCalled()),
    expect: () => [
      TopRatedTVShowsLoading(),
      TopRatedTVShowsHasData(testTVShowList),
    ],
    verify: (bloc) {
      verify(usecase.execute());
      return OnTopRatedTVShowsCalled().props;
    },
  );

  blocTest<TopRatedTVShowsBloc, TopRatedTVShowsState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(usecase.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTVShowsBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedTVShowsCalled()),
    expect: () => [
      TopRatedTVShowsLoading(),
      TopRatedTVShowsError('Server Failure'),
    ],
    verify: (bloc) => TopRatedTVShowsLoading(),
  );

  blocTest<TopRatedTVShowsBloc, TopRatedTVShowsState>(
    'should emit Loading state and then Empty state when the retrieved data is empty',
    build: () {
      when(usecase.execute()).thenAnswer((_) async => const Right([]));
      return topRatedTVShowsBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedTVShowsCalled()),
    expect: () => [
      TopRatedTVShowsLoading(),
      TopRatedTVShowsEmpty(),
    ],
  );
}
