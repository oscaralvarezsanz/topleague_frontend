// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeagueRequestDto _$LeagueRequestDtoFromJson(Map<String, dynamic> json) =>
    LeagueRequestDto(name: json['name'] as String);

Map<String, dynamic> _$LeagueRequestDtoToJson(LeagueRequestDto instance) =>
    <String, dynamic>{'name': instance.name};

LeagueResponseDto _$LeagueResponseDtoFromJson(Map<String, dynamic> json) =>
    LeagueResponseDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      adminId: (json['adminId'] as num).toInt(),
    );

Map<String, dynamic> _$LeagueResponseDtoToJson(LeagueResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'adminId': instance.adminId,
    };
