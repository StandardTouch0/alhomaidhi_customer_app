import 'package:alhomaidhi_customer_app/src/features/home/features/all%20products/providers/products_provider.dart';
import 'package:alhomaidhi_customer_app/src/features/home/features/all%20products/widgets/product_card.dart';
import 'package:alhomaidhi_customer_app/src/features/home/features/all%20products/widgets/sort_button.dart';
import 'package:alhomaidhi_customer_app/src/utils/constants/assets.dart';
import 'package:alhomaidhi_customer_app/src/utils/helpers/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(allProductsProvider);
    final query = ref.read(productQueryProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Assets.logoLight,
          fit: BoxFit.contain,
          width: DeviceInfo.getDeviceWidth(context) * 0.35,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/all_brands");
            },
            icon: Image.asset(
              Assets.brandsButton,
              width: 60,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notification_important_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SortByButton(),
        ],
      ),
      body: products.when(data: (data) {
        if (data.status == "APP00") {
          return ListView(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextField(
                  controller: searchController,
                  enabled: true,
                  autofocus: true,
                  decoration: searchInputDecoration(),
                  onSubmitted: (search) {
                    query.updateSearch(search);
                  },
                ),
              ),
              GridView.builder(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: data.message!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: DeviceInfo.getDeviceWidth(context) /
                        (DeviceInfo.getDeviceHeight(context) / 1.5),
                  ),
                  itemBuilder: (ctx, index) {
                    return ProductCard(
                      imageUrl: data.message![index].images![0].src!,
                      title: data.message![index].productDetails!.name!,
                      priceBefore:
                          data.message![index].productDetails!.regularPrice!,
                      priceNow: data.message![index].productDetails!.price!,
                      isSearch: true,
                    );
                  }),
            ],
          );
        } else {
          return SizedBox(
            height: DeviceInfo.getDeviceHeight(context) * 0.8,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("An Error Occurred ${data.status}"),
                  Text(data.errorMessage!),
                ],
              ),
            ),
          );
        }
      }, error: (err, stk) {
        return SizedBox(
          height: DeviceInfo.getDeviceHeight(context) * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("An Error Occurred"),
                Text("$err"),
              ],
            ),
          ),
        );
      }, loading: () {
        return SizedBox(
          height: DeviceInfo.getDeviceHeight(context) * 0.8,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }

  InputDecoration searchInputDecoration() {
    return InputDecoration(
      labelText: "Search Products",
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      fillColor: Colors.white,
      focusColor: Colors.white,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      labelStyle: TextStyle(
        color: Colors.black,
      ),
    );
  }
}
