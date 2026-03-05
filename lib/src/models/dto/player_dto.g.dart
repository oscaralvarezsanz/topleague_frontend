// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerRequestDto _$PlayerRequestDtoFromJson(Map<String, dynamic> json) =>
    PlayerRequestDto(
      userId: (json['userId'] as num?)?.toInt(),
      leagueId: (json['leagueId'] as num).toInt(),
      teamId: (json['teamId'] as num).toInt(),
      name: json['name'] as String,
      surname: json['surname'] as String,
      position: json['position'] as String,
      jerseyNumber: (json['jerseyNumber'] as num).toInt(),
    );

Map<String, dynamic> _$PlayerRequestDtoToJson(PlayerRequestDto instance) =>
    <String, dynamic>{
      'userId': ?instance.userId,
      'leagueId': instance.leagueId,
      'teamId': instance.teamId,
      'name': instance.name,
      'surname': instance.surname,
      'position': instance.position,
      'jerseyNumber': instance.jerseyNumber,
    };

PlayerResponseDto _$PlayerResponseDtoFromJson(Map<String, dynamic> json) =>
    PlayerResponseDto(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      leagueId: (json['leagueId'] as num).toInt(),
      teamId: (json['teamId'] as num).toInt(),
      name: json['name'] as String,
      surname: json['surname'] as String,
      position: json['position'] as String,
      jerseyNumber: (json['jerseyNumber'] as num).toInt(),
    );

Map<String, dynamic> _$PlayerResponseDtoToJson(PlayerResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'leagueId': instance.leagueId,
      'teamId': instance.teamId,
      'name': instance.name,
      'surname': instance.surname,
      'position': instance.position,
      'jerseyNumber': instance.jerseyNumber,
    };

PlayerStatsResponseDto _$PlayerStatsResponseDtoFromJson(
  Map<String, dynamic> json,
) => PlayerStatsResponseDto(
  playerId: (json['playerId'] as num).toInt(),
  totalGoals: (json['totalGoals'] as num).toInt(),
  totalAssists: (json['totalAssists'] as num).toInt(),
  totalYellowCards: (json['totalYellowCards'] as num).toInt(),
  totalRedCards: (json['totalRedCards'] as num).toInt(),
  totalGamesPlayed: (json['totalGamesPlayed'] as num).toInt(),
  totalGamesStarted: (json['totalGamesStarted'] as num).toInt(),
);

Map<String, dynamic> _$PlayerStatsResponseDtoToJson(
  PlayerStatsResponseDto instance,
) => <String, dynamic>{
  'playerId': instance.playerId,
  'totalGoals': instance.totalGoals,
  'totalAssists': instance.totalAssists,
  'totalYellowCards': instance.totalYellowCards,
  'totalRedCards': instance.totalRedCards,
  'totalGamesPlayed': instance.totalGamesPlayed,
  'totalGamesStarted': instance.totalGamesStarted,
};
