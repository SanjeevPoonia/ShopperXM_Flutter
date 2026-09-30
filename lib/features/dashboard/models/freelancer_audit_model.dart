class FreelancerAuditModel {
  final String beatPlanId;
  final String storeId;

  final String storeName;
  final String storeAddress;
  final String contactPerson;
  final String companyName;

  final String price;
  final String bonus;
  final String auditDate;
  final String auditDuration;

  final String latitude;
  final String longitude;

  final String cycleName;

  final int distance;
  final int showPrice;
  final int allowMultipleAudit;

  final List<String> documents;

  FreelancerAuditModel({
    required this.beatPlanId,
    required this.storeId,
    required this.storeName,
    required this.storeAddress,
    required this.contactPerson,
    required this.companyName,
    required this.price,
    required this.bonus,
    required this.auditDate,
    required this.auditDuration,
    required this.latitude,
    required this.longitude,
    required this.cycleName,
    required this.distance,
    required this.showPrice,
    required this.allowMultipleAudit,
    required this.documents,
  });

  factory FreelancerAuditModel.fromJson(Map<String, dynamic> json) {
    return FreelancerAuditModel(
      beatPlanId: _stringValue(json['beat_plan_id']),
      storeId: _stringValue(json['store_id']),

      storeName: _stringValue(json['store_name']),
      storeAddress: _stringValue(json['store_address']),
      contactPerson: _stringValue(json['contact_person']),
      companyName: _stringValue(json['company_name']),

      price: _stringValue(json['price']),
      bonus: _stringValue(json['bonus']),
      auditDate: _stringValue(json['audit_date']),
      auditDuration: _stringValue(json['audit_expiry']),

      latitude: _stringValue(json['latitude']),
      longitude: _stringValue(json['longitude']),

      cycleName: _stringValue(json['cam_name']),

      distance: _intValue(json['distance']),
      showPrice: _intValue(json['show_price']),
      allowMultipleAudit: _intValue(json['allow_multiple_audit']),

      documents: _documentsValue(json['des_document']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'beat_plan_id': beatPlanId,
      'store_id': storeId,

      'store_name': storeName,
      'store_address': storeAddress,
      'contact_person': contactPerson,
      'company_name': companyName,

      'price': price,
      'bonus': bonus,
      'audit_date': auditDate,
      'audit_expiry': auditDuration,

      'latitude': latitude,
      'longitude': longitude,

      'cam_name': cycleName,

      'distance': distance,
      'show_price': showPrice,
      'allow_multiple_audit': allowMultipleAudit,

      'des_document': documents,
    };
  }

  double get latitudeDouble {
    return double.tryParse(latitude) ?? 0.0;
  }

  double get longitudeDouble {
    return double.tryParse(longitude) ?? 0.0;
  }

  double get priceDouble {
    return double.tryParse(price) ?? 0.0;
  }

  double get bonusDouble {
    return double.tryParse(bonus) ?? 0.0;
  }

  String get formattedDistance {
    return '$distance Km';
  }

  static String _stringValue(dynamic value) {
    if (value == null) {
      return '';
    }

    final valueString = value.toString().trim();

    if (valueString.toLowerCase() == 'null') {
      return '';
    }

    return valueString;
  }

  static int _intValue(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  static List<String> _documentsValue(dynamic value) {
    if (value == null || value is! List) {
      return [];
    }

    return value
        .map((item) => item?.toString() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }
}