import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_show_detail_model.dart';
import 'package:ditonton/data/models/tv_show_model.dart';
import 'package:ditonton/data/models/tv_show_response.dart';
import 'package:http/http.dart' as http;

abstract class TVShowRemoteDataSource {
  Future<List<TVShowModel>> getNowPlayingTVShows();
  Future<TVShowDetailModel> getTVShowDetail(int id);
  Future<List<TVShowModel>> getPopularTVShows();
  Future<List<TVShowModel>> getTVShowRecommendations(int id);
}

class TVShowRemoteDataSourceImpl implements TVShowRemoteDataSource {
  final http.Client client;

  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  TVShowRemoteDataSourceImpl({required this.client});
  @override
  Future<List<TVShowModel>> getNowPlayingTVShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TVShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVShowDetailModel> getTVShowDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));
    if (response.statusCode == 200) {
      return TVShowDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVShowModel>> getTVShowRecommendations(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TVShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVShowModel>> getPopularTVShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TVShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }
}
