import '../../../models/dto/team_dto.dart';
import '../../../services/api_service.dart';

class TeamsRepository {
  final ApiService _apiService;

  TeamsRepository(this._apiService);

  Future<List<TeamResponseDto>> getTeams() async {
    final response = await _apiService.get('/teams');
    return (response.data as List)
        .map((e) => TeamResponseDto.fromJson(e))
        .toList();
  }

  Future<List<TeamResponseDto>> getTeamsByLeague(int leagueId) async {
    final response = await _apiService.get('/leagues/$leagueId/teams');
    final leagueTeams = (response.data as List)
        .map((e) => TeamResponseDto.fromJson(e))
        .toList();
    leagueTeams.sort((a, b) => b.points.compareTo(a.points));
    return leagueTeams;
  }

  Future<TeamResponseDto> getTeam(int id) async {
    final response = await _apiService.get('/teams/$id');
    return TeamResponseDto.fromJson(response.data);
  }

  Future<TeamResponseDto> createTeam(TeamRequestDto team) async {
    final response = await _apiService.post('/teams', data: team.toJson());
    return TeamResponseDto.fromJson(response.data);
  }

  Future<TeamResponseDto> updateTeam(int id, TeamRequestDto team) async {
    final response = await _apiService.put('/teams/$id', data: team.toJson());
    return TeamResponseDto.fromJson(response.data);
  }

  Future<void> deleteTeam(int id) async {
    await _apiService.delete('/teams/$id');
  }
}
