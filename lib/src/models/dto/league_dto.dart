import 'package:json_annotation/json_annotation.dart';

part 'league_dto.g.dart';

@JsonSerializable()
class LeagueRequestDto {
  final String name;

  LeagueRequestDto({required this.name});

  Map<String, dynamic> toJson() => _$LeagueRequestDtoToJson(this);
}

@JsonSerializable()
class LeagueResponseDto {
  final int id;
  final String name;
  final int adminId;

  LeagueResponseDto({
    required this.id,
    required this.name,
    required this.adminId,
  });

  factory LeagueResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LeagueResponseDtoFromJson(json);
}
