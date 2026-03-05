import 'package:json_annotation/json_annotation.dart';

part 'player_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class PlayerRequestDto {
  final int? userId;
  final int leagueId;
  final int teamId;
  final String name;
  final String surname;
  final String position;
  final int jerseyNumber;

  PlayerRequestDto({
    this.userId,
    required this.leagueId,
    required this.teamId,
    required this.name,
    required this.surname,
    required this.position,
    required this.jerseyNumber,
  });

  Map<String, dynamic> toJson() => _$PlayerRequestDtoToJson(this);
}

@JsonSerializable()
class PlayerResponseDto {
  final int id;
  final int? userId;
  final int leagueId;
  final int teamId;
  final String name;
  final String surname;
  final String position;
  final int jerseyNumber;

  PlayerResponseDto({
    required this.id,
    this.userId,
    required this.leagueId,
    required this.teamId,
    required this.name,
    required this.surname,
    required this.position,
    required this.jerseyNumber,
  });

  factory PlayerResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerResponseDtoFromJson(json);
}

@JsonSerializable()
class PlayerStatsResponseDto {
  final int playerId;
  final int totalGoals;
  final int totalAssists;
  final int totalYellowCards;
  final int totalRedCards;
  final int totalGamesPlayed;
  final int totalGamesStarted;

  PlayerStatsResponseDto({
    required this.playerId,
    required this.totalGoals,
    required this.totalAssists,
    required this.totalYellowCards,
    required this.totalRedCards,
    required this.totalGamesPlayed,
    required this.totalGamesStarted,
  });

  factory PlayerStatsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatsResponseDtoFromJson(json);
}
