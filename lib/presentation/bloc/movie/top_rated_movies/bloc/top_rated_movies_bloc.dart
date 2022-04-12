import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;
  TopRatedMoviesBloc(this._getTopRatedMovies) : super(TopRatedMoviesEmpty()) {
    on<OnTopRatedMoviesCalled>(_onTopRatedMoviesCalled);
  }

  FutureOr<void> _onTopRatedMoviesCalled(
    OnTopRatedMoviesCalled event,
    Emitter<TopRatedMoviesState> emit,
  ) async {
    emit(TopRatedMoviesLoading());

    final result = await _getTopRatedMovies.execute();

    result.fold((failure) {
      emit(TopRatedMoviesError(failure.message));
    }, (data) {
      data.isEmpty
          ? emit(TopRatedMoviesEmpty())
          : emit(TopRatedMoviesHasData(data));
    });
  }
}
