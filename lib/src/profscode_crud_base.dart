import 'dart:convert';

import 'package:http/http.dart' as http;

/// Provides headers for each request.
///
/// The provider is called immediately before a request is sent, so updated
/// authentication tokens can be returned without recreating [Crud].
typedef HeadersProvider = Map<String, String> Function();

/// Refreshes authentication credentials after a 401 response.
///
/// Return true when the credentials were refreshed successfully. The failed
/// request is then retried once.
typedef TokenRefresher = Future<bool> Function();

/// A lightweight HTTP helper for Flutter and Dart applications.
///
/// [Crud] does not depend on GetX and does not keep global state. It supports
/// the common HTTP methods, multipart uploads, custom headers and optional
/// automatic token refresh.
///
/// By default requests use the package-level [http.Client]. A custom client
/// can be injected for testing or advanced networking scenarios.
class Crud {
  final HeadersProvider? headersProvider;
  final TokenRefresher? onRefreshToken;
  final http.Client _client;

  Future<bool>? _refreshFuture;

  Crud({
    this.headersProvider,
    this.onRefreshToken,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Closes the underlying HTTP client when it is no longer needed.
  ///
  /// If a custom client is supplied, ownership remains with the caller and
  /// this method should not be used unless the caller intends to close it.
  void close() {
    _client.close();
  }

  Map<String, String> _defaultHeaders() => headersProvider?.call() ?? {};

  bool _isJsonContentType(Map<String, String> headers) {
    final contentType = headers.entries
        .firstWhere(
          (entry) => entry.key.toLowerCase() == 'content-type',
          orElse: () => const MapEntry('', ''),
        )
        .value
        .toLowerCase();

    return contentType.contains('application/json');
  }

  Object? _encodeBody(
    Map datas,
    Map<String, String> headers,
  ) {
    if (_isJsonContentType(headers)) {
      return jsonEncode(datas);
    }

    return Map<String, String>.from(
      datas.map((key, value) => MapEntry(key.toString(), value.toString())),
    );
  }

  dynamic jsonDecodeSafe(String body) {
    if (body.trim().isEmpty) return null;

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  dynamic _decodeResponse(http.Response response) {
    if (response.statusCode == 204 || response.body.trim().isEmpty) {
      return null;
    }

    return jsonDecodeSafe(response.body);
  }

  bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode < 300;

  Future<bool> _ensureRefreshToken() async {
    if (onRefreshToken == null) return false;

    final pendingRefresh = _refreshFuture;
    if (pendingRefresh != null) {
      try {
        return await pendingRefresh;
      } catch (_) {
        return false;
      }
    }

    final refreshFuture = onRefreshToken!();
    _refreshFuture = refreshFuture;

    try {
      return await refreshFuture;
    } catch (_) {
      return false;
    } finally {
      if (identical(_refreshFuture, refreshFuture)) {
        _refreshFuture = null;
      }
    }
  }

  Future<dynamic> getRequest(String url, {bool retry = true}) async {
    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: _defaultHeaders(),
      );

      if (_isSuccess(response.statusCode)) {
        return _decodeResponse(response);
      }

      if (response.statusCode == 401 && retry) {
        final refreshed = await _ensureRefreshToken();
        if (refreshed) return getRequest(url, retry: false);
      }

      return _decodeResponse(response);
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> postRequest(
    String url,
    Map datas, {
    bool retry = true,
  }) async {
    try {
      final headers = _defaultHeaders();
      final response = await _client.post(
        Uri.parse(url),
        body: _encodeBody(datas, headers),
        headers: headers,
      );

      if (_isSuccess(response.statusCode)) {
        return _decodeResponse(response);
      }

      if (response.statusCode == 401 && retry) {
        final refreshed = await _ensureRefreshToken();
        if (refreshed) {
          return postRequest(url, datas, retry: false);
        }
      }

      return _decodeResponse(response);
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> putRequest(
    String url,
    Map datas, {
    bool retry = true,
  }) async {
    try {
      final headers = _defaultHeaders();
      final response = await _client.put(
        Uri.parse(url),
        body: _encodeBody(datas, headers),
        headers: headers,
      );

      if (_isSuccess(response.statusCode)) {
        return _decodeResponse(response);
      }

      if (response.statusCode == 401 && retry) {
        final refreshed = await _ensureRefreshToken();
        if (refreshed) {
          return putRequest(url, datas, retry: false);
        }
      }

      return _decodeResponse(response);
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> deleteRequest(
    String url, {
    bool retry = true,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse(url),
        headers: _defaultHeaders(),
      );

      if (_isSuccess(response.statusCode)) {
        return _decodeResponse(response);
      }

      if (response.statusCode == 401 && retry) {
        final refreshed = await _ensureRefreshToken();
        if (refreshed) return deleteRequest(url, retry: false);
      }

      return _decodeResponse(response);
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> headRequest(String url, {bool retry = true}) async {
    try {
      final response = await _client.head(
        Uri.parse(url),
        headers: _defaultHeaders(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.headers;
      }

      if (response.statusCode == 401 && retry) {
        final refreshed = await _ensureRefreshToken();
        if (refreshed) return headRequest(url, retry: false);
      }

      return response.headers;
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> patchRequest(
    String url,
    Map datas, {
    bool retry = true,
  }) async {
    try {
      final headers = _defaultHeaders();
      final response = await _client.patch(
        Uri.parse(url),
        body: _encodeBody(datas, headers),
        headers: headers,
      );

      if (_isSuccess(response.statusCode)) {
        return _decodeResponse(response);
      }

      if (response.statusCode == 401 && retry) {
        final refreshed = await _ensureRefreshToken();
        if (refreshed) {
          return patchRequest(url, datas, retry: false);
        }
      }

      return _decodeResponse(response);
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> optionsRequest(String url, {bool retry = true}) async {
    try {
      final request = http.Request('OPTIONS', Uri.parse(url));
      request.headers.addAll(_defaultHeaders());

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.headers;
      }

      if (response.statusCode == 401 && retry) {
        final refreshed = await _ensureRefreshToken();
        if (refreshed) return optionsRequest(url, retry: false);
      }

      return response.headers;
    } catch (_) {
      return null;
    }
  }

  /// Sends a multipart POST request.
  ///
  /// Multipart file streams are generally single-use. Automatic retry after a
  /// 401 is therefore disabled for this method unless the caller provides
  /// reusable [http.MultipartFile] instances.
  Future<dynamic> fileRequest(
    String url, {
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
    bool retry = true,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(_defaultHeaders());
      request.fields.addAll(fields);
      request.files.addAll(files);

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (_isSuccess(response.statusCode)) {
        return _decodeResponse(response);
      }

      if (response.statusCode == 401 && retry) {
        final refreshed = await _ensureRefreshToken();
        if (refreshed) {
          return fileRequest(
            url,
            fields: fields,
            files: files,
            retry: false,
          );
        }
      }

      return _decodeResponse(response);
    } catch (_) {
      return null;
    }
  }
}
