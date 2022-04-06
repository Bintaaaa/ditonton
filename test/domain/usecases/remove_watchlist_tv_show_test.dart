import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTVShow usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = RemoveWatchlistTVShow(mockTVShowRepository);
  });

  test('should remove watchlist tv show from repository', () async {
    // arrange
    when(mockTVShowRepository.removeWatchlist(testTVShowDetailResponseEntity))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTVShowDetailResponseEntity);
    // assert
    verify(
        mockTVShowRepository.removeWatchlist(testTVShowDetailResponseEntity));
    expect(result, Right('Removed from watchlist'));
  });
}
