enum TransactionType {
  deposit,
  withdrawal,
  paymentReceived,
  paymentSent,
  refund,
  fee
}

class Transaction {
  final String id;
  final String walletId;
  final double amount;
  final TransactionType type;
  final DateTime timestamp;
  final String description;
  final String status; // 'completed', 'pending', 'failed'
  final String? paymentMethodId;
  final String? counterpartyId; // For peer-to-peer transactions
  final String? counterpartyName;
  final String? jobId; // If related to a job
  final String currency;

  Transaction({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    required this.timestamp,
    required this.description,
    required this.status,
    this.paymentMethodId,
    this.counterpartyId,
    this.counterpartyName,
    this.jobId,
    this.currency = 'USD',
  });

  // Create from JSON data (received from API)
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      walletId: json['wallet_id'],
      amount: (json['amount'] as num).toDouble(),
      type: _parseTransactionType(json['type']),
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
      status: json['status'],
      paymentMethodId: json['payment_method_id'],
      counterpartyId: json['counterparty_id'],
      counterpartyName: json['counterparty_name'],
      jobId: json['job_id'],
      currency: json['currency'] ?? 'USD',
    );
  }

  // Helper to parse transaction type from string
  static TransactionType _parseTransactionType(String typeStr) {
    try {
      return TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.$typeStr' || 
               e.toString().split('.').last == typeStr,
        orElse: () => TransactionType.deposit,
      );
    } catch (e) {
      return TransactionType.deposit; // Default
    }
  }

  // Convert to JSON (to send to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'amount': amount,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'status': status,
      'payment_method_id': paymentMethodId,
      'counterparty_id': counterpartyId,
      'counterparty_name': counterpartyName,
      'job_id': jobId,
      'currency': currency,
    };
  }

  // Helpful getters
  bool get isIncoming {
    return type == TransactionType.deposit ||
           type == TransactionType.paymentReceived ||
           type == TransactionType.refund;
  }

  bool get isOutgoing {
    return type == TransactionType.withdrawal ||
           type == TransactionType.paymentSent ||
           type == TransactionType.fee;
  }

  String get formattedAmount {
    String prefix = isIncoming ? '+' : '-';
    if (currency == 'USD') {
      return "$prefix\$${amount.toStringAsFixed(2)}";
    } else {
      return "$prefix${amount.toStringAsFixed(2)} $currency";
    }
  }

  String get timeAgo {
    final difference = DateTime.now().difference(timestamp);
   
    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()}y ago";
    } else if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()}mo ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }

  String get typeDisplayName {
    switch (type) {
      case TransactionType.deposit:
        return "Deposit";
      case TransactionType.withdrawal:
        return "Withdrawal";
      case TransactionType.paymentReceived:
        return "Payment Received";
      case TransactionType.paymentSent:
        return "Payment Sent";
      case TransactionType.refund:
        return "Refund";
      case TransactionType.fee:
        return "Fee";
    }
  }

  // Get transaction icon based on type
  String get iconName {
    switch (type) {
      case TransactionType.deposit:
        return 'arrow_downward';
      case TransactionType.withdrawal:
        return 'arrow_upward';
      case TransactionType.paymentReceived:
        return 'payments';
      case TransactionType.paymentSent:
        return 'send';
      case TransactionType.refund:
        return 'replay';
      case TransactionType.fee:
        return 'attach_money';
    }
  }
  
  // Get transaction color based on type
  String get color {
    if (isIncoming) {
      return 'green';
    } else {
      return 'red';
    }
  }
}