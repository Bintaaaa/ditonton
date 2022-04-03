// Mocks generated by Mockito 5.1.0 from annotations
// in ditonton/test/presentation/pages/tv_show_detail_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;
import 'dart:ui' as _i9;

import 'package:ditonton/common/state_enum.dart' as _i6;
import 'package:ditonton/domain/entities/tv_show.dart' as _i7;
import 'package:ditonton/domain/entities/tv_show_detail.dart' as _i4;
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart' as _i2;
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart'
    as _i3;
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart'
    as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeGetTVShowDetail_0 extends _i1.Fake implements _i2.GetTVShowDetail {}

class _FakeGetTVShowRecommendations_1 extends _i1.Fake
    implements _i3.GetTVShowRecommendations {}

class _FakeTVShowDetail_2 extends _i1.Fake implements _i4.TVShowDetail {}

/// A class which mocks [TVShowDetailNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockTVShowDetailNotifier extends _i1.Mock
    implements _i5.TVShowDetailNotifier {
  MockTVShowDetailNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetTVShowDetail get getTVShowDetail =>
      (super.noSuchMethod(Invocation.getter(#getTVShowDetail),
          returnValue: _FakeGetTVShowDetail_0()) as _i2.GetTVShowDetail);
  @override
  _i3.GetTVShowRecommendations get getTVShowRecommendations =>
      (super.noSuchMethod(Invocation.getter(#getTVShowRecommendations),
              returnValue: _FakeGetTVShowRecommendations_1())
          as _i3.GetTVShowRecommendations);
  @override
  _i4.TVShowDetail get tvShowDetail =>
      (super.noSuchMethod(Invocation.getter(#tvShowDetail),
          returnValue: _FakeTVShowDetail_2()) as _i4.TVShowDetail);
  @override
  _i6.RequestState get tvShowState =>
      (super.noSuchMethod(Invocation.getter(#tvShowState),
          returnValue: _i6.RequestState.Empty) as _i6.RequestState);
  @override
  List<_i7.TVShow> get tvShowRecommendations =>
      (super.noSuchMethod(Invocation.getter(#tvShowRecommendations),
          returnValue: <_i7.TVShow>[]) as List<_i7.TVShow>);
  @override
  _i6.RequestState get recommendationState =>
      (super.noSuchMethod(Invocation.getter(#recommendationState),
          returnValue: _i6.RequestState.Empty) as _i6.RequestState);
  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i8.Future<void> fetchTVShowDetail(int? id) =>
      (super.noSuchMethod(Invocation.method(#fetchTVShowDetail, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  void addListener(_i9.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i9.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}