import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';

abstract class TVShowRepository {
  Future<Either<Failure, List<TVShow>>> getNowPlayingTVShows();
  Future<Either<Failure, TVShowDetail>> getTVShowDetail(int id);
  Future<Either<Failure, List<TVShow>>> getPopularTVShows();
  Future<Either<Failure, List<TVShow>>> getTopRatedTVShows();
  Future<Either<Failure, List<TVShow>>> getTVShowRecommendations(int id);
}
