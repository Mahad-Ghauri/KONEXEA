import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/controllers/Services/P-Hub%20Interface/interface_services.dart';
import 'package:social_swap/views/components/categories_components.dart';
// import 'package:iconsax/iconsax.dart';

class PHubInterface extends StatefulWidget {
  const PHubInterface({super.key});

  @override
  State<PHubInterface> createState() => _PHubInterfaceState();
}

class _PHubInterfaceState extends State<PHubInterface>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.yellow.shade800,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.shopping_bag_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15), // Instead of spacing in Row
            Text(
              'Products Hub By ShopEase',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                letterSpacing: 1.5,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Consumer<InterfaceServices>(
              builder: (context, interfaceProvider, child) {
                return CarouselSlider(
                  items: interfaceProvider.carouselItems
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
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 0.9,
                  ),
                );
              },
            ),
            Text(
              "Featured Categories - ShopEase",
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontFamily: GoogleFonts.outfit().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.sizeOf(context).height * 0.022,
              ),
            ),
            Consumer<InterfaceServices>(
                builder: (context, interfaceProvider, child) {
              return Expanded(
                child: GridView.builder(
                  itemCount: interfaceProvider.categoriesNames.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return LargeCategoryTile(
                      backgroundImage:
                          interfaceProvider.categoriesImages[index],
                      title: interfaceProvider.categoriesNames[index],
                      onTap: () {},
                    );
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
