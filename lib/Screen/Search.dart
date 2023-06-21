import 'package:ab_shop/Provider/ProductProvider.dart';
import 'package:ab_shop/Utlis/SnackBar.dart';
import 'package:ab_shop/Widgets/ProductWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<ProductProvider>(context, listen: false)
            .searchFetchingProducts(
                keyword: _controller.text, isLoadMore: true);
        // Load more data
        // Your data loading function here
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    print('object');
    if (_controller.text.isEmpty) {
      SnackBarWidget(context, 'ရှာဖွေချင်သော စကားလုံးထည့်ပါ');
      return;
    }
    Provider.of<ProductProvider>(context, listen: false).searchFetchingProducts(
      keyword: _controller.text,
    );
    // _controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 242, 242, 242),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              isDense: true,
              focusColor: Color.fromARGB(255, 218, 218, 218),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.text = '';
                    });
                  },
                  icon: const Icon(Icons.close_outlined)),
              hintText: 'ရှာဖွေချင်သော စကားလုံးထည့်ပါ ',
              hintStyle:const TextStyle(fontSize: 13),
              border: InputBorder.none,
            ),
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _search,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'ရှာကြည့်မည်',
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          return value.isLoadingProducts
              ? const Center(child: CircularProgressIndicator())
              : value.searchProducts.isEmpty
                  ? const Center(child: Text('မတွေ့ ရှိသေးပါ'))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 10,
                              mainAxisExtent: 300,),
                      controller: _scrollController,
                      itemCount: value.searchProducts.length + 1,
                      itemBuilder: (context, i) {
                        if (i == value.searchProducts.length) {
                          return value.isNotDataProducts
                              ? const Center(
                                  child: Text('Catch All Product!'),
                                )
                              : value.searchProducts.length > 8
                                  ? const ProductLoadingBox()
                                  : Container();
                        }
                        return ProductItem(
                          product: value.searchProducts[i],
                          leftPadding: 15,
                        );
                      },
                    );
        },
      ),
    );
  }
}

class ProductLoadingBox extends StatelessWidget {
  const ProductLoadingBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 239, 238, 238)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          LoadingBox(
            width: double.infinity,
            height: 150,
          ),
          SizedBox(
            height: 10,
          ),
          LoadingBox(
            width: double.infinity,
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          LoadingBox(
            width: 100,
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          LoadingBox(
            width: double.infinity / 3,
            height: 20,
          ),
        ],
      ),
    );
  }
}

class LoadingBox extends StatelessWidget {
  final double width;
  final double height;
  const LoadingBox({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 191, 190, 190),
      highlightColor: Color.fromARGB(255, 244, 244, 244),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
