import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nandikrushi_farmer/product/product_card.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  var tabs = ["A2 Milk", "Vegetables", "Fruits", "Ghee", "Oil", "Millets"];
  late TabController _controller;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 6, vsync: this, initialIndex: 1);
    searchController = TextEditingController();
  }

  Color getTabBarTextColor(int i) {
    return _controller.index == i
        ? Theme.of(context).primaryColor
        : Colors.black;
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
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 280,
              child: MapsContainer(),
            ),
            Container(
              color: Colors.grey,
              height: 2,
            ),
          ])),
          SliverAppBar(
            toolbarHeight: 30,
            backgroundColor: Colors.white,
            flexibleSpace: Center(
              child: TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                controller: _controller,
                isScrollable: true,
                tabs: [
                  Tab(
                    child: TextWidget(
                      tabs[0].toUpperCase(),
                      weight: getTabBarTextFontWeight(0),
                      color: getTabBarTextColor(0),
                    ),
                  ),
                  Tab(
                    child: TextWidget(
                      tabs[1].toUpperCase(),
                      weight: getTabBarTextFontWeight(1),
                      color: getTabBarTextColor(1),
                    ),
                  ),
                  Tab(
                    child: TextWidget(
                      tabs[2].toUpperCase(),
                      weight: getTabBarTextFontWeight(2),
                      color: getTabBarTextColor(2),
                    ),
                  ),
                  Tab(
                    child: TextWidget(
                      tabs[3].toUpperCase(),
                      weight: getTabBarTextFontWeight(3),
                      color: getTabBarTextColor(3),
                    ),
                  ),
                  Tab(
                    child: TextWidget(
                      tabs[4].toUpperCase(),
                      weight: getTabBarTextFontWeight(4),
                      color: getTabBarTextColor(4),
                    ),
                  ),
                  Tab(
                    child: TextWidget(
                      tabs[5].toUpperCase(),
                      weight: getTabBarTextFontWeight(5),
                      color: getTabBarTextColor(5),
                    ),
                  ),
                ],
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
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  width: 24,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: TextWidget(
                      tabs[_controller.index].toUpperCase(),
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
                                    color: Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.all(0),
                                    child: const Icon(
                                      Icons.search_rounded,
                                      color: Colors.white,
                                    ))),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _controller,
                        children: [
                          Container(),
                          Column(
                            children: const [
                              ProductCard(
                                  type: CardType.product,
                                  productName: "Brinjal",
                                  productDescription:
                                      "Deep purple and oval shaped bottle brinjals are glossy skinned vegetables with a white and ....",
                                  imageURL:
                                      "https://resources.commerceup.io/?key=https%3A%2F%2Fprod-admin-images.s3.ap-south-1.amazonaws.com%2FpWVdUiFHtKGqyJxESltt%2Fproduct%2F30571001191.jpg&width=800&resourceKey=pWVdUiFHtKGqyJxESltt",
                                  price: 47.04,
                                  units: "1 kg",
                                  location: "Visakhapatnam"),
                              ProductCard(
                                  type: CardType.product,
                                  productName: "Lady Fingers",
                                  productDescription:
                                      "Deep purple and oval shaped bottle brinjals are glossy skinned vegetables with a white and ....",
                                  imageURL:
                                      "https://freepngimg.com/thumb/ladyfinger/42370-2-lady-finger-png-free-photo.png",
                                  price: 36.04,
                                  units: "1 kg",
                                  location: "Visakhapatnam")
                            ],
                          ),
                          Container(),
                          Container(),
                          Container(),
                          Container(),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MapsContainer extends StatefulWidget {
  const MapsContainer({Key? key}) : super(key: key);

  @override
  State<MapsContainer> createState() => _MapsContainerState();
}

class _MapsContainerState extends State<MapsContainer> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(17.7410573, 83.3093624);
  final Map<String, LatLng> markerLocations = {
    "Spotmies": const LatLng(17.744257, 83.3106602),
    "Manas's Residence": const LatLng(17.7410573, 83.3093624)
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.clear();
      for (final office in markerLocations.entries) {
        final marker = Marker(
          markerId: MarkerId(office.key),
          position: LatLng(office.value.latitude, office.value.longitude),
          infoWindow: InfoWindow(
            title: office.key,
            snippet: "${office.value.latitude},${office.value.longitude}",
          ),
        );
        _markers[office.key] = marker;
      }
    });
  }

  final Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 16,
      ),
      markers: _markers.values.toSet(),
    );
  }
}
