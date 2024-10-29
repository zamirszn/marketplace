class ProductModel {
  final String? image;
  final String? title;
  final String? description;
  final num? rating;
  final num? price;
  final num? discountPrice;
  final int? inventory;

  ProductModel(
      {required this.image,
      required this.title,
      required this.description,
      required this.rating,
      required this.price,
      required this.discountPrice,
      required this.inventory});
}
