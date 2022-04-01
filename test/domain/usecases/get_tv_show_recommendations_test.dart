import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVShowRecommendations usecase;
  late MockTVShowRepository repository;
  setUp(() {
    repository = MockTVShowRepository();
    usecase = GetTVShowRecommendations(repository);
  });

  group('Get TV Show Recommendations', () {
    final tId = 1;
    final testTVShows = <TVShow>[];
    test('should get list tv show recommendation from the repository',
        () async {
      //arrage
      when(repository.getTVShowRecommendations(tId))
          .thenAnswer((_) async => Right(testTVShows));
      //act
      final result = await usecase.execute(tId);
      //assert
      expect(result, right(testTVShows));
    });
  });
}
