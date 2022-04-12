import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing_tv_shows/now_playing_tv_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_show_list_notifier_test.mocks.dart';

void main() {
  late MockGetNowPlayingTVShows usecase;
  late NowPlayingTVShowsBloc nowPlayingTVShowsBloc;

  setUp(() {
    usecase = MockGetNowPlayingTVShows();
    nowPlayingTVShowsBloc = NowPlayingTVShowsBloc(usecase);
  });

  test('the initial state should be empty', () {
    expect(nowPlayingTVShowsBloc.state, NowPlayingTVShowsEmpty());
  });

  blocTest<NowPlayingTVShowsBloc, NowPlayingTVShowsState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(usecase.execute()).thenAnswer((_) async => Right(testTVShowList));
      return nowPlayingTVShowsBloc;
    },
    act: (bloc) => bloc.add(OnNowPlayingTVShowsCalled()),
    expect: () => [
      NowPlayingTVShowsLoading(),
      NowPlayingTVShowsHasData(testTVShowList),
    ],
    verify: (bloc) {
      verify(usecase.execute());
      return OnNowPlayingTVShowsCalled().props;
    },
  );

  blocTest<NowPlayingTVShowsBloc, NowPlayingTVShowsState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(usecase.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingTVShowsBloc;
    },
    act: (bloc) => bloc.add(OnNowPlayingTVShowsCalled()),
    expect: () => [
      NowPlayingTVShowsLoading(),
      NowPlayingTVShowsError('Server Failure'),
    ],
    verify: (bloc) => NowPlayingTVShowsLoading(),
  );

  blocTest<NowPlayingTVShowsBloc, NowPlayingTVShowsState>(
    'should emit Loading state and then Empty state when the retrieved data is empty',
    build: () {
      when(usecase.execute()).thenAnswer((_) async => const Right([]));
      return nowPlayingTVShowsBloc;
    },
    act: (bloc) => bloc.add(OnNowPlayingTVShowsCalled()),
    expect: () => [
      NowPlayingTVShowsLoading(),
      NowPlayingTVShowsEmpty(),
    ],
  );
}
