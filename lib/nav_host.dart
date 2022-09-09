import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/basket.dart';
import 'package:nandikrushi_farmer/nav_items/home.dart';
import 'package:nandikrushi_farmer/nav_items/my_account.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/nav_items/search.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/loader_screen.dart';
import 'package:provider/provider.dart';

class NandikrushiNavHost extends StatefulWidget {
  final String userId;

  const NandikrushiNavHost({Key? key, required this.userId}) : super(key: key);

  @override
  State<NandikrushiNavHost> createState() => _NandikrushiNavHostState();
}

class _NandikrushiNavHostState extends State<NandikrushiNavHost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      profileProvider.showLoader();
      profileProvider.getProfile(userID: widget.userId);
    });
  }

  var _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      List<Widget> widgetOptions = <Widget>[
        Center(
          child: HomeScreen(
            constraints: constraints,
          ),
        ),
        const Center(child: SearchScreen()),
        const Center(
          child: MyAccountScreen(),
        ),
        const Center(
          child: BasketScreen(),
        ),
      ];
      Map<String, List<IconData>> navItems = {
        'Home': [
          Icons.home_outlined,
          Icons.home,
        ],
        'Search': [
          Icons.search_outlined,
          Icons.search,
        ],
        'My account': [
          Icons.person_outline,
          Icons.person,
        ],
        'Basket': [
          Icons.shopping_basket_outlined,
          Icons.shopping_basket,
        ]
      };
      return Stack(
        children: [
          constraints.maxWidth < 600
              ? Scaffold(
                  body: widgetOptions[_selectedIndex],
                  bottomNavigationBar: NavigationBar(
                    destinations: navItems.entries
                        .map((e) => NavigationDestination(
                            icon: Icon(e.value[0]),
                            selectedIcon: Icon(e.value[1]),
                            label: e.key))
                        .toList(),
                    backgroundColor: Colors.white,
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                )
              : Row(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: NavigationRail(
                          groupAlignment: 0,
                          extended: constraints.maxWidth > 1200,
                          destinations: navItems.entries
                              .map((e) => NavigationRailDestination(
                                  icon: Icon(e.value[0]),
                                  selectedIcon: Icon(e.value[1]),
                                  label: Text(e.key)))
                              .toList(),
                          selectedIndex: _selectedIndex),
                    ),
                    Expanded(child: widgetOptions[_selectedIndex])
                  ],
                ),
          Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
            return profileProvider.shouldShowLoader
                ? const LoaderScreen()
                : const SizedBox();
          }),
        ],
      );
    });
  }
}
