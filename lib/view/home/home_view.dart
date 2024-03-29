import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_groceries/model/offer_product_model.dart';
import 'package:online_groceries/view/explore/filter_view.dart';
import 'package:online_groceries/view/home/product_details_view.dart';
import 'package:online_groceries/view/login/login_view.dart';
import 'package:online_groceries/view/search/filter_parameters.dart';
import 'package:online_groceries/view_model/product_cell2.dart';

import '../../common/color_extension.dart';
import '../../common_widget/category_cell.dart';
import '../../common_widget/product_cell.dart';
import '../../common_widget/section_view.dart';
import '../../view_model/cart_view_model.dart';
import '../../view_model/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final ScrollController _searchListScrollController = ScrollController();
  final ScrollController _offerListScrollController = ScrollController();
  final ScrollController _bestSellingListScrollController = ScrollController();
  final ScrollController _allproductsscrollController = ScrollController();

  bool isLoggedIn = false;
  TextEditingController txtSearch = TextEditingController();
  String keyword = "";

  // Add a boolean variable to track whether a search is performed
  bool isSearching = false;

  final homeVM = Get.put(HomeViewModel());

  @override
  void initState() {
    super.initState();
    _allproductsscrollController.addListener(_onAllProductScroll);
    print("NAMNAMNAM");
  }

  void _onSearchScroll() {
    if (_searchListScrollController.position.pixels ==
        _searchListScrollController.position.maxScrollExtent) {
      homeVM.serviceCallListSearch(keyword);
    }
  }

  void _onOfferListScroll() {
    if (_offerListScrollController.position.pixels ==
        _offerListScrollController.position.maxScrollExtent) {
      homeVM.serviceCallHomeExlusiveOffer();
    }
  }
  void _onBestSellingScroll() {
    if (_bestSellingListScrollController.position.pixels ==
        _bestSellingListScrollController.position.maxScrollExtent) {
      homeVM.serviceCallHomeBestSelling();
    }
  }

  void _onAllProductScroll() {
    if (_allproductsscrollController.position.pixels ==
        _allproductsscrollController.position.maxScrollExtent) {
      homeVM.serviceCallHomeAllProducts();
    }
  }

  @override
  void dispose() {
    _allproductsscrollController.dispose();
    Get.delete<HomeViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/color_logo.png",
                    width: 25,
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/location.png",
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Hi, Nam",
                    style: TextStyle(
                        color: TColor.darkGray,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F3F2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {

                          },
                          child: TextField(
                            controller: txtSearch,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Image.asset(
                                  "assets/img/search.png",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: "Search Store",
                              hintStyle: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if (txtSearch.text.isEmpty) {
                            setState(() {
                              isSearching = false;
                            });
                          } else {
                            // Set isSearching to true when the search button is pressed
                            setState(() {
                              isSearching = true;
                              keyword = txtSearch.text;
                            }
                            );
                            homeVM.serviceCallListSearch(keyword);
                          }
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                          "assets/img/filter_ic.png",
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () async  {
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FilterView()));
                            setState(() {
                              print('Before setState: ${homeVM.listArrSearch
                                  .length}');
                              homeVM.serviceCallListSearch(keyword);
                              isSearching = true;
                              print("Home :" + FilterParameters.minPrice);
                              print('After setState: ${homeVM.listArrSearch
                                  .length}');
                            });
                            homeVM.serviceCallListSearch(keyword);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              // Display search results only if isSearching is true
              isSearching ? buildSearchedList() : buildDefaultContent(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchedList()  {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Searched list",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 230,
          child: Obx(
                () =>
                ListView.builder(
                  controller: _searchListScrollController,
                  scrollDirection: Axis.horizontal,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: homeVM.listArrSearch.length,
                  itemBuilder: (context, index) {
                    var pObj = homeVM.listArrSearch[index];

                    return ProductCell(
                      pObj: pObj,
                      onPressed: () async {
                        await Get.to(() =>
                            ProductDetails(
                              pObj: pObj,
                            ));

                        homeVM.serviceCallHomeExlusiveOffer();
                        homeVM.serviceCallHomeBestSelling();
                        homeVM.serviceCallHomeGroceries();
                        homeVM.serviceCallHomeAllProducts();

                      },
                      onCart: () {
                        CartViewModel.serviceCallAddToCart(
                          pObj.prodId ?? 0,
                          1,
                              () {},
                        );
                      },
                    );
                  },
                ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
              width: double.maxFinite,
              height: 115,
              decoration: BoxDecoration(
                  color: const Color(0xffF2F3F2),
                  borderRadius: BorderRadius.circular(15)),
              alignment: Alignment.center,
              child: Image.asset(
                "assets/img/banner_top.png",
                fit: BoxFit.cover,
              )),
        ),
        SectionView(
          title: "Exclusive Offer",
          padding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onPressed: () {},
        ),
        SizedBox(
          height: 230,
          child: Obx(
                () =>
                ListView.builder(
                    controller: _offerListScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: homeVM.offerArr.length,
                    itemBuilder: (context, index) {
                      var pObj = homeVM.offerArr[index];
                      print("Trái cây");
                      return ProductCell(
                        pObj: pObj,
                        onPressed: () async {
                          await Get.to(() =>
                              ProductDetails(
                                pObj: pObj,
                              ));

                          homeVM.serviceCallHomeExlusiveOffer();
                          homeVM.serviceCallHomeBestSelling();
                          homeVM.serviceCallHomeGroceries();
                          homeVM.serviceCallHomeAllProducts();
                        },
                        onCart: () {
                          CartViewModel.serviceCallAddToCart(
                              pObj.prodId ?? 0, 1, () {

                          });
                        },
                      );
                    }),
          ),
        ),
        SectionView(
          title: "Best Selling",
          padding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onPressed: () {},
        ),
        SizedBox(
          height: 230,
          child: Obx(
                () =>
                ListView.builder(
                    controller: _bestSellingListScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: homeVM.bestSellingArr.length,
                    itemBuilder: (context, index) {
                      var pObj = homeVM.bestSellingArr[index];

                      return ProductCell(
                        pObj: pObj,
                        onPressed: () async {
                          await Get.to(() =>
                              ProductDetails(
                                pObj: pObj,
                              ));

                          homeVM.serviceCallHomeExlusiveOffer();
                          homeVM.serviceCallHomeBestSelling();
                          homeVM.serviceCallHomeGroceries();
                          homeVM.serviceCallHomeAllProducts();
                        },
                        onCart: () {
                          CartViewModel.serviceCallAddToCart(
                              pObj.prodId ?? 0, 1, () {});
                        },
                      );
                    }),),
        ),
        SectionView(
          title: "Groceries",
          padding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onPressed: () {},
        ),
        SizedBox(
          height: 100,
          child: Obx(
                () =>
                ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: homeVM.groceriesArr.length,
                    itemBuilder: (context, index) {
                      var pObj = homeVM.groceriesArr[index];

                      return CategoryCell(
                        pObj: pObj,
                        onPressed: () {},
                      );
                    }),),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 230,
          child: Obx(
                () =>
                ListView.builder(
                    controller: _allproductsscrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: homeVM.listArr.length,
                    itemBuilder: (context, index) {
                      var pObj = homeVM.listArr[index];

                      return ProductCell(
                        pObj: pObj,
                        onPressed: () async {
                          await Get.to(() =>
                              ProductDetails(
                                pObj: pObj,
                              ));

                          homeVM.serviceCallHomeExlusiveOffer();
                          homeVM.serviceCallHomeBestSelling();
                          homeVM.serviceCallHomeGroceries();
                          homeVM.serviceCallHomeAllProducts();
                        },
                        onCart: () {
                          CartViewModel.serviceCallAddToCart(
                              pObj.prodId ?? 0, 1, () {});
                        },
                      );
                    }),),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
  Widget buildDefaultContent() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
              width: double.maxFinite,
              height: 115,
              decoration: BoxDecoration(
                  color: const Color(0xffF2F3F2),
                  borderRadius: BorderRadius.circular(15)),
              alignment: Alignment.center,
              child: Image.asset(
                "assets/img/banner_top.png",
                fit: BoxFit.cover,
              )),
        ),
        SectionView(
          title: "Exclusive Offer",
          padding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onPressed: () {},
        ),
        SizedBox(
          height: 230,
          child: Obx(
                () => ListView.builder(
                    controller: _offerListScrollController,
                    scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: homeVM.offerArr.length,
                  itemBuilder: (context, index) {
                  var pObj = homeVM.offerArr[index] ;
                  print("Trái cây");
                  return ProductCell(
                    pObj: pObj,
                    onPressed: () async {
                      await Get.to(() => ProductDetails(
                        pObj: pObj,
                      ));

                      homeVM.serviceCallHomeExlusiveOffer();
                      homeVM.serviceCallHomeBestSelling();
                      homeVM.serviceCallHomeGroceries();
                      homeVM.serviceCallHomeAllProducts();
                    },
                    onCart: () {
                      CartViewModel.serviceCallAddToCart( pObj.prodId ?? 0  , 1, () {

                      });
                    },
                  );
                }),
          ),
        ),
        SectionView(
          title: "Best Selling",
          padding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onPressed: () {},
        ),
        SizedBox(
          height: 230,
          child: Obx(
                () => ListView.builder(
                    controller: _bestSellingListScrollController,
                    scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: homeVM.bestSellingArr.length,
                itemBuilder: (context, index) {
                  var pObj = homeVM.bestSellingArr[index];

                  return ProductCell(
                    pObj: pObj,
                    onPressed: () async {
                      await  Get.to(() => ProductDetails(
                        pObj: pObj,
                      ));

                      homeVM.serviceCallHomeExlusiveOffer();
                      homeVM.serviceCallHomeBestSelling();
                      homeVM.serviceCallHomeGroceries();
                      homeVM.serviceCallHomeAllProducts();
                    },
                    onCart: () {
                      CartViewModel.serviceCallAddToCart(
                          pObj.prodId ?? 0, 1, () {});
                    },
                  );
                }),),
        ),
        SectionView(
          title: "Groceries",
          padding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onPressed: () {},
        ),
        SizedBox(
          height: 100,
          child: Obx(
                () =>  ListView.builder(
                    scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: homeVM.groceriesArr.length,
                itemBuilder: (context, index) {
                  var pObj = homeVM.groceriesArr[index];

                  return CategoryCell(
                    pObj: pObj,
                    onPressed: () {},
                  );
                }),),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 230,
          child: Obx(
                () => ListView.builder(
                    controller: _allproductsscrollController,
                    scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: homeVM.listArr.length,
                itemBuilder: (context, index) {
                  var pObj = homeVM.listArr[index] ;

                  return ProductCell(
                    pObj: pObj,
                    onPressed: () async {

                      await Get.to(() => ProductDetails(
                        pObj: pObj,
                      ));

                      homeVM.serviceCallHomeExlusiveOffer();
                      homeVM.serviceCallHomeBestSelling();
                      homeVM.serviceCallHomeGroceries();
                      homeVM.serviceCallHomeAllProducts();
                    },
                    onCart: () {
                      CartViewModel.serviceCallAddToCart(
                          pObj.prodId ?? 0, 1, () {});
                    },
                  );
                }),),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

