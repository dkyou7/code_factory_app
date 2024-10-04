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
  factory PaginationParams.fromJson(Map<String, dynamic> json)
  => _$PaginationParamsFromJson(json);
}