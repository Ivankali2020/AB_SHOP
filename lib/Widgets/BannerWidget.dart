import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Model/Banner.dart';
import 'package:ab_shop/Provider/BannerProvider.dart';
import 'package:ab_shop/Screen/Discount.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _controller = PageController();

    return FutureBuilder(
        future:
            Provider.of<BannerProvider>(context, listen: false).fetchBanners(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Loading('Loading', double.infinity, 155, 20));
          }

          if (snapShot.connectionState == ConnectionState.done) {
            final banners = Provider.of<BannerProvider>(context).banners;

            return banners.isEmpty
                ? const Center(
                    child: Loading('No Banners', double.infinity, 100, 20))
                : Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: banners.length,
                          itemBuilder: (context, i) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.of(context).push(FadeRightPageRoute(
                                    builder: (context) => Discount(),
                                    arguments: banners[i].id));
                              },
                              child: BannerImageWidget(
                                photo: banners[i].photo,
                              ),
                            );
                          },
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: banners.length,
                        effect: const ExpandingDotsEffect(
                            dotWidth: 6,
                            dotHeight: 5,
                            activeDotColor: Colors.redAccent,
                            dotColor: Color.fromARGB(255, 240, 240, 240)),
                      )
                    ],
                  );
          }

          return const Center(
            child: Text('What\'s happeded?'),
          );
        });
  }
}

class BannerImageWidget extends StatelessWidget {
  const BannerImageWidget({
    super.key,
    required this.photo,
  });

  final String photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: photo,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 100,
          placeholder: (context, url) => const Center(
              child: Loading('Getting Photos', double.infinity, 100, 20)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String title;
  final double width;
  final double heght;
  final double fontSize;
  // late Color color = Color.fromARGB(255, 244, 244, 244);
  const Loading(this.title, this.width, this.heght, this.fontSize, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heght,
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Color.fromARGB(255, 244, 244, 244),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
