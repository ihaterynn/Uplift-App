class PaymentMethod {
  final String id;
  final String userId;
  final String type; // 'bank_account', 'credit_card', etc.
  final String name;
  final String lastFourDigits;
  final bool isDefault;
  final String? brand; // For credit cards: 'visa', 'mastercard', etc.
  final String? expiryDate; // For credit cards
  final Map<String, dynamic>? metadata;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.lastFourDigits,
    this.isDefault = false,
    this.brand,
    this.expiryDate,
    this.metadata,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      name: json['name'],
      lastFourDigits: json['last_four_digits'],
      isDefault: json['is_default'] ?? false,
      brand: json['brand'],
      expiryDate: json['expiry_date'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'name': name,
      'last_four_digits': lastFourDigits,
      'is_default': isDefault,
      'brand': brand,
      'expiry_date': expiryDate,
      'metadata': metadata,
    };
  }
  
  // Helper to get payment method icon
  String get iconName {
    switch (type) {
      case 'credit_card':
        if (brand?.toLowerCase() == 'visa') return 'visa';
        if (brand?.toLowerCase() == 'mastercard') return 'mastercard';
        if (brand?.toLowerCase() == 'amex') return 'american_express';
        return 'credit_card';
      case 'bank_account':
        return 'account_balance';
      case 'paypal':
        return 'paypal';
      default:
        return 'payment';
    }
  }
  
  // Get formatted representation
  String get displayName {
    return '$name (••••$lastFourDigits)';
  }
  
  // Create a copy with updated fields
  PaymentMethod copyWith({
    String? id,
    String? userId,
    String? type,
    String? name,
    String? lastFourDigits,
    bool? isDefault,
    String? brand,
    String? expiryDate,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      name: name ?? this.name,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      isDefault: isDefault ?? this.isDefault,
      brand: brand ?? this.brand,
      expiryDate: expiryDate ?? this.expiryDate,
      metadata: metadata ?? this.metadata,
    );
  }
}