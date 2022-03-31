import 'package:ditonton/data/models/tv_show_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  group('TV Show Detail Model', () {
    test('should be a subclass of TVShowDetail entity', () {
      final result = testTVShowDetail.toEntity();
      expect(result, testTVShowDetailEntity);
    });
    test('should be a map of TVShow', () async {
      final result = testTVShowDetail.toJson();
      expect(result, testTVShowMap);
    });

    test('should be a TVShowDetailResponse instance', () async {
      final result = TVShowDetailModel.fromJson(testTVShowMap);
      expect(result, testTVShowDetail);
    });
  });
}
