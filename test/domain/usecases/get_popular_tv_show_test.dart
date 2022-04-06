import 'package:dartz/dartz.dart';
import 'package:ditonton/data/datasources/tv_show_remote_data_source.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTVShows usecase;
  late MockTVShowRepository repository;

  setUp(() {
    repository = MockTVShowRepository();
    usecase = GetPopularTVShows(repository);
  });

  final testTVShow = <TVShow>[];

  group('Get Popular TVShows', () {
    test(
        'should get list of tv shows form the reposiroty exeecute function is called',
        () async {
      //arrange
      when(repository.getPopularTVShows())
          .thenAnswer((_) async => Right(testTVShow));
      //act
      final result = await usecase.execute();
      //assert
      expect(result, Right(testTVShow));
    });
  });
}
