import '../../../models/dto/player_dto.dart';
import '../../../services/api_service.dart';

class PlayersRepository {
  final ApiService _apiService;

  PlayersRepository(this._apiService);

  Future<List<PlayerResponseDto>> getPlayersByTeam(int teamId) async {
    final response = await _apiService.get('/teams/$teamId/players');
    return (response.data as List)
        .map((e) => PlayerResponseDto.fromJson(e))
        .toList();
  }

  Future<List<PlayerResponseDto>> getPlayers() async {
    final response = await _apiService.get('/players');
    return (response.data as List)
        .map((e) => PlayerResponseDto.fromJson(e))
        .toList();
  }

  Future<PlayerResponseDto> getPlayer(int id) async {
    final response = await _apiService.get('/players/$id');
    return PlayerResponseDto.fromJson(response.data);
  }

  Future<PlayerStatsResponseDto> getPlayerStats(int id) async {
    final response = await _apiService.get('/players/$id/stats');
    return PlayerStatsResponseDto.fromJson(response.data);
  }

  Future<PlayerResponseDto> createPlayer(PlayerRequestDto player) async {
    final response = await _apiService.post('/players', data: player.toJson());
    return PlayerResponseDto.fromJson(response.data);
  }

  Future<PlayerResponseDto> updatePlayer(
    int id,
    PlayerRequestDto player,
  ) async {
    final response = await _apiService.put(
      '/players/$id',
      data: player.toJson(),
    );
    return PlayerResponseDto.fromJson(response.data);
  }

  Future<void> deletePlayer(int id) async {
    await _apiService.delete('/players/$id');
  }
}
