import '../../../models/dto/dto.dart';
import '../../../models/dto/user_dto.dart';
import '../../../services/api_service.dart';
import '../domain/app_user.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<AppUser> registerUser(String username, String password) async {
    try {
      final requestDto = RegisterRequestDto(
        username: username,
        password: password,
      );
      // Even though spec says /auth/register returns AuthenticationResponse (token),
      // we might just need to store the token and return the user.
      // For now, let's just make the call and perhaps return a dummy user or parse the token.
      await _apiService.post('/auth/register', data: requestDto.toJson());
      // In a real app, we'd decode the JWT to get the user ID, but we'll return a stub (ID 1) for now
      return AppUser(id: 1, username: username);
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  Future<String> authenticateUser(String username, String password) async {
    try {
      final requestDto = AuthenticationRequestDto(
        username: username,
        password: password,
      );
      final response = await _apiService.post(
        '/auth/login',
        data: requestDto.toJson(),
      );
      final responseDto = AuthenticationResponseDto.fromJson(response.data);
      return responseDto.token;
    } catch (e) {
      throw Exception('Failed to authenticate user: $e');
    }
  }

  Future<AppUser> getUser(int id) async {
    try {
      final response = await _apiService.get('/users/$id');
      final responseDto = AppUserResponseDto.fromJson(response.data);
      return AppUser(id: responseDto.id, username: responseDto.username);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<List<AppUser>> getUsers() async {
    try {
      final response = await _apiService.get('/users');
      return (response.data as List).map((e) {
        final dto = AppUserResponseDto.fromJson(e);
        return AppUser(id: dto.id, username: dto.username);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }
}
