import 'package:code_factory_app/common/const/colors.dart';
import 'package:code_factory_app/common/layout/default_layout.dart';
import 'package:code_factory_app/product/view/product_tab.dart';
import 'package:code_factory_app/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController tabController;

  int index = 0;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);

    tabController.addListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.removeListener(tabListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '딜리버리',
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: INPUT_BG_COLOR,
          selectedItemColor: PRIMARY_COLOR,
          unselectedItemColor: BODY_TEXT_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            tabController.animateTo(index);
          },
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood_outlined), label: '음식'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined), label: '주문'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined), label: '프로필'),
          ]),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          RestaurantScreen(),
          ProductTab(),
          Center(child: Container(child: Text('주문'))),
          Center(child: Container(child: Text('프로필'))),
        ],
      ),
    );
  }
}
