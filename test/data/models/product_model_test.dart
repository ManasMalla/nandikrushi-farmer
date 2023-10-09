// import 'dart:convert';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:nandikrushi_farmer/data/models/product_model.dart';
// import 'package:nandikrushi_farmer/domain/entity/product.dart';

// void main(){
//   final dummyJson = '{"Products":[{"category":[{"category_id":"64","category_name":"A2 MILK","category_image":"","sub_category_id":"0","sub_category_name":null,"category_description":"&lt;p&gt;A2 MILKS&lt;br&gt;&lt;\/p&gt;"}],"Products":[{"product_id":"328","seller_type":"2","verify_seller":"1","product_name":"desi cow milk","description":"desi cow milk","quantity":"0","actual_price":"100.0000","image":"https:\/\/firebasestorage.googleapis.com\/v0\/b\/nandikrushi-35ddb.appspot.com\/o\/product_images%2F2023-04-06%2020%3A40%3A51.304197.png?alt=media&amp;token=101723a2-44f3-4f34-932a-8b1582f2e821","final_price":"100.0000","available_quantity":"0","title":"LITER","units":"lt","min_purchase":1,"order_accepting_timings":{"start":"10:00AM","stop":"10:00PM"},"in_stock":"1"}],"vendor_details":[{"type":"2","name":"narasingha rao","mobile":"7893875490","email":"","certificates":"Self Declared Natural Farmer","location":{"longitude":"17.6091912","latitude":"83.1157216","city":"Visakhapatnam","mandal":"paravada","district":"paravada"},"payment_acceptance_type":"COD\/Pay online"}]}]}';
//   final tProductModel = ProductModel(productId: 328, name: 'desi cow milk', description: 'desi cow milk', image: "https:\/\/firebasestorage.googleapis.com\/v0\/b\/nandikrushi-35ddb.appspot.com\/o\/product_images%2F2023-04-06%2020%3A40%3A51.304197.png?alt=media&amp;token=101723a2-44f3-4f34-932a-8b1582f2e821", price: 100.00, quantity: 0, units: "1 lt", canBeSold: true, category: "A2 Milk", categoryId: 64, produceLocation: "paravada, paravada", seller: Seller(sellerId: 1, name: 'narasingha rao', phoneNumber: '7893875490', email: "", location: "paravada, paravada", certificate: SellerCertificate.OTHER), aggregateRating: 3.5, reviews: []);
//   group('from json', () { 
//     test('return a valid product model from json', (){
//        final response = json.decode(dummyJson)["Products"][0];
//       final result = ProductModel.fromJson(response, {"A2 Milk": 64});
//       expect(result, equals(tProductModel));
//     });
//   });
// }