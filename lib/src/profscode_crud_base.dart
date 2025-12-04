import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

typedef HeadersProvider = Map<String, String> Function();
typedef TokenRefresher = Future<bool> Function();

class Crud extends GetxController {
  final HeadersProvider? headersProvider;
  final TokenRefresher? onRefreshToken;

  Crud({this.headersProvider, this.onRefreshToken});

  Future<bool>? _refreshFuture;

  Future<bool> _ensureRefreshToken() async {
    if (onRefreshToken == null) return false;

    if (_refreshFuture != null) {
      try {
        return await _refreshFuture!;
      } catch (_) {
        return false;
      }
    }

    _refreshFuture = onRefreshToken!();
    try {
      final result = await _refreshFuture!;
      return result;
    } finally {
      _refreshFuture = null;
    }
  }

  Map<String, String> _defaultHeaders() {
    return headersProvider?.call() ?? {};
  }

  dynamic jsonDecodeSafe(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  Future<dynamic> getRequest(String url, {bool retry = true}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _defaultHeaders(),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);

      if (response.statusCode == 401 && retry) {
        bool refreshed = await _ensureRefreshToken();
        if (refreshed) return await getRequest(url, retry: false);
      }

      return jsonDecodeSafe(response.body);
    } catch (e) {
      debugPrint("GET Exception: $e");
    }
    update();
    return null;
  }

  Future<dynamic> postRequest(
    String url,
    Map datas, {
    bool retry = true,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: datas,
        headers: _defaultHeaders(),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);

      if (response.statusCode == 401 && retry) {
        bool refreshed = await _ensureRefreshToken();
        if (refreshed) return await postRequest(url, datas, retry: false);
      }

      return jsonDecodeSafe(response.body);
    } catch (e) {
      debugPrint("POST Exception: $e");
    }
    update();
    return null;
  }

  Future<dynamic> putRequest(String url, Map datas, {bool retry = true}) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        body: datas,
        headers: _defaultHeaders(),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);

      if (response.statusCode == 401 && retry) {
        bool refreshed = await _ensureRefreshToken();
        if (refreshed) return await putRequest(url, datas, retry: false);
      }

      return jsonDecodeSafe(response.body);
    } catch (e) {
      debugPrint("PUT Exception: $e");
    }
    update();
    return null;
  }

  Future<dynamic> deleteRequest(String url, {bool retry = true}) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: _defaultHeaders(),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);

      if (response.statusCode == 401 && retry) {
        bool refreshed = await _ensureRefreshToken();
        if (refreshed) return await deleteRequest(url, retry: false);
      }

      return jsonDecodeSafe(response.body);
    } catch (e) {
      debugPrint("DELETE Exception: $e");
    }
    update();
    return null;
  }

  Future<dynamic> headRequest(String url, {bool retry = true}) async {
    try {
      final response = await http.head(
        Uri.parse(url),
        headers: _defaultHeaders(),
      );

      if (response.statusCode == 200) return response.headers;

      if (response.statusCode == 401 && retry) {
        bool refreshed = await _ensureRefreshToken();
        if (refreshed) return await headRequest(url, retry: false);
      }

      return response.headers;
    } catch (e) {
      debugPrint("HEAD Exception: $e");
    }
    update();
    return null;
  }

  Future<dynamic> patchRequest(
    String url,
    Map datas, {
    bool retry = true,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: datas,
        headers: _defaultHeaders(),
      );

      if (response.statusCode == 200) return jsonDecode(response.body);

      if (response.statusCode == 401 && retry) {
        bool refreshed = await _ensureRefreshToken();
        if (refreshed) return await patchRequest(url, datas, retry: false);
      }

      return jsonDecodeSafe(response.body);
    } catch (e) {
      debugPrint("PATCH Exception: $e");
    }
    update();
    return null;
  }

  Future<dynamic> optionsRequest(String url, {bool retry = true}) async {
    try {
      final response = await http.Request(
        "OPTIONS",
        Uri.parse(url),
      ).send().then((res) => http.Response.fromStream(res));

      if (response.statusCode == 200) return response.headers;

      if (response.statusCode == 401 && retry) {
        bool refreshed = await _ensureRefreshToken();
        if (refreshed) return await optionsRequest(url, retry: false);
      }

      return response.headers;
    } catch (e) {
      debugPrint("OPTIONS Exception: $e");
    }
    update();
    return null;
  }

  Future<dynamic> fileRequest(
    String url, {
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
    bool retry = true,
  }) async {
    try {
      final request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll(_defaultHeaders());
      request.fields.addAll(fields);
      request.files.addAll(files);

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        return jsonDecodeSafe(responseBody.body);
      }

      if (response.statusCode == 401 && retry) {
        bool refreshed = await _ensureRefreshToken();
        if (refreshed) {
          return await fileRequest(
            url,
            fields: fields,
            files: files,
            retry: false,
          );
        }
      }

      return jsonDecodeSafe(responseBody.body);
    } catch (e) {
      debugPrint("UPLOAD Exception: $e");
    }
    update();
    return null;
  }
}
