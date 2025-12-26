class CartProduct {
  final int productId;
  final int quantity;

  CartProduct({
    required this.productId,
    required this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        productId: json['productId'] as int? ?? 0,
        quantity: json['quantity'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {'productId': productId, 'quantity': quantity};
}

class UserCart {
  final int? id;
  final int? userId;
  final DateTime? date;
  final List<CartProduct> products;

  UserCart({
    this.id,
    this.userId,
    this.date,
    this.products = const [],
  });

  factory UserCart.fromJson(Map<String, dynamic> json) => UserCart(
        id: json['id'] as int?,
        userId: json['userId'] as int?,
        date: json['date'] != null
            ? DateTime.tryParse(json['date'] as String)
            : null,
        products: (json['products'] as List<dynamic>? ?? [])
            .map((e) => CartProduct.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static List<UserCart> fromList(List<dynamic> data) => data
      .map((e) => UserCart.fromJson(e as Map<String, dynamic>))
      .toList();
}

