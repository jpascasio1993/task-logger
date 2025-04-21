// allow to use environment variables
// ignore_for_file: do_not_use_environment

class EnvironmentConfig {
  bool get httpsEnabled => const bool.fromEnvironment('HTTPS_ENABLED');

  String get baseUrl {
    return '${httpsEnabled ? 'https' : 'http'}://${const String.fromEnvironment('BASE_URL')}';
  }

  @override
  String toString() {
    return 'EnvironmentConfig(baseUrl: $baseUrl, httpsEnabled: $httpsEnabled)';
  }
}
