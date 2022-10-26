import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/providers/providers.dart';

import 'author_quote_view.dart';
import 'favorite_view.dart';
import 'search_quote_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  int pageIndex = 0;
  late PageController _pageController;
  final List<Widget> pages = <Widget>[
    const AuthorQuoteView(),
    const SearchQuoteView(),
    const FavoriteView(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void _onItemTapped(int index, WidgetRef ref) {
    ref.watch(pageIndexProv.state).state = index;
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes App'),
        centerTitle: true,
      ),
      body: Consumer(builder: (context, ref, _) {
        return PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          onPageChanged: (value) =>
              ref.watch(pageIndexProv.state).state = value,
          children: pages,
        );
      }),
      bottomNavigationBar: Consumer(builder: (context, ref, _) {
        return BottomNavigationBar(
          backgroundColor: const Color(0x00ffffff),
          selectedFontSize: 18,
          selectedIconTheme: const IconThemeData(
            color: Colors.amberAccent,
            size: 30,
          ),
          selectedItemColor: Colors.amberAccent,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          currentIndex: ref.watch(pageIndexProv.state).state,
          onTap: (int index) => _onItemTapped(index, ref),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          unselectedIconTheme: const IconThemeData(
            color: Colors.white,
            size: 15,
          ),
          unselectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Author Quote',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search Quote',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorite',
            ),
          ],
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
