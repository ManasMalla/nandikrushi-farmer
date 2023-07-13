import 'package:equatable/equatable.dart';

class LatLng extends Equatable{
  final double latitude;
  final double longitude;
  const LatLng({required this.latitude, required this.longitude});
  
  @override
  // TODO: implement props
  List<Object?> get props => [latitude, longitude];
}

class Product extends Equatable {
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
  final Seller? seller;
  final double aggregateRating;
  final List<CustomerReview> reviews;

   Product({
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
    this.seller,
    required this.aggregateRating,
    required this.reviews
  }): assert( Uri.tryParse(image)
                          ?.host
                          .isNotEmpty ?? false );

  @override
  // TODO: implement props
  List<Object?> get props => [productId, seller, canBeSold];
}

class CustomerReview extends Equatable {
  final String user;
  final String review;
  final int rating;
  const CustomerReview(
      {required this.user, required this.rating, required this.review});

  @override
  List<Object?> get props => [user];
}

class Seller extends Equatable{
  final int sellerId;
  final String name;
  final String phoneNumber;
  final String email;
  final String location;
  final SellerCertificate certificate;
  
  const Seller({
    required this.sellerId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.location,
    required this.certificate
  });
  
  @override
  List<Object?> get props => [sellerId];
}

enum SellerCertificate{
  OTHER, 
}
