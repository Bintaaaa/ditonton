part of 'popular_movies_bloc.dart';

abstract class PopularMoviesEvent extends Equatable {}

class OnPopularMoviesCalled extends PopularMoviesEvent {
  @override
  List<Object> get props => [];
}
