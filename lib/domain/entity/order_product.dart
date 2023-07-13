
import 'package:equatable/equatable.dart';
import 'package:nandikrushi_farmer/domain/entity/product.dart';

class ProductOrder extends Equatable{
  final int orderId;
  final List<Product> products;
  const ProductOrder({required this.orderId, required this.products});
  
  @override
  // TODO: implement props
  List<Object?> get props => [orderId];
}
