class CartModel {
  CartModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
    required this.v,
  });
  late final int id;
  late final int userId;
  late final String date;
  late final List<Products> products;
  late final int v;

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = json['date'];
    products =
        List.from(json['products']).map((e) => Products.fromJson(e)).toList();
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['date'] = date;
    _data['products'] = products.map((e) => e.toJson()).toList();
    _data['__v'] = v;
    return _data;
  }
}

class Products {
  Products({
    required this.productId,
    required this.quantity,
  });
  late final int productId;
  late final int quantity;

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['productId'] = productId;
    _data['quantity'] = quantity;
    return _data;
  }
}
