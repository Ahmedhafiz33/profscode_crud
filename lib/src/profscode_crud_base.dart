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
}
