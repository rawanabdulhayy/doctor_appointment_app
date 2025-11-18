import 'package:dio/dio.dart';
import '../../business_logic/repositaries_interfaces/dr_repo_interface.dart';
import '../models/doctor_model.dart';

class DoctorRepositoryImpl implements DoctorRepositoryInterface {
  final Dio dio;
  final String baseUrl;

  DoctorRepositoryImpl({required this.baseUrl})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

  Future<Doctor> getDoctorById(String id) async {
    try {
      final response = await dio.get(
        '/doctors/$id',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // If your API returns the doctor data directly
        if (response.data is Map<String, dynamic>) {
          return Doctor.fromJson(response.data);
        }
        // If your API returns { "data": { ...doctor data... } }
        else if (response.data is Map<String, dynamic> &&
            response.data['data'] != null) {
          return Doctor.fromJson(response.data['data']);
        }
        // If your API returns { "data": [{ ...doctor data... }] } (array)
        else if (response.data is Map<String, dynamic> &&
            response.data['data'] is List &&
            response.data['data'].isNotEmpty) {
          return Doctor.fromJson(response.data['data'][0]);
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to load doctor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load doctor: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error fetching doctor: $e');
    }
  }

  Future<List<Doctor>> getDoctors() async {
    // Implement actual API call to get doctors list
    // For now, keeping your mock data structure
    try {
      final response = await dio.get(
        '/doctors',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((e) => Doctor.fromJson(e))
              .toList();
        } else if (response.data is Map<String, dynamic> &&
            response.data['data'] is List) {
          return (response.data['data'] as List)
              .map((e) => Doctor.fromJson(e))
              .toList();
        } else {
          throw Exception('Invalid API response format for doctors list');
        }
      } else {
        throw Exception('Failed to load doctors: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load doctors: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }
}

// Alternative: If using Firebase
// Future<Doctor> getDoctorFromFirebase(String id) async {
//   final doc = await FirebaseFirestore.instance
//       .collection('doctors')
//       .doc(id)
//       .get();
//
//   if (doc.exists) {
//     return Doctor.fromMap(doc.data()!, doc.id);
//   } else {
//     throw Exception('Doctor not found');
//   }
// }
//}
