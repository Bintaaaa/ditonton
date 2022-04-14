import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_shows/watchlist_tv_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/tv_show_bloc_test_helpers.mocks.dart';

void main() {
  late MockGetWatchlistTVShows getWatchlistTVShows;
  late MockGetWatchListStatusTVShow getWatchlistStatus;
  late MockRemoveWatchlistTVShow removeWatchlist;
  late MockSaveWatchlistTVShow saveWatchlist;
  late WatchlistTVShowsBloc watchlistTVShowsBloc;

  setUp(() {
    getWatchlistTVShows = MockGetWatchlistTVShows();
    getWatchlistStatus = MockGetWatchListStatusTVShow();
    removeWatchlist = MockRemoveWatchlistTVShow();
    saveWatchlist = MockSaveWatchlistTVShow();
    watchlistTVShowsBloc = WatchlistTVShowsBloc(
      getWatchlistTVShows,
      getWatchlistStatus,
      removeWatchlist,
      saveWatchlist,
    );
  });

  test('the initial state should be Initial state', () {
    expect(watchlistTVShowsBloc.state, TVShowWatchlistInitial());
  });

  group(
    'get watchlist tv shows test cases',
    () {
      blocTest<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        'should emit Loading state and then HasData state when watchlist data successfully retrieved',
        build: () {
          when(getWatchlistTVShows.execute())
              .thenAnswer((_) async => Right(testWatchlistTVShow));
          return watchlistTVShowsBloc;
        },
        act: (bloc) => bloc.add(OnFetchTVShowWatchlist()),
        expect: () => [
          TVShowWatchlistLoading(),
          TVShowWatchlistHasData(testWatchlistTVShow),
        ],
        verify: (bloc) {
          verify(getWatchlistTVShows.execute());
          return OnFetchTVShowWatchlist().props;
        },
      );

      blocTest<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        'should emit Loading state and then Error state when watchlist data failed to retrieved',
        build: () {
          when(getWatchlistTVShows.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return watchlistTVShowsBloc;
        },
        act: (bloc) => bloc.add(OnFetchTVShowWatchlist()),
        expect: () => [
          TVShowWatchlistLoading(),
          TVShowWatchlistError('Server Failure'),
        ],
        verify: (bloc) => TVShowWatchlistLoading(),
      );

      blocTest<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        'should emit Loading state and then Empty state when the retrieved watchlist data is empty',
        build: () {
          when(getWatchlistTVShows.execute())
              .thenAnswer((_) async => const Right([]));
          return watchlistTVShowsBloc;
        },
        act: (bloc) => bloc.add(OnFetchTVShowWatchlist()),
        expect: () => [
          TVShowWatchlistLoading(),
          TVShowWatchlistEmpty(),
        ],
      );
    },
  );

  group(
    'get watchlist status test cases',
    () {
      blocTest<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        'should be true when the watchlist status is also true',
        build: () {
          when(getWatchlistStatus.execute(testTVShowDetailEntity.id))
              .thenAnswer((_) async => true);
          return watchlistTVShowsBloc;
        },
        act: (bloc) =>
            bloc.add(FetchWatchlistStatusTVShow(testTVShowDetailEntity.id)),
        expect: () => [
          TVShowIsAddedToWatchlist(true),
        ],
        verify: (bloc) {
          verify(getWatchlistStatus.execute(testTVShowDetailEntity.id));
          return FetchWatchlistStatusTVShow(testTVShowDetailEntity.id).props;
        },
      );

      blocTest<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        'should be false when the watchlist status is also false',
        build: () {
          when(getWatchlistStatus.execute(testTVShowDetailEntity.id))
              .thenAnswer((_) async => false);
          return watchlistTVShowsBloc;
        },
        act: (bloc) =>
            bloc.add(FetchWatchlistStatusTVShow(testTVShowDetailEntity.id)),
        expect: () => [
          TVShowIsAddedToWatchlist(false),
        ],
        verify: (bloc) {
          verify(getWatchlistStatus.execute(testTVShowDetailEntity.id));
          return FetchWatchlistStatusTVShow(testTVShowDetailEntity.id).props;
        },
      );
    },
  );

  group(
    'add and remove watchlist test cases',
    () {
      blocTest<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        'should update watchlist status when adding watchlist succeeded',
        build: () {
          when(saveWatchlist.execute(testTVShowDetailEntity))
              .thenAnswer((_) async => const Right('Added to Watchlist'));
          return watchlistTVShowsBloc;
        },
        act: (bloc) => bloc.add(AddTVShowToWatchlist(testTVShowDetailEntity)),
        expect: () => [
          TVShowWatchlistMessage('Added to Watchlist'),
        ],
        verify: (bloc) {
          verify(saveWatchlist.execute(testTVShowDetailEntity));
          return AddTVShowToWatchlist(testTVShowDetailEntity).props;
        },
      );

      blocTest<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        'should throw failure message status when adding watchlist failed',
        build: () {
          when(saveWatchlist.execute(testTVShowDetailEntity)).thenAnswer(
              (_) async =>
                  Left(DatabaseFailure('can\'t add data to watchlist')));
          return watchlistTVShowsBloc;
        },
        act: (bloc) => bloc.add(AddTVShowToWatchlist(testTVShowDetailEntity)),
        expect: () => [
          TVShowWatchlistError('can\'t add data to watchlist'),
        ],
        verify: (bloc) {
          verify(saveWatchlist.execute(testTVShowDetailEntity));
          return AddTVShowToWatchlist(testTVShowDetailEntity).props;
        },
      );

      blocTest<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        'should update watchlist status when removing watchlist succeeded',
        build: () {
          when(removeWatchlist.execute(testTVShowDetailEntity))
              .thenAnswer((_) async => const Right('Removed from Watchlist'));
          return watchlistTVShowsBloc;
        },
        act: (bloc) =>
            bloc.add(RemoveTVShowFromWatchlist(testTVShowDetailEntity)),
        expect: () => [
          TVShowWatchlistMessage('Removed from Watchlist'),
        ],
        verify: (bloc) {
          verify(removeWatchlist.execute(testTVShowDetailEntity));
          return RemoveTVShowFromWatchlist(testTVShowDetailEntity).props;
        },
      );

      blocTest<WatchlistTVShowsBloc, WatchlistTVShowsState>(
        'should throw failure message status when removing watchlist failed',
        build: () {
          when(removeWatchlist.execute(testTVShowDetailEntity)).thenAnswer(
              (_) async =>
                  Left(DatabaseFailure('can\'t add data to watchlist')));
          return watchlistTVShowsBloc;
        },
        act: (bloc) =>
            bloc.add(RemoveTVShowFromWatchlist(testTVShowDetailEntity)),
        expect: () => [
          TVShowWatchlistError('can\'t add data to watchlist'),
        ],
        verify: (bloc) {
          verify(removeWatchlist.execute(testTVShowDetailEntity));
          return RemoveTVShowFromWatchlist(testTVShowDetailEntity).props;
        },
      );
    },
  );
}
