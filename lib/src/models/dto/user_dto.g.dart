// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUserRequestDto _$AppUserRequestDtoFromJson(Map<String, dynamic> json) =>
    AppUserRequestDto(
      username: json['username'] as String,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$AppUserRequestDtoToJson(AppUserRequestDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

AppUserResponseDto _$AppUserResponseDtoFromJson(Map<String, dynamic> json) =>
    AppUserResponseDto(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
    );

Map<String, dynamic> _$AppUserResponseDtoToJson(AppUserResponseDto instance) =>
    <String, dynamic>{'id': instance.id, 'username': instance.username};

RegisterRequestDto _$RegisterRequestDtoFromJson(Map<String, dynamic> json) =>
    RegisterRequestDto(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterRequestDtoToJson(RegisterRequestDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

AuthenticationRequestDto _$AuthenticationRequestDtoFromJson(
  Map<String, dynamic> json,
) => AuthenticationRequestDto(
  username: json['username'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$AuthenticationRequestDtoToJson(
  AuthenticationRequestDto instance,
) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
};

AuthenticationResponseDto _$AuthenticationResponseDtoFromJson(
  Map<String, dynamic> json,
) => AuthenticationResponseDto(token: json['token'] as String);

Map<String, dynamic> _$AuthenticationResponseDtoToJson(
  AuthenticationResponseDto instance,
) => <String, dynamic>{'token': instance.token};
