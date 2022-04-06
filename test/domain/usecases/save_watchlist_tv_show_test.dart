import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTVShow usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = SaveWatchlistTVShow(mockTVShowRepository);
  });

  test('should save tv show to the repository', () async {
    // arrange
    when(mockTVShowRepository.saveWatchlist(testTVShowDetailResponseEntity))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTVShowDetailResponseEntity);
    // assert
    verify(mockTVShowRepository.saveWatchlist(testTVShowDetailResponseEntity));
    expect(result, Right('Added to Watchlist'));
  });
}
