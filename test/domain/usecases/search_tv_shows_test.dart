import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/search_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTVShowRepository mockTVShowRepository;
  late SearchTVShows usecase;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = SearchTVShows(mockTVShowRepository);
  });

  final testTVShow = <TVShow>[];
  final tQuery = 'Spiderman';

  group('Search TV Shows', () {
    test('sould get list of tv shows from the repository', () async {
      //arrage
      when(mockTVShowRepository.searchTVShows(tQuery))
          .thenAnswer((_) async => Right(testTVShow));
      //act
      final result = await usecase.execute(tQuery);
      //assert
      expect(result, Right(testTVShow));
    });
  });
}
