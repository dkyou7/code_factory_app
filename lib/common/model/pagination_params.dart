import 'package:json_annotation/json_annotation.dart';

// flutter pub run build_runner watch
part 'pagination_params.g.dart';

@JsonSerializable()
class PaginationParams {
  final String? after;
  final int? count;

  const PaginationParams({
    this.after,
    this.count,
  });

  PaginationParams copyWith({
    String? after,
    int? count,
  }) {
    return PaginationParams(
      after: after ?? this.after,
      count: count ?? this.count,
    );
  }

  factory PaginationParams.fromJson(Map<String, dynamic> json)
  => _$PaginationParamsFromJson(json);

  Map<String,dynamic> toJson() => _$PaginationParamsToJson(this);
}