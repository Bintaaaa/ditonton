import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVShowDetail usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = GetTVShowDetail(mockTVShowRepository);
  });
  final tId = 2;

  group('Get TV Shows Detail Test', () {
    test('should get tv show detail from the repository', () async {
      //arrage
      when(mockTVShowRepository.getTVShowDetail(tId))
          .thenAnswer((_) async => Right(testTVShowDetailEntity));
      //act
      final result = await usecase.execute(tId);
      //assert
      expect(result, Right(testTVShowDetailEntity));
    });
  });
}
