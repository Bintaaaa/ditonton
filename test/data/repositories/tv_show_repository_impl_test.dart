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
  late MockTVShowRemoteDataSource mockTVShowRemoteDataSource;

  setUp(() {
    mockTVShowRemoteDataSource = MockTVShowRemoteDataSource();
    repositoryImpl =
        TVShowRepositoryImpl(remoteDataSource: mockTVShowRemoteDataSource);
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
}
