import 'package:json_annotation/json_annotation.dart';

part 'team_dto.g.dart';

@JsonSerializable()
class TeamRequestDto {
  final int leagueId;
  final String name;
  final int gamesPlayed;
  final int points;

  TeamRequestDto({
    required this.leagueId,
    required this.name,
    this.gamesPlayed = 0,
    this.points = 0,
  });

  Map<String, dynamic> toJson() => _$TeamRequestDtoToJson(this);
}

@JsonSerializable()
class TeamResponseDto {
  final int id;
  final int leagueId;
  final String name;
  final int points;
  final int gamesPlayed;

  TeamResponseDto({
    required this.id,
    required this.leagueId,
    required this.name,
    required this.points,
    required this.gamesPlayed,
  });

  factory TeamResponseDto.fromJson(Map<String, dynamic> json) {
    return TeamResponseDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      leagueId: (json['leagueId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      points: (json['points'] as num?)?.toInt() ?? 0,
      gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
    );
  }
}
