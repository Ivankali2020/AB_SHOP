import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Model/Category.dart';
import 'package:ab_shop/Provider/CategoryProvider.dart';
import 'package:ab_shop/Provider/ProductProvider.dart';
import 'package:ab_shop/Screen/Search.dart';
import 'package:ab_shop/Utlis/ButtonStyle.dart';
import 'package:ab_shop/Widgets/BannerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryMain extends StatelessWidget {
  const CategoryMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FutureBuilder(
        future: Provider.of<CategoryProvider>(context, listen: false)
            .fetchCategories(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Loading('Categories', double.infinity, 50, 13),
            );
          }
          if (snapShot.connectionState == ConnectionState.done) {
            final categoryProvider = Provider.of<CategoryProvider>(context);
            final categories = categoryProvider.catgories;
            categoryProvider.getBrands();

            return categories.isEmpty
                ? const Center(
                    child: Loading('Empty Categories', double.infinity, 50, 20),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 2,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return CategoryWidget(
                          imageUrl:
                              'https://static.thenounproject.com/png/1041139-200.png',
                          name: 'ALL',
                          selected: true,
                          brands: categoryProvider.brands,
                        );
                      } else if (i == (categories.length + 1)) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {},
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 241, 241, 241)),
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: const Center(
                                  child: Loading('See more', 80, 40, 13)),
                            ),
                          ),
                        );
                      }
                      return CategoryWidget(
                        imageUrl: categories[i - 1].photo,
                        name: categories[i - 1].name,
                        selected: categories[i - 1].isSelected,
                        brands: categories[i - 1].brands,
                      );
                    },
                  );
          }

          if (snapShot.hasError) {
            return const Center(
              child: Loading('Error', double.infinity, 50, 20),
            );
          }

          return const Center(
            child:
                Loading('WTF I don not what error?', double.infinity, 50, 20),
          );
        },
      ),
    );
  }
}

Future<dynamic> subCategoryModalBottomSheet(
    BuildContext context, String categoryName, List brands) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return Container(
        height: 400,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin:const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                categoryName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            brands.isEmpty
                ? const Center(child: Text('No Brands Found'))
                : Expanded(
                    child: GridView.builder(
                      itemCount: brands.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 90,
                              mainAxisSpacing: 8),
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Provider.of<ProductProvider>(context, listen: false)
                                .addBrandId(brands[i].id);
                            Navigator.of(context).push(FadeRightPageRoute(
                                builder: (context) => const SearchScreen()));
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: brands[i].photo,
                                  placeholder: (context, url) =>
                                      const Loading('Loading', 70, 70, 13),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: FittedBox(child: Text(brands[i].name)),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      );
    },
  );
}

class CategoryWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool selected;
  final List<Brands> brands;
  const CategoryWidget(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.selected,
      required this.brands});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        overlayColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.secondaryContainer),
        splashColor: Theme.of(context).colorScheme.secondaryContainer,
        onTap: () => subCategoryModalBottomSheet(context, name, brands),
        child: CategoryItem(selected: selected, imageUrl: imageUrl, name: name),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem({
    super.key,
    required this.selected,
    required this.imageUrl,
    required this.name,
  });

  final bool selected;
  late String? imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : const Color.fromARGB(255, 241, 241, 241)),
          borderRadius: BorderRadius.circular(8)),
      padding:
          const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageUrl!.isNotEmpty? CachedNetworkImage(
            imageUrl: imageUrl!,
            width: 20,
            height: 20,
            placeholder: (cotext, data) => const Center(
              child: Loading('..', 20, 20, 10),
            ),
          ) : Container(),
          const SizedBox(
            width: 10,
          ),
          Text(
            name,
            style: GoogleFonts.actor(
                color: !selected ? Colors.black54 : Colors.black,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                textBaseline: TextBaseline.alphabetic,
                fontSize: 12),
          )
        ],
      ),
    );
  }
}
