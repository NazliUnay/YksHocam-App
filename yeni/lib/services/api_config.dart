class ApiConfig {
  static const String _localIp = "192.168.1.64"; // Kendi yerel IP
  static const String _emulatorIp = "10.0.2.2";

  // Uygulamanın hangi IP'yi kullanacağını buradan seçebilirsin
  static const String baseUrl = "http://$_emulatorIp:5094/api";

  static const Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json", // Bazı API'ler bunu zorunlu tutar
  };
}