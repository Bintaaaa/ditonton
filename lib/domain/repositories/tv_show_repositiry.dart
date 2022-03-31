import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';

abstract class TVShowRepository {
  Future<Either<Failure, List<TVShow>>> getNowPlayingTVShows();
  Future<Either<Failure, TVShowDetail>> getTVShowDetail(int id);
}
