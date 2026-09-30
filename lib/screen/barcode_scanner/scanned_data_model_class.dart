class ScannedProduct {
  String productId;
  String weight;
  String remark;

  ScannedProduct(this.productId, this.weight, this.remark);
}

class ScannedBox {
  String storeId;
  String storeName;
  String storeCode;
  String fnsku;
  String unit;
  String weight;
  String boxNo;
  String comment;
  String trackingId;
  String shipmentId;
  List<ScannedProduct> products;

  ScannedBox(
      this.storeId,
      this.storeName,
      this.storeCode,
      this.fnsku,
      this.unit,
      this.weight,
      this.boxNo,
      this.comment,
      this.trackingId,
      this.shipmentId,
      this.products);
}