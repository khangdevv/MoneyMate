class ExchangeRate {
    final String baseCode; // Đồng tiền gốc - Mặc định là VND
    final Map<String, double> rates; // Bảng tỷ giá quy đổi các đồng ngoại tệ
    final DateTime lastUpdatedAt;

    ExchangeRate({
      required this.baseCode,
      required this.rates,
      required this.lastUpdatedAt,
    });

    factory ExchangeRate.fromJson(Map<String, dynamic> json) {
      final rawRates = json['conversion_rates'] ?? json['rates'] ?? {};
      return ExchangeRate(
        baseCode: json['base_code'] ?? 'VND',
        rates: Map<String, dynamic>.from(rawRates).map<String, double>(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
        lastUpdatedAt: DateTime.now(),
      );
    }
  }