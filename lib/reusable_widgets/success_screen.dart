import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_host.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/add_product.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class SuccessScreen extends StatefulWidget {
  final Map<String, String> body;
  final bool isSuccess;
  const SuccessScreen({Key? key, required this.body, required this.isSuccess})
      : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    // int providingIndex = 0;

    return Scaffold(
      body: Stack(children: [
        Positioned(
          bottom: 0,
          top: 0,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: 0.2,
            child: Image.network(
              "https://www.bigbasket.com/media/uploads/p/l/10000053_18-fresho-brinjal-bottle-shape.jpg",
              fit: BoxFit.fitHeight,
              height: 650,
              alignment: Alignment.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 140,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  height: 9,
                ),
                TextWidget(
                  widget.isSuccess ? "SUCCESS" : "Failure",
                  size: 48,
                  weight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextWidget(
                    "${widget.isSuccess ? 'Added' : 'Failed adding'} your product:\n${widget.body["name"]}",
                    size: 20,
                    weight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                    align: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 140,
                ),
                ElevatedButtonWidget(
                  onClick: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddProductScreen()),
                        (route) => false);
                  },

                  height: 56,
                  borderRadius: 12,
                  bgColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  buttonName: widget.isSuccess
                      ? "Sell Another Product".toUpperCase()
                      : "Try Again".toUpperCase(),
                  innerPadding: 0.02,
                  // textStyle: FontWeight.bold,
                  leadingIcon: Icons.arrow_back_rounded,
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButtonWidget(
                  onClick: () async {
                    var navigator = Navigator.of(context);

                    ProductProvider productProvider =
                        Provider.of<ProductProvider>(context, listen: false);

                    ProfileProvider profileProvider =
                        Provider.of<ProfileProvider>(context, listen: false);
                    productProvider.getAllProducts(
                        showMessage: (_) {
                          snackbar(context, _);
                        },
                        profileProvider: profileProvider);
                    navigator.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => NandikrushiNavHost(
                                  userId: profileProvider.userIdForAddress,
                                  shouldUpdateField: false,
                                )),
                        (route) => false);
                  },
                  height: 56,
                  borderRadius: 12,
                  bgColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  buttonName: "Home".toUpperCase(),
                  innerPadding: 0.02,
                  // textStyle: FontWeight.bold,
                  trailingIcon: Icons.home,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
