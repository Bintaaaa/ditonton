import 'package:ditonton/data/models/tv_show_model.dart';
import 'package:equatable/equatable.dart';

class TVShowResponse extends Equatable {
  final List<TVShowModel> tvShowList;

  TVShowResponse({required this.tvShowList});

  factory TVShowResponse.fromJson(Map<String, dynamic> json) => TVShowResponse(
        tvShowList: List<TVShowModel>.from((json['results'] as List)
            .map((x) => TVShowModel.fromJson(x))
            .where((element) => element.backdropPath != null)),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(tvShowList.map((e) => e.toJson())),
      };

  @override
  List<Object?> get props => [tvShowList];
}
