import 'package:dio/dio.dart';
import '../config/api.dart';
import 'package:intl/intl.dart';

class AuthService {

  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        "Content-Type": "application/json",
      },
      responseType: ResponseType.json,
    ),
  );

  Future<Map<String, dynamic>> searchContainer(String keyword, String token) async {
    try {
      final response = await _dio.get(
        "${ApiConfig.baseUrl}/container/search",
        queryParameters: {
          "q": keyword,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return response.data;
    } catch (e) {
      return {
        "status": "error",
        "message": "Gagal ambil data",
      };
    }
  }

  Future<List<String>> getContainerByDateIn(
      String keyword,
      String date,
      String token,
      ) async {
    try {
      final response = await _dio.get(
        "${ApiConfig.baseUrl}/container/by-date-in",
        queryParameters: {
          "q": keyword,
          "date": DateFormat('yyyy-MM-dd').format(
            DateFormat('dd/MM/yyyy').parse(date),
          ),
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.data["status"] == "success") {
        return List<String>.from(response.data["data"]);
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getContainerLocation(
      String cont,
      String token,
      ) async {
    try {
      final response = await _dio.get(
        "${ApiConfig.baseUrl}/container/container_lokasi",
        queryParameters: {
          "cont": cont,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return response.data;
    } catch (e) {
      return {
        "status": "error",
      };
    }
  }

  Future<Map<String, dynamic>> updateLocationContainer({
    required String contNumber,
    required String blockLoc,
    required String location,
    required String truckNumber,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        "${ApiConfig.baseUrl}/container/update_lokasi",
        data: {
          "cont_number": contNumber,
          "block_loc": blockLoc,
          "location": location,
          "truck_number": truckNumber,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return response.data;
    } catch (e) {
      return {
        "status": "error",
        "message": "Gagal konek server",
      };
    }
  }


}