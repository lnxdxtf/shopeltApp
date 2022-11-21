class CartItem {
  final String id;
  final String productID;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.productID,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}
