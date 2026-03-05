import '../../../models/dto/participation_dto.dart';
import '../../../services/api_service.dart';

class ParticipationsRepository {
  final ApiService _apiService;

  ParticipationsRepository(this._apiService);

  Future<List<ParticipationResponseDto>> getParticipationsByGame(
    int gameId,
  ) async {
    try {
      final response = await _apiService.get('/games/$gameId/participations');
      return (response.data as List)
          .map((e) => ParticipationResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      // Return empty list if endpoint fails (fallback until fully supported)
      return [];
    }
  }

  Future<ParticipationResponseDto> getParticipation(int id) async {
    final response = await _apiService.get('/participations/$id');
    return ParticipationResponseDto.fromJson(response.data);
  }

  Future<ParticipationResponseDto> createParticipation(
    ParticipationRequestDto participation,
  ) async {
    final response = await _apiService.post(
      '/participations',
      data: participation.toJson(),
    );
    return ParticipationResponseDto.fromJson(response.data);
  }

  Future<ParticipationResponseDto> updateParticipation(
    int id,
    ParticipationRequestDto participation,
  ) async {
    final response = await _apiService.put(
      '/participations/$id',
      data: participation.toJson(),
    );
    return ParticipationResponseDto.fromJson(response.data);
  }

  Future<void> deleteParticipation(int id) async {
    await _apiService.delete('/participations/$id');
  }
}
