import 'package:equatable/equatable.dart';

import '../../domain/entity/product.dart';

class ProductModel extends Equatable {
  final int productId;
  final String name;
  final String description;
  final String image;
  final double price;
  final int quantity;
  final String units;
  final bool canBeSold;
  final String category;
  final int categoryId;
  final String produceLocation;
  final LatLng? produceCoordinates;
  final Seller seller;
  final double aggregateRating;
  final List<CustomerReview> reviews;

   ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.quantity,
    required this.units,
    required this.canBeSold,
    required this.category,
    required this.categoryId,
    required this.produceLocation,
    this.produceCoordinates,
    required this.seller,
    required this.aggregateRating,
    required this.reviews
  }): assert( Uri.tryParse(image)
                          ?.host
                          .isNotEmpty ?? false );

  @override
  List<Object?> get props => [productId, seller, canBeSold];

  factory ProductModel.fromJson(Map<String, dynamic> json, Map<String, int> allCategories)=> ProductModel(
                productId: int.tryParse(json["Products"][0]["product_id"]) ?? 0,
                name: json["Products"][0]["product_name"].toString(),
                description: json["Products"][0]["description"].toString(),
                image: json["Products"][0]["image"].toString(),
                price: (((double.tryParse(json["Products"][0]["final_price"]
                                      .toString()) ??
                                  0.0) *
                              100)
                          .roundToDouble() /
                      100),
                quantity: int.tryParse(json["Products"][0]["quantity"]) ?? 0,
                units: '${json["Products"][0]["min_purchase"]} ${json["Products"][0]["units"]}',
                canBeSold: json["Products"][0]["verify_seller"] == "1",
                categoryId: int.tryParse(json["category"][0]["category_id"]) ?? 0,
                category: allCategories.entries
                  .where((element) =>
                      element.value ==
                      int.tryParse(json["category"][0]["category_id"] ?? "-1"))
                  .first
                  .key,
                produceLocation: "${json["vendor_details"][0]["location"]["mandal"]}, ${json["vendor_details"][0]["location"]["district"]}",
                seller: Seller(sellerId: 1, name: json["vendor_details"][0]["name"] ?? "Farmer", phoneNumber: json["vendor_details"][0]["mobile"] ?? "8341980196", email: json["vendor_details"][0]["email"] ?? "info@spotmies.com", location: "${json["vendor_details"][0]["location"]["mandal"]}, ${json["vendor_details"][0]["location"]["district"]}", certificate: SellerCertificate.OTHER),
                aggregateRating: (((double.tryParse(json["Products"][0]["aggregateRating"]
                                      .toString()) ??
                                  0) *
                              2)
                          .round() /
                      2),
                reviews: [], produceCoordinates: !json["vendor_details"][0]["location"]["longitude"]
                    .toString()
                    .contains("0.0") &&
                !json["vendor_details"][0]["location"]["latitude"]
                    .toString()
                    .contains("0.0") &&
                json["vendor_details"][0]["location"]["longitude"] != null &&
                json["vendor_details"][0]["location"]["latitude"] != null ? LatLng(latitude: double.parse(json["vendor_details"][0]["location"]["latitude"]), longitude: double.parse(json["vendor_details"][0]["location"]["longitude"]))
              : null);

              Product toEntity() => Product(productId: productId, name: name, description: description, image: image, price: price, quantity: quantity, units: units, canBeSold: canBeSold, category: category, categoryId: categoryId, produceLocation: produceLocation, seller: seller, aggregateRating: aggregateRating, reviews: reviews);
}