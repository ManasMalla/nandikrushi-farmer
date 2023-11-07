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
  final String subcategory;
  final int subCategoryId;
  final String produceLocation;
  final LatLng? produceCoordinates;
  final Seller seller;
  final double aggregateRating;
  final List<CustomerReview> reviews;
  final bool disabled;

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
    required this.subcategory,
    required this.subCategoryId,
    required this.produceLocation,
    this.produceCoordinates,
    required this.seller,
    required this.aggregateRating,
    required this.reviews,
    required this.disabled,
  }) : assert(Uri.tryParse(image)?.host.isNotEmpty ?? false);

  @override
  List<Object?> get props => [productId, seller, canBeSold];

  factory ProductModel.fromJson(Map<String, dynamic> json, bool isDisabled) =>
      ProductModel(
        productId: int.tryParse(json["Product"]["product_id"]) ?? 0,
        name: json["Product"]["product_name"].toString(),
        description: json["Product"]["description"].toString(),
        image: json["Product"]["image"].toString(),
        price: (((double.tryParse(json["Product"]["final_price"].toString()) ??
                        0.0) *
                    100)
                .roundToDouble() /
            100),
        quantity: int.tryParse(json["Product"]["quantity"]) ?? 0,
        units: '${json["Product"]["min_purchase"]} ${json["Product"]["units"]}',
        canBeSold: json["Product"]["verify_seller"] == "1",
        categoryId: int.tryParse(json["category"][0]["category_id"]) ?? 0,
        category: json["category"][0]["category_name"],
        subCategoryId:
            int.tryParse(json["category"][0]["sub_category_id"]) ?? 0,
        subcategory: json["category"][0]["sub_category_name"] ?? "",
        produceLocation:
            "${json["vendor_details"][0]["location"]["mandal"]}, ${json["vendor_details"][0]["location"]["district"]}",
        seller: Seller(
            sellerId: 1,
            name: json["vendor_details"][0]["name"] ?? "Farmer",
            phoneNumber: json["vendor_details"][0]["mobile"] ?? "8341980196",
            email: json["vendor_details"][0]["email"] ?? "info@spotmies.com",
            location:
                "${json["vendor_details"][0]["location"]["mandal"]}, ${json["vendor_details"][0]["location"]["district"]}",
            certificate: SellerCertificate.fromString(
                json["vendor_details"][0]["certificates"])),
        aggregateRating:
            (((double.tryParse(json["Product"]["aggregateRating"].toString()) ??
                            0) *
                        2)
                    .round() /
                2),
        reviews: [],
        produceCoordinates: !json["vendor_details"][0]["location"]["longitude"]
                    .toString()
                    .contains("0.0") &&
                !json["vendor_details"][0]["location"]["latitude"]
                    .toString()
                    .contains("0.0") &&
                json["vendor_details"][0]["location"]["longitude"] != null &&
                json["vendor_details"][0]["location"]["latitude"] != null
            ? LatLng(
                latitude: double.parse(
                    json["vendor_details"][0]["location"]["latitude"]),
                longitude: double.parse(
                    json["vendor_details"][0]["location"]["longitude"]))
            : null,
        disabled: isDisabled,
      );

  Product toEntity() => Product(
        productId: productId,
        name: name,
        description: description,
        image: image,
        price: price,
        quantity: quantity,
        units: units,
        canBeSold: canBeSold,
        category: category,
        categoryId: categoryId,
        subcategory: subcategory,
        subCategoryId: subCategoryId,
        produceLocation: produceLocation,
        seller: seller,
        aggregateRating: aggregateRating,
        reviews: reviews,
        disabled: disabled,
      );
}
