// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipationRequestDto _$ParticipationRequestDtoFromJson(
  Map<String, dynamic> json,
) => ParticipationRequestDto(
  gameId: (json['gameId'] as num).toInt(),
  playerId: (json['playerId'] as num).toInt(),
  goals: (json['goals'] as num).toInt(),
  assists: (json['assists'] as num).toInt(),
  yellowCards: (json['yellowCards'] as num).toInt(),
  redCards: (json['redCards'] as num).toInt(),
  starter: json['starter'] as bool,
);

Map<String, dynamic> _$ParticipationRequestDtoToJson(
  ParticipationRequestDto instance,
) => <String, dynamic>{
  'gameId': instance.gameId,
  'playerId': instance.playerId,
  'goals': instance.goals,
  'assists': instance.assists,
  'yellowCards': instance.yellowCards,
  'redCards': instance.redCards,
  'starter': instance.starter,
};

ParticipationResponseDto _$ParticipationResponseDtoFromJson(
  Map<String, dynamic> json,
) => ParticipationResponseDto(
  id: (json['id'] as num).toInt(),
  gameId: (json['gameId'] as num).toInt(),
  playerId: (json['playerId'] as num).toInt(),
  goals: (json['goals'] as num).toInt(),
  assists: (json['assists'] as num).toInt(),
  yellowCards: (json['yellowCards'] as num).toInt(),
  redCards: (json['redCards'] as num).toInt(),
  starter: json['starter'] as bool,
);

Map<String, dynamic> _$ParticipationResponseDtoToJson(
  ParticipationResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'gameId': instance.gameId,
  'playerId': instance.playerId,
  'goals': instance.goals,
  'assists': instance.assists,
  'yellowCards': instance.yellowCards,
  'redCards': instance.redCards,
  'starter': instance.starter,
};
