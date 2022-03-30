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
  });
}
