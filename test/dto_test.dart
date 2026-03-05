import 'package:flutter_test/flutter_test.dart';
import 'package:football_frontend/src/models/dto/league_dto.dart';
import 'package:football_frontend/src/models/dto/team_dto.dart';

void main() {
  group('DTO Serialization Tests', () {
    test('LeagueResponseDto fromJson', () {
      final json = {'id': 1, 'name': 'Premier League', 'adminId': 100};
      final dto = LeagueResponseDto.fromJson(json);
      expect(dto.id, 1);
      expect(dto.name, 'Premier League');
      expect(dto.adminId, 100);
    });

    test('LeagueRequestDto toJson', () {
      final dto = LeagueRequestDto(name: 'La Liga');
      final json = dto.toJson();
      expect(json['name'], 'La Liga');
    });

    test('TeamResponseDto fromJson', () {
      final json = {'id': 10, 'leagueId': 1, 'name': 'Arsenal'};
      final dto = TeamResponseDto.fromJson(json);
      expect(dto.id, 10);
      expect(dto.leagueId, 1);
      expect(dto.name, 'Arsenal');
    });
  });
}
