import 'package:dio/dio.dart';
import '../config/api.dart';

class AuthService {

  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        "Content-Type": "application/json",
      },
      responseType: ResponseType.json,
    ),
  );

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "${ApiConfig.baseUrl}/user/login",
        data: {
          "username": username,
          "password": password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data;
      }

      return {
        "status": "error",
        "message": "Tidak dapat terhubung ke server",
      };
    }
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await _dio.get(
        "${ApiConfig.baseUrl}/user/profile",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data;
      }

      return {
        "status": "error",
        "message": "Gagal ambil profile",
      };
    }
  }
}