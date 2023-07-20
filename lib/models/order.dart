class Order {
  String? orderId;
  String? orderBill;
  String? orderPaid;
  String? buyerId;
  String? sellerId;
  String? orderDate;
  String? orderStatus;

  Order(
      {this.orderId,
      this.orderBill,
      this.orderPaid,
      this.buyerId,
      this.sellerId,
      this.orderDate,
      this.orderStatus});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderBill = json['order_bill'];
    orderPaid = json['order_paid'];
    buyerId = json['user_id'];
    sellerId = json['uploader_id'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_bill'] = orderBill;
    data['order_paid'] = orderPaid;
    data['user_id'] = buyerId;
    data['uploader_id'] = sellerId;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;
    return data;
  }
}
