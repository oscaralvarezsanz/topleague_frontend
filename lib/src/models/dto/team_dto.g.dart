// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamRequestDto _$TeamRequestDtoFromJson(Map<String, dynamic> json) =>
    TeamRequestDto(
      leagueId: (json['leagueId'] as num).toInt(),
      name: json['name'] as String,
      gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
      points: (json['points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TeamRequestDtoToJson(TeamRequestDto instance) =>
    <String, dynamic>{
      'leagueId': instance.leagueId,
      'name': instance.name,
      'gamesPlayed': instance.gamesPlayed,
      'points': instance.points,
    };

TeamResponseDto _$TeamResponseDtoFromJson(Map<String, dynamic> json) =>
    TeamResponseDto(
      id: (json['id'] as num).toInt(),
      leagueId: (json['leagueId'] as num).toInt(),
      name: json['name'] as String,
      points: (json['points'] as num).toInt(),
      gamesPlayed: (json['gamesPlayed'] as num).toInt(),
    );

Map<String, dynamic> _$TeamResponseDtoToJson(TeamResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leagueId': instance.leagueId,
      'name': instance.name,
      'points': instance.points,
      'gamesPlayed': instance.gamesPlayed,
    };
