import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nandikrushi_farmer/nav_items/basket.dart';
import 'package:nandikrushi_farmer/product/product_card.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TabController _controller;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    ProductProvider productProvider = Provider.of(context, listen: false);

    searchController = TextEditingController();
    _controller = TabController(
        length: productProvider.categorizedProducts.entries
            .where((element) => searchController.text.isNotEmpty
                ? element.value
                    .where((element1) =>
                        element1.name
                            ?.toLowerCase()
                            .contains(searchController.text.toLowerCase()) ??
                        true)
                    .isNotEmpty
                : element.value.isNotEmpty)
            .toList()
            .length,
        vsync: this,
        initialIndex: productProvider.categorizedProducts.entries
                    .where((element) => searchController.text.isNotEmpty
                        ? element.value
                            .where((element1) =>
                                element1.name?.toLowerCase().contains(
                                    searchController.text.toLowerCase()) ??
                                true)
                            .isNotEmpty
                        : element.value.isNotEmpty)
                    .toList()
                    .length >
                1
            ? 1
            : 0);
  }

  Color? getTabBarTextColor(int i) {
    return _controller.index == i
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;
  }

  FontWeight getTabBarTextFontWeight(int i) {
    return _controller.index == i ? FontWeight.w800 : FontWeight.w600;
  }

  @override
  Widget build(BuildContext context) {
    _controller.addListener(
      () {
        setState(() {});
      },
    );
    return Consumer<ProductProvider>(builder: (context, productProvider, _) {
      return SafeArea(
        top: false,
        bottom: false,
        child: Material(
          child: Scaffold(
            floatingActionButton: Stack(
              children: [
                FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BasketScreen()));
                  },
                  child: const Icon(Icons.shopping_basket_outlined),
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      backgroundColor: productProvider.cart.length != 0
                          ? Colors.red
                          : Colors.transparent,
                      radius: 4,
                    ))
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 280,
                    child: MapsContainer(
                      productProvider: productProvider,
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    height: 2,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 72,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextFieldWidget(
                        onChanged: (_) {
                          setState(() {});
                        },
                        onSubmitField: () {
                          setState(() {});
                        },
                        textInputAction: TextInputAction.search,
                        controller: searchController,
                        label: "Search",
                        style: Theme.of(context).textTheme.titleMedium,
                        suffix: Container(
                          margin: const EdgeInsets.all(12),
                          child: ClipOval(
                              child: Container(
                                  color: Theme.of(context).colorScheme.primary,
                                  padding: const EdgeInsets.all(0),
                                  child: const Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                  ))),
                        ),
                      ),
                    ),
                  ),
                ])),
                SliverAppBar(
                  leading: const SizedBox(),
                  toolbarHeight: 5,
                  flexibleSpace: Center(
                    child: TabBar(
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      controller: _controller,
                      isScrollable: true,
                      tabs: List.generate(
                        _controller.length,
                        (index) => Tab(
                          child: TextWidget(
                            productProvider.categorizedProducts.entries
                                        .where((element) =>
                                            searchController.text.isNotEmpty
                                                ? element.value
                                                    .where((element1) =>
                                                        element1.name
                                                            .toLowerCase()
                                                            .contains(searchController.text
                                                                .toLowerCase()) ??
                                                        true)
                                                    .isNotEmpty
                                                : element.value.isNotEmpty)
                                        .toList()
                                        .length >
                                    index
                                ? productProvider.categorizedProducts.entries
                                    .where((element) => searchController.text.isNotEmpty
                                        ? element.value
                                            .where((element1) =>
                                                element1.name
                                                    .toLowerCase()
                                                    .contains(searchController.text.toLowerCase()) ??
                                                true)
                                            .isNotEmpty
                                        : element.value.isNotEmpty)
                                    .toList()[index]
                                    .key
                                    .toUpperCase()
                                : "",
                            weight: getTabBarTextFontWeight(0),
                            color: getTabBarTextColor(0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  floating: false,
                  pinned: true,
                ),
                SliverFillRemaining(
                  child: Row(
                    children: [
                      Container(
                        height: double.infinity,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        alignment: Alignment.center,
                        width: 24,
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: TextWidget(
                            _controller.index >=
                                    productProvider.categorizedProducts.entries
                                        .where((element) => searchController.text.isNotEmpty
                                            ? element.value
                                                .where((element1) =>
                                                    element1.name
                                                        ?.toLowerCase()
                                                        .contains(searchController.text
                                                            .toLowerCase()) ??
                                                    true)
                                                .isNotEmpty
                                            : element.value.isNotEmpty)
                                        .toList()
                                        .length
                                ? "Search Results"
                                : productProvider.categorizedProducts.entries
                                    .where((element) => searchController.text.isNotEmpty
                                        ? element.value
                                            .where((element1) =>
                                                element1.name
                                                    ?.toLowerCase()
                                                    .contains(searchController.text.toLowerCase()) ??
                                                true)
                                            .isNotEmpty
                                        : element.value.isNotEmpty)
                                    .toList()[_controller.index]
                                    .key
                                    .toUpperCase(),
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _controller,
                              children: List.generate(
                                  productProvider.categorizedProducts.entries
                                      .where((element) => searchController
                                              .text.isNotEmpty
                                          ? element.value
                                              .where((element1) =>
                                                  element1.name
                                                      ?.toLowerCase()
                                                      .contains(searchController
                                                          .text
                                                          .toLowerCase()) ??
                                                  true)
                                              .isNotEmpty
                                          : element.value.isNotEmpty)
                                      .toList()
                                      .length,
                                  (tabIndex) => ListView.builder(
                                        itemBuilder: (context, index) {
                                          var product = productProvider
                                              .categorizedProducts[productProvider
                                                  .categorizedProducts.entries
                                                  .where((element) => searchController
                                                          .text.isNotEmpty
                                                      ? element.value
                                                          .where((element1) =>
                                                              element1.name
                                                                  ?.toLowerCase()
                                                                  .contains(
                                                                      searchController
                                                                          .text
                                                                          .toLowerCase()) ??
                                                              true)
                                                          .isNotEmpty
                                                      : element.value.isNotEmpty)
                                                  .toList()[tabIndex]
                                                  .key]
                                              ?.where((element) => element.name?.toLowerCase().contains(searchController.text.toLowerCase()) ?? true)
                                              .toList()[index];
                                          log("283");
                                          log(product.toString());
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Opacity(
                                                opacity: product?.quantity == 0
                                                    ? 0.2
                                                    : 1.0,
                                                child: ProductCard(
                                                    disabled: !(product?.disabled ??
                                                        false),
                                                    sellerMail:
                                                        product?.seller.email,
                                                    sellerMobile: product
                                                        ?.seller.phoneNumber,
                                                    type: CardType.product,
                                                    verify: product?.canBeSold ??
                                                        false,
                                                    productId: product
                                                            ?.productId
                                                            .toString() ??
                                                        "XYZ",
                                                    productName:
                                                        product?.name ?? "Name",
                                                    productDescription:
                                                        product?.description ??
                                                            "Description",
                                                    imageURL: product?.image ??
                                                        "https://img.etimg.com/thumb/msid-64411656,width-640,resizemode-4,imgsize-226493/cow-milk.jpg",
                                                    price:
                                                        double.tryParse(product?.price.toString() ?? "00.00") ??
                                                            00.00,
                                                    units: product?.units ??
                                                        "1 unit",
                                                    location: product
                                                            ?.produceLocation ??
                                                        "Visakhapatnam"),
                                              ),
                                              Positioned(
                                                  // bottom: 50,
                                                  // right: 60,
                                                  child: product?.quantity == 0
                                                      ? Text(
                                                          "This product is temporarily unavailable",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error
                                                                        .withOpacity(Theme.of(context).brightness ==
                                                                                Brightness.dark
                                                                            ? 0.1
                                                                            : 0.9),
                                                                  ),
                                                        )
                                                      : const SizedBox())
                                            ],
                                          );
                                        },
                                        itemCount: productProvider
                                            .categorizedProducts[productProvider
                                                .categorizedProducts.entries
                                                .where((element) => searchController
                                                        .text.isNotEmpty
                                                    ? element.value
                                                        .where((element1) =>
                                                            element1.name?.toLowerCase().contains(searchController.text.toLowerCase()) ??
                                                            true)
                                                        .isNotEmpty
                                                    : element.value.isNotEmpty)
                                                .toList()[tabIndex]
                                                .key]
                                            ?.where((element) =>
                                                element.name
                                                    ?.toLowerCase()
                                                    .contains(searchController.text.toLowerCase()) ??
                                                true)
                                            .length,
                                        primary: false,
                                        shrinkWrap: true,
                                      )),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class MapsContainer extends StatefulWidget {
  final ProductProvider productProvider;
  const MapsContainer({Key? key, required this.productProvider})
      : super(key: key);

  @override
  State<MapsContainer> createState() => _MapsContainerState();
}

class _MapsContainerState extends State<MapsContainer>
    with WidgetsBindingObserver {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(17.7410573, 83.3093624);

  late String _darkMapStyle;
  Future _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/map_styles/dark_theme.json');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
  }

  Future _setMapStyle() async {
    final controller = mapController;
    final theme = WidgetsBinding.instance.window.platformBrightness;

    if (theme == Brightness.dark) {
      controller.setMapStyle(_darkMapStyle);
    } else {
      controller.setMapStyle(null);
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {
      _setMapStyle();
    });
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _setMapStyle();
    });
    sellerPins = widget.productProvider.products
        .where((e) => e.produceCoordinates != null)
        .map((e) => Marker(
              markerId: MarkerId(e.seller.name.toString()),
              position: LatLng(e.produceCoordinates!.longitude,
                  e.produceCoordinates!.latitude),
              infoWindow: InfoWindow(
                title: e.seller.name.toString(),
                snippet: "Fresh Veggies from here",
              ),
            ))
        .toSet();

    setState(() {});
  }

  Set<Marker> sellerPins = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
      },
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 14,
      ),
      markers: sellerPins,
    );
  }
}
