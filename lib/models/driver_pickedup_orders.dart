class DriverPickedUpOrdersResponse {
  final bool success;
  final List<Order> orders;

  DriverPickedUpOrdersResponse({
    required this.success,
    required this.orders,
  });

  factory DriverPickedUpOrdersResponse.fromJson(Map<String, dynamic> json) {
    return DriverPickedUpOrdersResponse(
      success: json['success'] ?? false,
      orders: (json['orders'] as List<dynamic>?)
          ?.map((order) => Order.fromJson(order))
          .toList() ??
          [],
    );
  }
}

class Order {
  final int id;
  final String orderId;
  final int driverId;
  final String serviceTypeId;
  final String organizationId;
  final String toName;
  final String toAddress1;
  final String? toAddress2;
  final String toArea;
  final String toCity;
  final String? toZip;
  final String toCountry;
  final String? toLatitude;
  final String? toLongitude;
  final String toPhone;
  final String fromName;
  final String fromAddress1;
  final String? fromAddress2;
  final String fromArea;
  final String fromCity;
  final String? fromZip;
  final String fromCountry;
  final String? fromLatitude;
  final String? fromLongitude;
  final String fromPhone;
  final String? multimediaUpload;
  final String? reasonUpdate;
  final String? attemptValidation;
  final String proType;
  final int packageAmt;
  final double weight;
  final int pod;
  final String payShipping;
  final String deliveryType;
  final String itemCost;
  final String description;
  final String instructions;
  final int orderStatus;
  final int isReceipt;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final double driverLat;
  final double driverLng;
  final double distance;

  Order({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.serviceTypeId,
    required this.organizationId,
    required this.toName,
    required this.toAddress1,
    this.toAddress2,
    required this.toArea,
    required this.toCity,
    this.toZip,
    required this.toCountry,
    this.toLatitude,
    this.toLongitude,
    required this.toPhone,
    required this.fromName,
    required this.fromAddress1,
    this.fromAddress2,
    required this.fromArea,
    required this.fromCity,
    this.fromZip,
    required this.fromCountry,
    this.fromLatitude,
    this.fromLongitude,
    required this.fromPhone,
    this.multimediaUpload,
    this.reasonUpdate,
    this.attemptValidation,
    required this.proType,
    required this.packageAmt,
    required this.weight,
    required this.pod,
    required this.payShipping,
    required this.deliveryType,
    required this.itemCost,
    required this.description,
    required this.instructions,
    required this.orderStatus,
    required this.isReceipt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.driverLat,
    required this.driverLng,
    required this.distance,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      driverId: json['driver_id'] ?? 0,
      serviceTypeId: json['service_type_id'] ?? '',
      organizationId: json['organization_id'] ?? '',
      toName: json['to_name'] ?? '',
      toAddress1: json['to_address_1'] ?? '',
      toAddress2: json['to_address_2'],
      toArea: json['to_area'] ?? '',
      toCity: json['to_city'] ?? '',
      toZip: json['to_zip'],
      toCountry: json['to_country'] ?? '',
      toLatitude: json['to_latitude'],
      toLongitude: json['to_longitude'],
      toPhone: json['to_phone'] ?? '',
      fromName: json['from_name'] ?? '',
      fromAddress1: json['from_address_1'] ?? '',
      fromAddress2: json['from_address_2'],
      fromArea: json['from_area'] ?? '',
      fromCity: json['from_city'] ?? '',
      fromZip: json['from_zip'],
      fromCountry: json['from_country'] ?? '',
      fromLatitude: json['from_latitude'],
      fromLongitude: json['from_longitude'],
      fromPhone: json['from_phone'] ?? '',
      multimediaUpload: json['multimedia_upload'],
      reasonUpdate: json['reason_update'],
      attemptValidation: json['attempt_validation'],
      proType: json['pro_type'] ?? '',
      packageAmt: json['package_amt'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      pod: json['pod'] ?? 0,
      payShipping: json['pay_shipping'] ?? '',
      deliveryType: json['delivery_type'] ?? '',
      itemCost: json['item_cost'] ?? '',
      description: json['description'] ?? '',
      instructions: json['instructions'] ?? '',
      orderStatus: json['order_status'] ?? 0,
      isReceipt: json['is_receipt'] ?? 0,
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      driverLat: (json['driver_lat'] ?? 0).toDouble(),
      driverLng: (json['driver_lng'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
    );
  }
}
