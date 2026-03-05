import 'package:json_annotation/json_annotation.dart';

part 'participation_dto.g.dart';

@JsonSerializable()
class ParticipationRequestDto {
  final int gameId;
  final int playerId;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final bool starter;

  ParticipationRequestDto({
    required this.gameId,
    required this.playerId,
    required this.goals,
    required this.assists,
    required this.yellowCards,
    required this.redCards,
    required this.starter,
  });

  Map<String, dynamic> toJson() => _$ParticipationRequestDtoToJson(this);
}

@JsonSerializable()
class ParticipationResponseDto {
  final int id;
  final int gameId;
  final int playerId;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final bool starter;

  ParticipationResponseDto({
    required this.id,
    required this.gameId,
    required this.playerId,
    required this.goals,
    required this.assists,
    required this.yellowCards,
    required this.redCards,
    required this.starter,
  });

  factory ParticipationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ParticipationResponseDtoFromJson(json);
}
