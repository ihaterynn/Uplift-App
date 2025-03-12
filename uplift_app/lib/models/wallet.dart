class Wallet {
  final String id;
  final String userId;
  final double balance;
  final List<String> paymentMethodIds;
  final DateTime lastUpdated;
  final String currency;
  final bool isVerified;
  final String status; // "active", "suspended", "pending"

  Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.paymentMethodIds,
    required this.lastUpdated,
    this.currency = 'USD',
    this.isVerified = false,
    this.status = 'active',
  });

  // Create from JSON data (received from API)
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      userId: json['user_id'],
      balance: (json['balance'] as num).toDouble(),
      paymentMethodIds: json['payment_method_ids'] != null 
          ? List<String>.from(json['payment_method_ids']) 
          : [],
      lastUpdated: DateTime.parse(json['last_updated']),
      currency: json['currency'] ?? 'USD',
      isVerified: json['is_verified'] ?? false,
      status: json['status'] ?? 'active',
    );
  }

  // Convert to JSON (to send to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'payment_method_ids': paymentMethodIds,
      'last_updated': lastUpdated.toIso8601String(),
      'currency': currency,
      'is_verified': isVerified,
      'status': status,
    };
  }

  // Format balance for display
  String get formattedBalance {
    if (currency == 'USD') {
      return '\$${balance.toStringAsFixed(2)}';
    } else {
      return '${balance.toStringAsFixed(2)} $currency';
    }
  }

  // Create a copy of this wallet with updated fields
  Wallet copyWith({
    String? id,
    String? userId,
    double? balance,
    List<String>? paymentMethodIds,
    DateTime? lastUpdated,
    String? currency,
    bool? isVerified,
    String? status,
  }) {
    return Wallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      paymentMethodIds: paymentMethodIds ?? this.paymentMethodIds,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      currency: currency ?? this.currency,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
    );
  }
}