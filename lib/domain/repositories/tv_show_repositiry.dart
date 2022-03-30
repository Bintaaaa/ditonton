import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';

abstract class TVShowRepository {
  Future<Either<Failure, List<TVShow>>> getNowPlayingTVShows();
}
