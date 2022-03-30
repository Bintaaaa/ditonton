import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTVShows usecase;
  late MockTVShowRepository mockTVShowRepository;
  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = GetNowPlayingTVShows(repository: mockTVShowRepository);
  });

  final testTVShow = <TVShow>[];
  group('Get Now Playing TV Shows Test', () {
    test('should get list of tv shows from the repository', () async {
      // arrange
      when(mockTVShowRepository.getNowPlayingTVShows())
          .thenAnswer((_) async => Right(testTVShow));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(testTVShow));
    });
  });
}
