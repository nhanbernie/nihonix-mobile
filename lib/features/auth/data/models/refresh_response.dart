library;

/// Simple model for refresh token response.
class RefreshResponse {
  final String accessToken;
  final String refreshToken;

  RefreshResponse({required this.accessToken, required this.refreshToken});

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    // Support wrapped response { data: { accessToken, refreshToken } } or direct payload
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final access = data['accessToken'] ?? data['access_token'];
    final refresh = data['refreshToken'] ?? data['refresh_token'];

    if (access == null || refresh == null) {
      throw FormatException('Missing accessToken or refreshToken in response');
    }

    return RefreshResponse(
      accessToken: access as String,
      refreshToken: refresh as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}
