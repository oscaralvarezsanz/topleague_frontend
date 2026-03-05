import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class AppUserRequestDto {
  final String username;
  final String? password;

  AppUserRequestDto({required this.username, this.password});

  Map<String, dynamic> toJson() => _$AppUserRequestDtoToJson(this);
}

@JsonSerializable()
class AppUserResponseDto {
  final int id;
  final String username;

  AppUserResponseDto({required this.id, required this.username});

  factory AppUserResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AppUserResponseDtoFromJson(json);
}

@JsonSerializable()
class RegisterRequestDto {
  final String username;
  final String password;

  RegisterRequestDto({required this.username, required this.password});

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}

@JsonSerializable()
class AuthenticationRequestDto {
  final String username;
  final String password;

  AuthenticationRequestDto({required this.username, required this.password});

  Map<String, dynamic> toJson() => _$AuthenticationRequestDtoToJson(this);
}

@JsonSerializable()
class AuthenticationResponseDto {
  final String token;

  AuthenticationResponseDto({required this.token});

  factory AuthenticationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseDtoFromJson(json);
}
