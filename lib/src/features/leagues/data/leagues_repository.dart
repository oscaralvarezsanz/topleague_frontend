import '../../../models/dto/league_dto.dart';
import '../../../services/api_service.dart';

class LeaguesRepository {
  final ApiService _apiService;

  LeaguesRepository(this._apiService);

  Future<List<LeagueResponseDto>> getLeagues() async {
    final response = await _apiService.get('/leagues');
    return (response.data as List)
        .map((e) => LeagueResponseDto.fromJson(e))
        .toList();
  }

  Future<LeagueResponseDto> getLeague(int id) async {
    final response = await _apiService.get('/leagues/$id');
    return LeagueResponseDto.fromJson(response.data);
  }

  Future<LeagueResponseDto> createLeague(LeagueRequestDto league) async {
    final response = await _apiService.post('/leagues', data: league.toJson());
    return LeagueResponseDto.fromJson(response.data);
  }

  Future<LeagueResponseDto> updateLeague(
    int id,
    LeagueRequestDto league,
  ) async {
    final response = await _apiService.put(
      '/leagues/$id',
      data: league.toJson(),
    );
    return LeagueResponseDto.fromJson(response.data);
  }

  Future<void> deleteLeague(int id) async {
    await _apiService.delete('/leagues/$id');
  }
}
