import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/repositories/tv_show_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVShowRepositoryImpl repositoryImpl;
  late MockTVShowLocalDataSource mockLocalDataSource;
  late MockTVShowRemoteDataSource mockTVShowRemoteDataSource;

  setUp(() {
    mockTVShowRemoteDataSource = MockTVShowRemoteDataSource();
    mockLocalDataSource = MockTVShowLocalDataSource();
    repositoryImpl = TVShowRepositoryImpl(
      remoteDataSource: mockTVShowRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group("Now Playing TV Shows", () {
    test(
        "should return remote data when the call to remote data source is successful",
        () async {
      //arrage
      when(mockTVShowRemoteDataSource.getNowPlayingTVShows())
          .thenAnswer((_) async => testTVShowModelList);

      //act
      final result = await repositoryImpl.getNowPlayingTVShows();

      //assert
      verify(mockTVShowRemoteDataSource.getNowPlayingTVShows());
      final resultList = result.getOrElse(() => []);
      expect(resultList, testTVShowList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getNowPlayingTVShows())
          .thenThrow(ServerException());
      // act
      final result = await repositoryImpl.getNowPlayingTVShows();
      // assert
      verify(mockTVShowRemoteDataSource.getNowPlayingTVShows());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getNowPlayingTVShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repositoryImpl.getNowPlayingTVShows();
      // assert
      verify(mockTVShowRemoteDataSource.getNowPlayingTVShows());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('TV Show Detail', () {
    final tId = 1;
    test(
        'should return TV Show data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getTVShowDetail(tId))
          .thenAnswer((_) async => testTVShowDetailResponse);
      // act
      final result = await repositoryImpl.getTVShowDetail(tId);
      // assert
      verify(mockTVShowRemoteDataSource.getTVShowDetail(tId));
      expect(result, equals(Right(testTVShowDetailResponseEntity)));
    });

    test(
        'should return server failure when  to remote data source is  unsuccessful',
        () async {
      //arrage
      when(mockTVShowRemoteDataSource.getTVShowDetail(tId))
          .thenThrow(ServerException());
      //act
      final result = await repositoryImpl.getTVShowDetail(tId);
      //assert
      verify(mockTVShowRemoteDataSource.getTVShowDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getTVShowDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repositoryImpl.getTVShowDetail(tId);
      // assert
      verify(mockTVShowRemoteDataSource.getTVShowDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TV Show Recommendations', () {
    final tId = 1;

    test('should return data (tv show list) when the call is successful',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getTVShowRecommendations(tId))
          .thenAnswer((_) async => testTVShowModelList);
      // act
      final result = await repositoryImpl.getTVShowRecommendations(tId);
      // assert
      verify(mockTVShowRemoteDataSource.getTVShowRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(testTVShowList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getTVShowRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repositoryImpl.getTVShowRecommendations(tId);
      // assertbuild runner
      verify(mockTVShowRemoteDataSource.getTVShowRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getTVShowRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repositoryImpl.getTVShowRecommendations(tId);
      // assert
      verify(mockTVShowRemoteDataSource.getTVShowRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular TV Shows', () {
    test('should return tv show list when call to data source is success',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getPopularTVShows())
          .thenAnswer((_) async => testTVShowModelList);
      // act
      final result = await repositoryImpl.getPopularTVShows();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, testTVShowList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getPopularTVShows())
          .thenThrow(ServerException());
      // act
      final result = await repositoryImpl.getPopularTVShows();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getPopularTVShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repositoryImpl.getPopularTVShows();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Top rated TV show', () {
    test('should return tv show list when call to data source is successful',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getTopRatedTVShows())
          .thenAnswer((_) async => testTVShowModelList);
      // act
      final result = await repositoryImpl.getTopRatedTVShows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, testTVShowList);
    });
    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      //arrange
      when(mockTVShowRemoteDataSource.getTopRatedTVShows())
          .thenThrow(ServerException());
      //act
      final result = await repositoryImpl.getTopRatedTVShows();
      //assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.getTopRatedTVShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repositoryImpl.getTopRatedTVShows();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Seach TV Shows', () {
    final tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.searchTVShows(tQuery))
          .thenAnswer((_) async => testTVShowModelList);
      // act
      final result = await repositoryImpl.searchTVShows(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, testTVShowList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.searchTVShows(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repositoryImpl.searchTVShows(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockTVShowRemoteDataSource.searchTVShows(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repositoryImpl.searchTVShows(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTVShowTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result =
          await repositoryImpl.saveWatchlist(testTVShowDetailResponseEntity);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTVShowTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result =
          await repositoryImpl.saveWatchlist(testTVShowDetailResponseEntity);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });
  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTVShowTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result =
          await repositoryImpl.removeWatchlist(testTVShowDetailResponseEntity);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTVShowTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result =
          await repositoryImpl.removeWatchlist(testTVShowDetailResponseEntity);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTVShowById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repositoryImpl.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv shows', () {
    test('should return list of TV Shows', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTVShows())
          .thenAnswer((_) async => testTVShowTableList);
      // act
      final result = await repositoryImpl.getWatchlistTVShows();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, testWatchlistTVShow);
    });
  });
}
