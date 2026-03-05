// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameRequestDto _$GameRequestDtoFromJson(Map<String, dynamic> json) =>
    GameRequestDto(
      leagueId: (json['leagueId'] as num).toInt(),
      awayTeamId: (json['awayTeamId'] as num).toInt(),
      homeTeamId: (json['homeTeamId'] as num).toInt(),
      awayScore: (json['awayScore'] as num).toInt(),
      homeScore: (json['homeScore'] as num).toInt(),
      date: json['date'] as String?,
      matchday: (json['matchday'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GameRequestDtoToJson(GameRequestDto instance) =>
    <String, dynamic>{
      'leagueId': instance.leagueId,
      'awayTeamId': instance.awayTeamId,
      'homeTeamId': instance.homeTeamId,
      'awayScore': instance.awayScore,
      'homeScore': instance.homeScore,
      'date': instance.date,
      'matchday': instance.matchday,
    };

GameResponseDto _$GameResponseDtoFromJson(Map<String, dynamic> json) =>
    GameResponseDto(
      id: (json['id'] as num).toInt(),
      leagueId: (json['leagueId'] as num).toInt(),
      awayTeamId: (json['awayTeamId'] as num).toInt(),
      homeTeamId: (json['homeTeamId'] as num).toInt(),
      awayScore: (json['awayScore'] as num).toInt(),
      homeScore: (json['homeScore'] as num).toInt(),
      date: json['date'] as String?,
      matchday: (json['matchday'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GameResponseDtoToJson(GameResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leagueId': instance.leagueId,
      'awayTeamId': instance.awayTeamId,
      'homeTeamId': instance.homeTeamId,
      'awayScore': instance.awayScore,
      'homeScore': instance.homeScore,
      'date': instance.date,
      'matchday': instance.matchday,
    };
