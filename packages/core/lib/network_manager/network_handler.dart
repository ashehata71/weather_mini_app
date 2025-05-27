import 'dart:convert';
import 'package:core/network_manager/network_exception.dart';
import 'package:dio/dio.dart';

enum HttpMethod { get, post, put, delete, patch }

abstract class INetworkHandler {
  Future<dynamic> request(
    String path, {
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters, Map<String, String>? headers});

  void dispose();
}

class NetworkHandler implements INetworkHandler {
  final String baseUrl;
  late final Dio _client;

  NetworkHandler({required this.baseUrl, Dio? dioClient}) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    _client = dioClient ?? Dio(options);
  }

  @override
  Future<dynamic> request(
    String path, {
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final requestOptions = Options(
      method: method.name.toUpperCase(),
      headers: headers,
    );

    try {
      print('Request: ${requestOptions.method} ${_client.options.baseUrl}$path');
      if (queryParameters != null) {
        print('Query Params: $queryParameters');
      }
      if (body != null) {
        print('Body: ${jsonEncode(body)}');
      }
      if (headers != null) {
        print('Custom Headers: $headers');
      }
      final response = await _client.request(
        path,
        data: body,
        queryParameters: queryParameters,
        options: requestOptions,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      if (e.response != null) {
        print('DioException Status Code: ${e.response?.statusCode}');
        print('DioException Response Data: ${e.response?.data}');
      } else {
        print('DioException Error: ${e.error}');
      }

      if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        dynamic errorData = e.response?.data;
        String errorMessage = 'API Error';

        if (errorData is Map && errorData.containsKey('message')) {
          errorMessage = errorData['message'].toString();
        } else if (errorData is String && errorData.isNotEmpty) {
          errorMessage = errorData;
        } else if (e.message != null && e.message!.isNotEmpty) {
          errorMessage = e.message!;
        }

        throw NetworkException(
          message: 'Error: $errorMessage',
          statusCode: statusCode,
          error: errorData ?? e.error ?? e,
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(
            message: 'Request Timed Out: ${e.message}',
            error: e.error ?? e,
            statusCode: e.response?.statusCode);
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          message: 'Connection Error: Please check your internet connection. (${e.message})',
          error: e.error ?? e,
        );
      } else if (e.type == DioExceptionType.cancel) {
        throw NetworkException(
          message: 'Request Cancelled: ${e.message}',
          error: e.error ?? e,
        );
      } else {
        throw NetworkException(
            message: 'Network Error: ${e.message ?? "An unexpected error occurred"}',
            error: e.error ?? e,
            statusCode: e.response?.statusCode);
      }
    } catch (e) {
      print('Unhandled Exception in NetworkHandler: ${e.runtimeType} - ${e.toString()}');
      throw NetworkException(message: 'An Unexpected Error Occurred: ${e.toString()}', error: e);
    }
  }

  @override
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters, Map<String, String>? headers}) async {
    return request(path, method: HttpMethod.get, queryParameters: queryParameters, headers: headers);
  }

  @override
  void dispose() {
    _client.close();
    print('Dio client closed.');
  }
}
