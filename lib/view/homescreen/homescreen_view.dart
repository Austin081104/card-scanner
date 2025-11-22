import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:card_sacnner_app/modal/cardmodal.dart';
import 'package:card_sacnner_app/view/homescreen/categoty_page_view.dart';
import 'package:card_sacnner_app/view/homescreen/favorite_page_view.dart';
import 'package:card_sacnner_app/view/homescreen/home_page_view.dart';
import 'package:card_sacnner_app/view/homescreen/profile_page_view.dart';
import 'package:card_sacnner_app/view/scan_view/scan_view_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomescreenView extends StatefulWidget {
  const HomescreenView({super.key});

  @override
  State<HomescreenView> createState() => _HomescreenViewState();
}

class _HomescreenViewState extends State<HomescreenView> {
  int currentIndex = 0;
  List<BusinessCardModel> cards = [];

  // ✅ Real FavoritePage key here
  final GlobalKey<FavoritePageViewState> favKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('savedCards') ?? [];
    setState(() {
      cards = list.map((e) => BusinessCardModel.fromJson(e)).toList();
    });
  }

  // 👇 List of pages
  List<Widget> get pages => [
    HomePageView(
      key: UniqueKey(),
      onFavoriteChanged: () => favKey.currentState?.refreshFavorites(),
    ),
    const CategoryPageView(),
    FavoritePageView(key: favKey),
    const ProfilePageView(),
  ];

  final List<IconData> _iconList = [
    Icons.home,
    Icons.category,
    Icons.favorite,
    Icons.person,
  ];

  void _onIconTap(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(100),
      //   child: AppbarWidget(),
      // ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(side: BorderSide.none),
        onPressed: () async {
          await Get.to(() => const BusinessCardScannerPage());
          setState(() {});
          await _loadCards();
        },
        elevation: 2,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.qr_code_scanner, color: Colors.blue, size: 35),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _iconList,
        activeIndex: currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapWidth: 70,
        backgroundColor: Colors.blue,
        activeColor: Colors.white,
        inactiveColor: Colors.white54,
        backgroundGradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        splashColor: Colors.blue,
        splashSpeedInMilliseconds: 300,
        onTap: _onIconTap,
        elevation: 10,
      ),
      body: IndexedStack(index: currentIndex, children: pages),
    );
  }
}
