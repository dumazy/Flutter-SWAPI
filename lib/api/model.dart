import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

// @JsonSerializable()
// class PlanetResponseData {
//   final List<PlanetDto> result;

//   PlanetResponseData(this.result);
// }

@JsonSerializable()
class PlanetDto {
  final String name;
  final String diameter;

  PlanetDto(this.name, this.diameter);

  factory PlanetDto.fromJson(Map<String, dynamic> json) =>
      _$PlanetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetDtoToJson(this);
}
