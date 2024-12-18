// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
//
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import '../util/logger_service.dart';
// import '../util/shared_prefs.dart';
// import 'network_constant.dart';
//
// export 'network_constant.dart';
//
// class ApiResponse {
//   bool? success;
//   dynamic data;
//   String? message;
//
//   ApiResponse();
//
//   factory ApiResponse.fromJson(dynamic json) {
//     ApiResponse model = ApiResponse();
//     model.success = json['status'] == 200;
//     model.data = json['data'];
//     model.message = json['message'];
//
//     if (json['status'] == 401) {
//       // go to login
//       // if (isAnyPageInStack) {
//       //   Get.offAll(() => const LoginScreen());
//       // }
//     }
//     if (model.success != true &&
//         model.data != null &&
//         model.message?.isEmpty == true) {
//       var errors = model.data['errors'];
//       if (errors != null) {
//         var messages = model.data['errors']['message'];
//         if (messages != null) {
//           model.message = (messages as List).first;
//         } else {
//           if (model.data['errors'] is Map) {
//             List errors = (model.data['errors'] as Map).values.first;
//             model.message = errors.first;
//           }
//         }
//       }
//     }
//
//     return model;
//   }
// }
//
// class ApiWrapper {
//   final JsonDecoder _decoder = const JsonDecoder();
//
//   Future<ApiResponse?> getApiWithoutToken({required String url}) async {
//     String urlString = '${NetworkConstantsUtil.baseUrl}$url';
//
//     final connectivityResult = await (Connectivity().checkConnectivity());
//
//     if (connectivityResult != ConnectivityResult.none) {
//       return http
//           .get(Uri.parse(urlString))
//           .then((http.Response response) async {
//         dynamic data = _decoder.convert(response.body);
//         EasyLoading.dismiss();
//
//         SharedPrefs().setApiResponse(url: urlString, response: response.body);
//         return ApiResponse.fromJson(data);
//       });
//     } else {
//       EasyLoading.dismiss();
//       String? cachedResponse =
//       await SharedPrefs().getCachedApiResponse(url: urlString);
//
//       if (cachedResponse != null) {
//         dynamic data = _decoder.convert(cachedResponse);
//         return ApiResponse.fromJson(data);
//       }
//     }
//     return null;
//   }
//
//   Future<ApiResponse?> getApi({required String url}) async {
//     String? authKey = await SharedPrefs().getAuthorizationKey();
//     String urlString = '${NetworkConstantsUtil.baseUrl}$url';
//
//     final connectivityResult = await (Connectivity().checkConnectivity());
//
//     if (connectivityResult != ConnectivityResult.none) {
//
//
//
//       return http.get(Uri.parse(urlString), headers: {
//         "Authorization": "Bearer ${authKey!}"
//       }).then((http.Response response) async {
//         // print(response.body);
//         dynamic data = _decoder.convert(response.body);
//         LoggerService.logInfo('URL $url Response getApi: ${response.body}');
//
//         EasyLoading.dismiss();
//         SharedPrefs().setApiResponse(url: urlString, response: response.body);
//
//         return ApiResponse.fromJson(data);
//       });
//     } else {
//       EasyLoading.dismiss();
//       String? cachedResponse =
//       await SharedPrefs().getCachedApiResponse(url: urlString);
//
//       if (cachedResponse != null) {
//         dynamic data = _decoder.convert(cachedResponse);
//         return ApiResponse.fromJson(data);
//       }
//     }
//     return null;
//   }
//
//   Future<ApiResponse?> postApi(
//       {required String url, required dynamic param}) async {
//     String? authKey = await SharedPrefs().getAuthorizationKey();
//
//     String urlString = '${NetworkConstantsUtil.baseUrl}$url';
//     final connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       return null;
//     }
//
//
//
//     return http.post(Uri.parse(urlString), body: jsonEncode(param), headers: {
//       "Authorization": "Bearer ${authKey!}",
//       'Content-Type': 'application/json'
//     }).then((http.Response response) async {
//       LoggerService.logInfo('URL $url Response postApi: ${response.body}');
//       dynamic data = _decoder.convert(response.body);
//       return ApiResponse.fromJson(data);
//     });
//   }
//
//   Future<ApiResponse?> putApi(
//       {required String url, required dynamic param}) async {
//     String? authKey = await SharedPrefs().getAuthorizationKey();
//     //EasyLoading.show(status: loadingString.tr);
//     EasyLoading.show(status: "loading");
//
//     return http.put(Uri.parse('${NetworkConstantsUtil.baseUrl}$url'),
//         body: jsonEncode(param),
//         headers: {
//           "Authorization": "Bearer ${authKey!}",
//           'Content-Type': 'application/json'
//         }).then((http.Response response) async {
//       dynamic data = _decoder.convert(response.body);
//       // print(data);
//       EasyLoading.dismiss();
//
//       return ApiResponse.fromJson(data);
//     });
//   }
//
//   Future<ApiResponse?> deleteApi({required String url}) async {
//     String? authKey = await SharedPrefs().getAuthorizationKey();
//     EasyLoading.show(status: "loading");
//     // EasyLoading.show(status: loadingString.tr);
//
//     // print('${NetworkConstantsUtil.baseUrl}$url');
//     return http.delete(Uri.parse('${NetworkConstantsUtil.baseUrl}$url'),
//         headers: {
//           "Authorization": "Bearer $authKey",
//           'Content-Type': 'application/json'
//         }).then((http.Response response) async {
//       dynamic data = _decoder.convert(response.body);
//       // print(data);
//       EasyLoading.dismiss();
//
//       return ApiResponse.fromJson(data);
//     });
//   }
//
//   Future postApiWithoutToken(
//       {required String url, required dynamic param}) async {
//     // EasyLoading.show(status: loadingString.tr);
//
//     return http
//         .post(Uri.parse('${NetworkConstantsUtil.baseUrl}$url'), body: param)
//         .then((http.Response response) async {
//       dynamic data = _decoder.convert(response.body);
//       return data;
//     });
//   }
//
//   Future<ApiResponse?> multipartImageUpload(
//       {required String url, required Uint8List imageFileData}) async {
//     // EasyLoading.show(status: loadingString.tr);
//     EasyLoading.show(status: "loading");
//     String? authKey = await SharedPrefs().getAuthorizationKey();
//     var postUri = Uri.parse('${NetworkConstantsUtil.baseUrl}$url');
//     var request = http.MultipartRequest("POST", postUri);
//     request.headers.addAll({"Authorization": "Bearer ${authKey!}"});
//
//     request.files.add(http.MultipartFile.fromBytes('imageFile', imageFileData,
//         filename: '${DateTime.now().toIso8601String()}.jpg',
//         contentType: MediaType('image', 'jpg')));
//
//     return request.send().then((response) async {
//       final respStr = await response.stream.bytesToString();
//       EasyLoading.dismiss();
//
//       dynamic data = _decoder.convert(respStr);
//
//       return ApiResponse.fromJson(data);
//     });
//   }
//
//   // Future<ApiResponse?> uploadFile(
//   //     {required String file,
//   //       required UploadMediaType type,
//   //       required GalleryMediaType mediaType,
//   //       required String url}) async {
//   //   EasyLoading.show(status: loadingString.tr);
//   //
//   //   var request = http.MultipartRequest(
//   //       'POST', Uri.parse('${NetworkConstantsUtil.baseUrl}$url'));
//   //   String? authKey = await SharedPrefs().getAuthorizationKey();
//   //   request.headers.addAll({"Authorization": "Bearer ${authKey!}"});
//   //   request.fields.addAll({'type': uploadMediaTypeId(type).toString()});
//   //   if (mediaType == GalleryMediaType.video) {
//   //     request.files.add(await http.MultipartFile.fromPath('mediaFile', file,
//   //         contentType: MediaType('video', 'mp4')));
//   //   } else if (mediaType == GalleryMediaType.audio) {
//   //     request.files.add(await http.MultipartFile.fromPath('mediaFile', file,
//   //         contentType: MediaType('audio', 'mp3')));
//   //   } else {
//   //     request.files.add(await http.MultipartFile.fromPath('mediaFile', file));
//   //   }
//   //   var res = await request.send();
//   //   var responseData = await res.stream.toBytes();
//   //   var responseString = String.fromCharCodes(responseData);
//   //   LoggerService.logInfo('Response uploadFile: $responseString');
//   //
//   //   dynamic data = _decoder.convert(responseString);
//   //   EasyLoading.dismiss();
//   //   return ApiResponse.fromJson(data);
//   // }
//
//   // Future<ApiResponse?> uploadPostFile(
//   //     {required String file,
//   //       required GalleryMediaType mediaType,
//   //       required String url}) async {
//   //   EasyLoading.show(status: loadingString.tr);
//   //
//   //   var request = http.MultipartRequest(
//   //       'POST', Uri.parse('${NetworkConstantsUtil.baseUrl}$url'));
//   //   String? authKey = await SharedPrefs().getAuthorizationKey();
//   //   request.headers.addAll({"Authorization": "Bearer ${authKey!}"});
//   //
//   //   String fieldName =
//   //       'filenameFile'; // Adjust this according to server requirements
//   //   String filename = 'upload_${DateTime.now().millisecondsSinceEpoch}';
//   //
//   //   if (mediaType == GalleryMediaType.video) {
//   //     filename += '.mp4';
//   //     request.files.add(await http.MultipartFile.fromPath(fieldName, file,
//   //         filename: filename, contentType: MediaType('video', 'mp4')));
//   //   } else if (mediaType == GalleryMediaType.audio) {
//   //     filename += '.mp3';
//   //     request.files.add(await http.MultipartFile.fromPath(fieldName, file,
//   //         filename: filename, contentType: MediaType('audio', 'mp3')));
//   //   } else {
//   //     filename += '.png';
//   //     request.files.add(await http.MultipartFile.fromPath(fieldName, file,
//   //         filename: filename, contentType: MediaType('image', 'png')));
//   //   }
//   //   request.fields['filename'] = filename;
//   //
//   //   try {
//   //     var res = await request.send();
//   //     var responseData = await res.stream.toBytes();
//   //     var responseString = String.fromCharCodes(responseData);
//   //
//   //     LoggerService.logInfo('URL: $url Response uploadPostFile: $responseString');
//   //
//   //     dynamic data = _decoder.convert(responseString);
//   //     return ApiResponse.fromJson(data);
//   //   } catch (e) {
//   //     LoggerService.logError('Error uploadPostFile: $e');
//   //     return null;
//   //   } finally {
//   //     EasyLoading.dismiss();
//   //   }
//   // }
//
// //////////////////////////////////////////////////////
//
// // Future<ApiResponse?> uploadPostFile({
// //   required String file,
// //   required GalleryMediaType mediaType,
// //   required String url,
// // }) async {
// //   EasyLoading.show(status: loadingString.tr);
// //
// //   var request = http.MultipartRequest(
// //     'POST',
// //     Uri.parse('${NetworkConstantsUtil.baseUrl}$url'),
// //   );
// //
// //   String? authKey = await SharedPrefs().getAuthorizationKey();
// //   request.headers.addAll({"Authorization": "Bearer ${authKey!}"});
// //
// //   // Define the correct field name for file upload based on server expectation
// //   String fieldName = 'filenameFile'; // Adjust this according to server requirements
// //
// //   // Define the filename explicitly and add it as a part parameter
// //   String filename = 'upload_${DateTime.now().millisecondsSinceEpoch}';
// //
// //   // Adjust filename extension based on the media type
// //   if (mediaType == GalleryMediaType.video) {
// //     filename += '.mp4';
// //     request.files.add(await http.MultipartFile.fromPath(
// //       fieldName,
// //       file,
// //       filename: filename,
// //       contentType: MediaType('video', 'mp4'),
// //     ));
// //   } else if (mediaType == GalleryMediaType.audio) {
// //     filename += '.mp3';
// //     request.files.add(await http.MultipartFile.fromPath(
// //       fieldName,
// //       file,
// //       filename: filename,
// //       contentType: MediaType('audio', 'mp3'),
// //     ));
// //   } else {
// //     filename += '.png'; // Use appropriate extension based on image type
// //     request.files.add(await http.MultipartFile.fromPath(
// //       fieldName,
// //       file,
// //       filename: filename,
// //       contentType: MediaType('image', 'png'),
// //     ));
// //   }
// //
// //   // Add the filename as a form field explicitly if required by the server
// //   request.fields['filename'] = filename; // Explicitly set the filename parameter
// //
// //   try {
// //     var res = await request.send();
// //     var responseData = await res.stream.toBytes();
// //     var responseString = String.fromCharCodes(responseData);
// //
// //     Logger().i('Response: $responseString');
// //
// //
// //     dynamic data = _decoder.convert(responseString);
// //     return ApiResponse.fromJson(data);
// //   } catch (e) {
// //     Logger().e('Error sending request: $e');
// //     return null;
// //   } finally {
// //     EasyLoading.dismiss();
// //   }
// // }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'network_constant.dart';

class ApiService {
  // Future<http.Response> postApiWithoutToken(
  //     String endpoint,
  //     Map<String, dynamic> body,
  //     ) async {
  //   final url = Uri.parse('${NetworkConstantsUtil.baseUrl}$endpoint');
  //
  //
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(body),
  //     );
  //
  //
  //     debugPrint('av    ${response.body}');
  //
  //     final Map<String, dynamic> responseData = jsonDecode(response.body);
  //     bool isSuccess = responseData['success'];
  //     String message = responseData['message'];
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return response;
  //     } else {
  //       return response;
  //     }
  //   }


  Future<Map<String, dynamic>> postApiWithoutToken(
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


  Future<Map<String, dynamic>> postApiWithToken(
      String endpoint,
      Map<String, dynamic> body,
      String token,
      ) async {
    final url = Uri.parse('${NetworkConstantsUtil.baseUrl}$endpoint');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the token in the headers
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }


  Future<http.Response> getApiWithoutToken(
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



