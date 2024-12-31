import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shared_pref_helper.dart';
import 'network_constant.dart';

class ApiService {

  static Future<Map<String, dynamic>> postApiWithoutToken(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('${NetworkConstantsUtil.baseUrl}$endpoint');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future<Map<String, dynamic>> postApiWithToken({
    required String endpoint,
    Map<String, dynamic> body = const {},
    // required String token,
  }
      // String? endpoint,
      // Map<String, dynamic>? body,
      // String? token,
      ) async {

    final accessToken = await SharedPrefHelper.getString("access-token");

    print("ACCESS TOKEN $accessToken");

    final url = Uri.parse('${NetworkConstantsUtil.baseUrl}$endpoint');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Include the token in the headers
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future<Map<String, dynamic>> getApiWithToken(
    String endpoint,
    String token,
  ) async {
    final url = Uri.parse('${NetworkConstantsUtil.baseUrl}$endpoint');

    print(url);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the token in the headers
      },
    );

    print(response.statusCode);
    // print(response.body);

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   return response;
    // } else {
    //   throw Exception('Failed to post data: ${response.statusCode}');
    // }

    if (response.statusCode == 200 || response.statusCode == 201) {
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }

  static Future<http.Response> getApiWithoutToken(
    String endpoint,
  ) async {
    final url = Uri.parse('${NetworkConstantsUtil.baseUrl}$endpoint');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }
}
