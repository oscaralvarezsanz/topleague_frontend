import '../../../models/dto/user_dto.dart';
import '../../../services/api_service.dart';

class UsersRepository {
  final ApiService _apiService;

  UsersRepository(this._apiService);

  Future<AppUserResponseDto> getUser(int id) async {
    final response = await _apiService.get('/users/$id');
    return AppUserResponseDto.fromJson(response.data);
  }

  Future<AppUserResponseDto> createUser(AppUserRequestDto user) async {
    final response = await _apiService.post('/users', data: user.toJson());
    return AppUserResponseDto.fromJson(response.data);
  }

  Future<AppUserResponseDto> updateUser(int id, AppUserRequestDto user) async {
    final response = await _apiService.put('/users/$id', data: user.toJson());
    return AppUserResponseDto.fromJson(response.data);
  }

  Future<void> deleteUser(int id) async {
    await _apiService.delete('/users/$id');
  }
}
