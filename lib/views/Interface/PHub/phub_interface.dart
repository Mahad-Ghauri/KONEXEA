// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/Controllers/Services/P-Hub%20Interface/interface_controllers.dart';
import 'package:social_swap/Views/Components/Product%20Hub/cart_icon.dart';
import 'package:social_swap/Views/Components/Product%20Hub/category_tile.dart';
import 'package:social_swap/Views/Components/Product%20Hub/large_category_tile.dart';
import 'package:social_swap/Views/Interface/Chat%20Bot/chatbot_page.dart';
import 'package:social_swap/Views/Interface/PHub/Featured%20Categories/featured_products.dart';
import 'package:social_swap/Views/Interface/PHub/product_page.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/views/Auth%20Gate/auth_gate.dart';
// import 'package:social_swap/Views/Components/Product%20Hub/drawer_component.dart';
// import 'package:social_swap/Views/Interface/PHub/Cart/cart_page.dart';
// import 'package:social_swap/views/Interface/Profile/about_page.dart';

class PHubInterfacePage extends StatefulWidget {
  const PHubInterfacePage({super.key});

  @override
  State<PHubInterfacePage> createState() => _InterfacePageState();
}

class _InterfacePageState extends State<PHubInterfacePage> {
  //  Instance for Auth Services
  final AuthenticationController authServices = AuthenticationController();

  // Use lazy loading for better performance
  late final InterfaceController interfaceController;

  @override
  void initState() {
    super.initState();
    // Initialize controller in initState
    interfaceController = Provider.of<InterfaceController>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar() as PreferredSizeWidget,
      body: _buildBody(size),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left_1),
        onPressed: () {
          Navigator.of(context).pop(
            _elegantRoute(const AuthGate()),
          );
        },
      ),
      backgroundColor: Colors.grey.shade100,
      iconTheme: IconThemeData(color: Colors.yellow.shade800),
      elevation: 0.0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow.shade800.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_bag, color: Colors.yellow.shade800),
          ),
          const SizedBox(width: 10),
          Text(
            "Shop Ease",
            style: TextStyle(
              fontFamily: GoogleFonts.lobsterTwo().fontFamily,
              color: Colors.yellow.shade800,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
        ],
      ),
      actions: const [CartIcon()],
    );
  }

  Widget _buildBody(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.025,
        vertical: size.height * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: interfaceController.carouselItems
                .map(
                  (items) => Container(
                    margin: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      child: Image.asset(
                        items,
                        fit: BoxFit.cover,
                        width: 1000.0,
                      ),
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 180.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.9,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "New Arrivals",
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
              fontSize: size.height * 0.03,
              fontFamily: GoogleFonts.outfit().fontFamily,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryTile(
                icon: Icons.electrical_services,
                text: "Electronics",
                onPressed: () => Navigator.of(context).push(
                  _elegantRoute(
                      const FeaturedProducts(category: "Electronics")),
                ),
              ),
              CategoryTile(
                icon: Icons.house,
                text: "Household Products",
                onPressed: () => Navigator.of(context).push(
                  _elegantRoute(
                    const FeaturedProducts(category: "Household Products"),
                  ),
                ),
              ),
              CategoryTile(
                icon: Icons.shopping_bag_outlined,
                text: "Thrift Store",
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(
                      _elegantRoute(const ProductPage(title: "Thrift Store")));
                },
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "Featured Categories",
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
              fontSize: size.height * 0.03,
              fontFamily: GoogleFonts.outfit().fontFamily,
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: interfaceController.largeCategoryItems.length,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: LargeCategoryTile(
                    backgroundImage:
                        interfaceController.largeCategoryItems[index],
                    onTap: () => Navigator.of(context).push(
                      _elegantRoute(
                        FeaturedProducts(
                          category:
                              interfaceController.largeCategoryTitles[index],
                        ),
                      ),
                    ),
                    title: interfaceController.largeCategoryTitles[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.yellow.shade700,
      onPressed: () {
        Navigator.of(context).push(_elegantRoute(const ChatbotPage()));
      },
      child: const Icon(Icons.chat_rounded, color: Colors.white),
    );
  }

  PageRouteBuilder _elegantRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween<double>(begin: 0, end: 1).animate(animation);
        var scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutExpo),
        );
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
