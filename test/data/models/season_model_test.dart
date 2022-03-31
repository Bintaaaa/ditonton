import 'package:ditonton/data/models/season_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  group('Season Model', () {
    test('should be a subclass of Season entity', () async {
      final result = testSeasonModel.toEntity();
      expect(result, testSeason);
    });
    test('should be a map of season', () async {
      final result = testSeasonModel.toJson();
      expect(result, testSeasonMap);
    });
    test('should be a SeasonModel entity instance', () async {
      final result = SeasonModel.fromJson(testSeasonMap);
      expect(result, testSeasonModel);
    });
  });
}
