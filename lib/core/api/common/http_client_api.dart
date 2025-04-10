import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:projeto_game_quiz/core/api/api_constant.dart';
import 'package:projeto_game_quiz/core/api/utils/token_util.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';

class HttpClientService {
  final String baseUrl = "http://$BASE_URL";

  HttpClientService();

  Future<dynamic> request<T>(
    String endpoint, {
    String method = "GET",
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(dynamic json)? successParser,
    String? filePath,
    List<int>? bytes,
    String? fileName,
  }) async {
    final String? userToken = await TokenUtil.getToken();

    Map<String, String> defaultHeaders = {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json'
    };

    if (headers?.keys.any((key) => key.toLowerCase() == 'content-type') ??
        false) {
      defaultHeaders
          .removeWhere((key, _) => key.toLowerCase() == 'content-type');
    }

    final combinedHeaders = {
      ...defaultHeaders,
      if (headers != null) ...headers,
    };

    final url = Uri.parse("$baseUrl$endpoint");
    http.Response? response;

    try {
      if (filePath != null) {
        var request = MultipartRequest(method, url);
        request.headers.addAll(combinedHeaders);

        request.files.add(
          await MultipartFile.fromPath(
            'file',
            filePath,
            filename: basename(filePath),
          ),
        );

        if (body != null) {
          body.forEach((key, value) {
            request.fields[key] = value.toString();
          });
        }

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else if (bytes != null && fileName != null) {
        var request = MultipartRequest(method, url);
        request.headers.addAll(combinedHeaders);

        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
        ));
        if (body != null) {
          body.forEach((key, value) {
            request.fields[key] = value.toString();
          });
        }

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        if (method == "POST") {
          if (combinedHeaders.containsKey('Content-Type') &&
              combinedHeaders['Content-Type'] == 'application/json') {
            response = await http.post(url,
                headers: combinedHeaders, body: jsonEncode(body));
          } else {
            response =
                await http.post(url, headers: combinedHeaders, body: body);
          }
        } else if (method == "PUT") {
          response = await http.put(url,
              headers: combinedHeaders, body: jsonEncode(body));
        } else if (method == "PATCH") {
          response = await http.patch(url,
              headers: combinedHeaders, body: jsonEncode(body));
        } else if (method == "DELETE") {
          response = await http.delete(url,
              headers: combinedHeaders, body: jsonEncode(body));
        } else {
          response = await http.get(url, headers: combinedHeaders);
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body == "") {
          if (successParser != null) {
            return successParser({"isSuccess": true});
          } else {
            return {"isSuccess": true};
          }
        }

        final decoded = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decoded);

        if (successParser != null) {
          return successParser(jsonResponse);
        } else {
          return jsonResponse;
        }
      } else {
        final decoded = utf8.decode(response.bodyBytes);
        final errorResponse = DetailErrorResponse.fromJson(jsonDecode(decoded));
        throw errorResponse;
      }
    } catch (e) {
      rethrow;
    }
  }
}
