import '../../../models/dto/game_dto.dart';
import '../../../services/api_service.dart';

class GamesRepository {
  final ApiService _apiService;

  GamesRepository(this._apiService);

  Future<List<GameResponseDto>> getGames() async {
    final response = await _apiService.get('/games');
    return (response.data as List)
        .map((e) => GameResponseDto.fromJson(e))
        .toList();
  }

  Future<List<GameResponseDto>> getGamesByLeague(
    int leagueId, {
    int? matchday,
    String? date,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (matchday != null) queryParams['matchday'] = matchday;
    if (date != null) queryParams['date'] = date;

    final response = await _apiService.get(
      '/leagues/$leagueId/games',
      queryParameters: queryParams,
    );
    return (response.data as List)
        .map((e) => GameResponseDto.fromJson(e))
        .toList();
  }

  Future<GameResponseDto> getGame(int id) async {
    final response = await _apiService.get('/games/$id');
    return GameResponseDto.fromJson(response.data);
  }

  Future<GameResponseDto> createGame(GameRequestDto game) async {
    final response = await _apiService.post('/games', data: game.toJson());
    return GameResponseDto.fromJson(response.data);
  }

  Future<GameResponseDto> updateGame(int id, GameRequestDto game) async {
    final response = await _apiService.put('/games/$id', data: game.toJson());
    return GameResponseDto.fromJson(response.data);
  }

  Future<void> deleteGame(int id) async {
    await _apiService.delete('/games/$id');
  }
}
