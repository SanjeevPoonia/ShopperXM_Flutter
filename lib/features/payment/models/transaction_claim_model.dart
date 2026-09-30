class TransactionClaimModel {
  final String client;
  final String beatplanstoreId;
  final String campaign;
  final String touchpoint;
  final String storeCode;
  final String storeName;
  final String auditApprovedOn;
  final String claimType;
  final String amountPaidOn;
  final String status;

  final double transPrice;

  const TransactionClaimModel({
    required this.client,
    required this.beatplanstoreId,
    required this.campaign,
    required this.touchpoint,
    required this.storeCode,
    required this.storeName,
    required this.auditApprovedOn,
    required this.claimType,
    required this.amountPaidOn,
    required this.status,
    required this.transPrice,
  });

  factory TransactionClaimModel.fromJson(Map<String, dynamic> json) {
    return TransactionClaimModel(
      client: _stringValue(json['client']),
      beatplanstoreId: _stringValue(json['beatplanstore_id']),
      campaign: _stringValue(json['campaign']),
      touchpoint: _stringValue(json['touchpoint']),
      storeCode: _stringValue(json['store_code']),
      storeName: _stringValue(json['store_name']),
      auditApprovedOn: _stringValue(json['audit_approved_on']),
      claimType: _stringValue(json['claim_type']),
      amountPaidOn: _stringValue(json['amount_paid_on']),
      status: _stringValue(json['status']),
      transPrice: _doubleValue(json['trans_price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client': client,
      'beatplanstore_id': beatplanstoreId,
      'campaign': campaign,
      'touchpoint': touchpoint,
      'store_code': storeCode,
      'store_name': storeName,
      'audit_approved_on': auditApprovedOn,
      'claim_type': claimType,
      'amount_paid_on': amountPaidOn,
      'status': status,
      'trans_price': transPrice,
    };
  }

  bool get isPaid => status.toLowerCase() == 'paid';

  static String _stringValue(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString();
  }

  static double _doubleValue(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0.0;
  }
}