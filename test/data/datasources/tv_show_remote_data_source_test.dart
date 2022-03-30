import 'dart:convert';
import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_show_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TVShowRemoteDataSourceImpl dataSourceImpl;
  late MockHttpClient mockHttpClient;
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';
  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = TVShowRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing TV Shows', () {
    final testTVShowList = TVShowResponse.fromJson(
            json.decode(readJson('dummy_data/on_the_air.json')))
        .tvShowList;

    test('should return list of TVShow Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/on_the_air.json'), 200,
                  headers: {
                    HttpHeaders.contentTypeHeader:
                        'application/json; charset=utf-8',
                  }));
      // act
      final result = await dataSourceImpl.getNowPlayingTVShows();
      // assert
      expect(result, equals(testTVShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getNowPlayingTVShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
