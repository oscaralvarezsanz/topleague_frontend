import 'package:json_annotation/json_annotation.dart';

part 'game_dto.g.dart';

@JsonSerializable()
class GameRequestDto {
  final int leagueId;
  final int awayTeamId;
  final int homeTeamId;
  final int awayScore;
  final int homeScore;
  final String? date;
  final int? matchday;

  GameRequestDto({
    required this.leagueId,
    required this.awayTeamId,
    required this.homeTeamId,
    required this.awayScore,
    required this.homeScore,
    this.date,
    this.matchday,
  });

  Map<String, dynamic> toJson() => _$GameRequestDtoToJson(this);
}

@JsonSerializable()
class GameResponseDto {
  final int id;
  final int leagueId;
  final int awayTeamId;
  final int homeTeamId;
  final int awayScore;
  final int homeScore;
  final String? date;
  final int? matchday;

  GameResponseDto({
    required this.id,
    required this.leagueId,
    required this.awayTeamId,
    required this.homeTeamId,
    required this.awayScore,
    required this.homeScore,
    this.date,
    this.matchday,
  });

  factory GameResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GameResponseDtoFromJson(json);
}
