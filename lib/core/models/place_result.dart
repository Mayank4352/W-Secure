import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/place_result.freezed.dart';
part 'generated/place_result.g.dart';

@freezed
class PlaceResult with _$PlaceResult {
  const PlaceResult._();

  const factory PlaceResult({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    String? address,
    String? primaryType,
    @Default(<String>[]) List<String> types,
  }) = _PlaceResult;

  factory PlaceResult.fromJson(Map<String, dynamic> json) =>
      _$PlaceResultFromJson(json);

  Iterable<String> get allTypes => [
        if (primaryType != null) primaryType!,
        ...types,
      ];
}
