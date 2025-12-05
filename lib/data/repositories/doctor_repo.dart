import 'package:dio/dio.dart';

import '../../business_logic/repositaries_interfaces/dr_repo_interface.dart';
import '../../core/exceptions.dart';
import '../models/doctor_model.dart';

class DoctorRepositoryImpl implements DoctorRepositoryInterface {
  final Dio dio;
  final String baseUrl;
  String? _authToken;

  DoctorRepositoryImpl({required this.baseUrl, String? authToken})
      : _authToken = authToken,
        dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            validateStatus: (status) => true,
          ),
        ) {
    // Add interceptors for logging
    dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      error: true,
    ));
  }

  // Method to update the auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Method to clear the auth token
  void clearAuthToken() {
    _authToken = null;
  }

  // Helper method to get headers with auth token
  Map<String, dynamic> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  @override
  Future<Doctor> getDoctorById(String id) async {
    try {
      print('Fetching doctor with ID: $id from $baseUrl/doctor/show/$id');
      print('Using auth token: ${_authToken != null ? "Yes" : "No"}');

      final response = await dio.get(
        '/doctor/show/$id',
        options: Options(headers: _getHeaders()),
      );

      print('Doctor response status: ${response.statusCode}');
      print('Doctor response data: ${response.data}');

      // Check if response is HTML (server error page)
      if (_isHtmlResponse(response)) {
        throw ServerException(
          message: 'Server error: Internal server error (500)',
          statusCode: 500,
        );
      }

      // Handling successful response
      if (response.statusCode == 200) {
        final returnedResponseData = response.data;

        // Simplified parsing logic
        if (returnedResponseData is Map<String, dynamic>) {
          // Handle direct doctor object
          if (returnedResponseData.containsKey('id')) {
            return Doctor.fromJson(returnedResponseData);
          }
          // Handle wrapped response: { "data": { ... } }
          else if (returnedResponseData['data'] is Map<String, dynamic>) {
            return Doctor.fromJson(returnedResponseData['data']);
          }
          // Handle wrapped response: { "data": [{ ... }] }
          else if (returnedResponseData['data'] is List &&
              returnedResponseData['data'].isNotEmpty) {
            return Doctor.fromJson(returnedResponseData['data'][0]);
          }
        }

        throw ServerException(message: 'Unexpected API response format for doctor');
      }
      // Handling not found errors (404)
      else if (response.statusCode == 404) {
        final message = _extractErrorMessage(response) ?? 'Doctor not found';
        throw ServerException(message: message, statusCode: response.statusCode);
      }
      // Handling unauthorized errors (401)
      else if (response.statusCode == 401) {
        final message = _extractErrorMessage(response) ?? 'Unauthorized access - Please login again';
        throw ServerException(message: message, statusCode: response.statusCode);
      }
      // Handling validation errors (422)
      else if (response.statusCode == 422) {
        final errors = response.data['data'] ?? response.data['errors'] ?? {};
        String errorMessage = 'Failed to load doctor: ';

        if (errors is Map) {
          errors.forEach((field, messages) {
            if (messages is List) {
              errorMessage += '${messages.join(', ')}. ';
            } else if (messages is String) {
              errorMessage += '$messages. ';
            }
          });
        } else if (errors is String) {
          errorMessage += errors;
        }

        throw ServerException(
            message: errorMessage.trim(),
            statusCode: response.statusCode
        );
      }
      // Handling server errors (500)
      else if (response.statusCode == 500) {
        final message = _extractErrorMessage(response) ?? 'Internal server error';
        throw ServerException(
          message: 'Server error: $message',
          statusCode: response.statusCode,
        );
      }
      // Handling other errors
      else {
        final message = _extractErrorMessage(response) ?? 'Failed to load doctor';
        throw ServerException(
          message: '$message (Status: ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      if (e.response != null) {
        throw ServerException(
          message: 'Failed to load doctor: ${e.response?.statusCode} - ${e.response?.statusMessage}',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ConnectionException(message: 'Network error: ${e.message}');
      }
    } catch (e) {
      throw ServerException(message: 'Error fetching doctor: $e');
    }
  }

  @override
  Future<List<Doctor>> getDoctors() async {
    try {
      print('Fetching doctors from $baseUrl/doctor/index');
      print('Using auth token: ${_authToken != null ? "Yes" : "No"}');

      final response = await dio.get(
        '/doctor/index',
        options: Options(headers: _getHeaders()),
      );

      print('Doctors response status: ${response.statusCode}');
      print('Doctors response data: ${response.data}');

      // Check if response is HTML (server error page)
      if (_isHtmlResponse(response)) {
        throw ServerException(
          message: 'Server error: Internal server error (500)',
          statusCode: 500,
        );
      }

      // Handling successful response
      if (response.statusCode == 200) {
        final returnedResponseData = response.data;
        List<dynamic> doctorsList = [];

        if (returnedResponseData is List) {
          doctorsList = returnedResponseData;
        } else if (returnedResponseData is Map<String, dynamic> &&
            returnedResponseData['data'] is List) {
          doctorsList = returnedResponseData['data'];
        } else {
          throw ServerException(message: 'Unexpected API response format for doctors list');
        }

        return doctorsList.map((doctorJson) {
          if (doctorJson is Map<String, dynamic>) {
            return Doctor.fromJson(doctorJson);
          } else {
            throw ServerException(message: 'Invalid doctor item format: $doctorJson');
          }
        }).toList();
      }
      // Handling unauthorized errors (401)
      else if (response.statusCode == 401) {
        final message = _extractErrorMessage(response) ?? 'Unauthorized access - Please login again';
        throw ServerException(message: message, statusCode: response.statusCode);
      }
      // Handling server errors (500)
      else if (response.statusCode == 500) {
        final message = _extractErrorMessage(response) ?? 'Internal server error';
        throw ServerException(
          message: 'Server error: $message',
          statusCode: response.statusCode,
        );
      }
      // Handling other errors
      else {
        final message = _extractErrorMessage(response) ?? 'Failed to load doctors';
        throw ServerException(
          message: '$message (Status: ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      if (e.response != null) {
        throw ServerException(
          message: 'Failed to load doctors: ${e.response?.statusCode} - ${e.response?.statusMessage}',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ConnectionException(message: 'Network error: ${e.message}');
      }
    } catch (e) {
      throw ServerException(message: 'Error fetching doctors: $e');
    }
  }
  @override
  Future<List<Doctor>> getFilteredDoctors({
    String searchQuery = '',
    int? specializationId,
    int? cityId,
  }) async {
    try {
      // Determine which endpoint to use based on parameters
      String endpoint;
      Map<String, dynamic> queryParameters = {};
      Map<String, dynamic>? requestData;

      if (searchQuery.isNotEmpty) {
        // Use search endpoint
        endpoint = '/doctor/doctor-search';
        queryParameters['name'] = searchQuery;
        print('Searching doctors by name: $searchQuery');
      } else if (specializationId != null || cityId != null) {
        // Use filter endpoint
        endpoint = '/doctor/doctor-filter';
        if (specializationId != null) {
          queryParameters['specialization'] = specializationId;
          print('Filtering by specialization: $specializationId');
        }
        if (cityId != null) {
          queryParameters['city'] = cityId;
          print('Filtering by city: $cityId');
        }
      } else {
        // No filters, return all doctors
        return await getDoctors();
      }

      print('Calling endpoint: $endpoint');
      print('Query parameters: $queryParameters');

      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders()),
      );

      print('Filtered doctors response status: ${response.statusCode}');
      print('Filtered doctors response data: ${response.data}');

      // Check if response is HTML (server error page)
      if (_isHtmlResponse(response)) {
        throw ServerException(
          message: 'Server error: Internal server error (500)',
          statusCode: 500,
        );
      }

      // Handling successful response
      if (response.statusCode == 200) {
        final returnedResponseData = response.data;
        List<dynamic> doctorsList = [];

        if (returnedResponseData is List) {
          doctorsList = returnedResponseData;
        } else if (returnedResponseData is Map<String, dynamic> &&
            returnedResponseData['data'] is List) {
          doctorsList = returnedResponseData['data'];
        } else {
          throw ServerException(
              message: 'Unexpected API response format for filtered doctors');
        }

        return doctorsList.map((doctorJson) {
          if (doctorJson is Map<String, dynamic>) {
            return Doctor.fromJson(doctorJson);
          } else {
            throw ServerException(
                message: 'Invalid doctor item format: $doctorJson');
          }
        }).toList();
      }
      // Handling unauthorized errors (401)
      else if (response.statusCode == 401) {
        final message = _extractErrorMessage(response) ??
            'Unauthorized access - Please login again';
        throw ServerException(
            message: message, statusCode: response.statusCode);
      }
      // Handling server errors (500)
      else if (response.statusCode == 500) {
        final message =
            _extractErrorMessage(response) ?? 'Internal server error';
        throw ServerException(
          message: 'Server error: $message',
          statusCode: response.statusCode,
        );
      }
      // Handling other errors
      else {
        final message = _extractErrorMessage(response) ?? 'Failed to load filtered doctors';
        throw ServerException(
          message: '$message (Status: ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('DioError in getFilteredDoctors: ${e.message}');
      print('DioError type: ${e.type}');
      print('DioError response: ${e.response?.data}');

      if (e.response != null) {
        throw ServerException(
          message:
          'Failed to load filtered doctors: ${e.response?.statusCode} - ${e.response?.statusMessage}',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ConnectionException(message: 'Network error: ${e.message}');
      }
    } catch (e) {
      print('Error in getFilteredDoctors: $e');
      throw ServerException(message: 'Error fetching filtered doctors: $e');
    }
  }

  @override
  Future<List<Specialization>> getSpecializations() async {
    try {
      print('Fetching specializations from $baseUrl/specialization/index');

      final response = await dio.get(
        '/specialization/index',
        options: Options(headers: _getHeaders()),
      );

      print('Specializations response status: ${response.statusCode}');

      // Check if response is HTML (server error page)
      if (_isHtmlResponse(response)) {
        throw ServerException(
          message: 'Server error: Internal server error (500)',
          statusCode: 500,
        );
      }

      if (response.statusCode == 200) {
        final returnedResponseData = response.data;
        List<dynamic> specializationsList = [];

        if (returnedResponseData is List) {
          specializationsList = returnedResponseData;
        } else if (returnedResponseData is Map<String, dynamic> &&
            returnedResponseData['data'] is List) {
          specializationsList = returnedResponseData['data'];
        } else {
          throw ServerException(
              message: 'Unexpected API response format for specializations');
        }

        return specializationsList.map((specJson) {
          if (specJson is Map<String, dynamic>) {
            return Specialization.fromJson(specJson);
          } else {
            throw ServerException(
                message: 'Invalid specialization item format: $specJson');
          }
        }).toList();
      } else if (response.statusCode == 401) {
        final message = _extractErrorMessage(response) ??
            'Unauthorized access - Please login again';
        throw ServerException(
            message: message, statusCode: response.statusCode);
      } else if (response.statusCode == 500) {
        final message =
            _extractErrorMessage(response) ?? 'Internal server error';
        throw ServerException(
          message: 'Server error: $message',
          statusCode: response.statusCode,
        );
      } else {
        final message = _extractErrorMessage(response) ?? 'Failed to load specializations';
        throw ServerException(
          message: '$message (Status: ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('DioError in getSpecializations: ${e.message}');
      if (e.response != null) {
        throw ServerException(
          message:
          'Failed to load specializations: ${e.response?.statusCode} - ${e.response?.statusMessage}',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ConnectionException(message: 'Network error: ${e.message}');
      }
    } catch (e) {
      print('Error in getSpecializations: $e');
      throw ServerException(message: 'Error fetching specializations: $e');
    }
  }

  @override
  Future<List<City>> getCities() async {
    try {
      print('Fetching cities from $baseUrl/city/index');

      final response = await dio.get(
        '/city/index',
        options: Options(headers: _getHeaders()),
      );

      print('Cities response status: ${response.statusCode}');

      // Check if response is HTML (server error page)
      if (_isHtmlResponse(response)) {
        throw ServerException(
          message: 'Server error: Internal server error (500)',
          statusCode: 500,
        );
      }

      if (response.statusCode == 200) {
        final returnedResponseData = response.data;
        List<dynamic> citiesList = [];

        if (returnedResponseData is List) {
          citiesList = returnedResponseData;
        } else if (returnedResponseData is Map<String, dynamic> &&
            returnedResponseData['data'] is List) {
          citiesList = returnedResponseData['data'];
        } else {
          throw ServerException(
              message: 'Unexpected API response format for cities');
        }

        return citiesList.map((cityJson) {
          if (cityJson is Map<String, dynamic>) {
            return City.fromJson(cityJson);
          } else {
            throw ServerException(
                message: 'Invalid city item format: $cityJson');
          }
        }).toList();
      } else if (response.statusCode == 401) {
        final message = _extractErrorMessage(response) ??
            'Unauthorized access - Please login again';
        throw ServerException(
            message: message, statusCode: response.statusCode);
      } else if (response.statusCode == 500) {
        final message =
            _extractErrorMessage(response) ?? 'Internal server error';
        throw ServerException(
          message: 'Server error: $message',
          statusCode: response.statusCode,
        );
      } else {
        final message = _extractErrorMessage(response) ?? 'Failed to load cities';
        throw ServerException(
          message: '$message (Status: ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('DioError in getCities: ${e.message}');
      if (e.response != null) {
        throw ServerException(
          message:
          'Failed to load cities: ${e.response?.statusCode} - ${e.response?.statusMessage}',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ConnectionException(message: 'Network error: ${e.message}');
      }
    } catch (e) {
      print('Error in getCities: $e');
      throw ServerException(message: 'Error fetching cities: $e');
    }
  }
  // Helper method to check if response is HTML
  bool _isHtmlResponse(Response response) {
    final contentType = response.headers.value('content-type');
    return contentType?.contains('text/html') == true ||
        (response.data is String && (response.data as String).contains('<!DOCTYPE html>'));
  }

  // Helper method to extract error message from response
  String? _extractErrorMessage(Response response) {
    if (response.data is Map) {
      return response.data['message'] ??
          response.data['error'] ??
          response.data['detail'];
    } else if (response.data is String) {
      return response.data;
    }
    return null;
  }
}