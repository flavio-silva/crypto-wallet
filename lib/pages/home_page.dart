import 'package:crypto_coins/pages/coins_page.dart';
import 'package:flutter/material.dart';
import 'favorite_coins_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  void _changeCurrentPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          CoinsPage(),
          FavoriteCoinsPage(),
        ],
        onPageChanged: _changeCurrentPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade200,
        currentIndex: _currentPage,
        onTap: (page) {
          pageController.animateToPage(page,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All Coins'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Favorite Coins'),
        ],
      ),
    );
  }
}
