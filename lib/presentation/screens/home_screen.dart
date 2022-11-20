import 'package:flutter/material.dart';
import 'package:whatsapp_clone_app/presentation/widgets/custom_tab_bar.dart';
import 'package:whatsapp_clone_app/presentation/widgets/theme/style.dart';

import '../pages/calls_page.dart';
import '../pages/camera_page.dart';
import '../pages/chat_page.dart';
import '../pages/status_page.dart';

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({
    super.key,
    required this.uid,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearch = false;
  int _currentPageIndex = 1;
  PageController _pageViewController = PageController(initialPage: 1);

  List<Widget> get _pages => [
        const CameraPage(),
        const ChatPage(),
        const StatusPage(),
        const CallsPage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPageIndex != 0
          ? AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor:
                  _isSearch == false ? primaryColor : Colors.transparent,
              title: _isSearch == false
                  ? const Text("WhatsApp Clone")
                  : const SizedBox(
                      height: 0.0,
                      width: 0.0,
                    ),
              flexibleSpace: _isSearch == false
                  ? const SizedBox(
                      height: 0.0,
                      width: 0.0,
                    )
                  : _buildSearch(),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      _isSearch = true;
                    });
                  },
                  child: const Icon(Icons.search),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {},
                  child: const Icon(Icons.more_vert),
                ),
              ],
            )
          : null,
      body: Column(
        children: <Widget>[
          // NOTE: Custom Tab Bar
          _isSearch == false
              ? _currentPageIndex != 0
                  ? CustomTabBar(index: _currentPageIndex)
                  : const SizedBox(
                      height: 0.0,
                      width: 0.0,
                    )
              : const SizedBox(height: 0.0, width: 0.0),

          // NOTE: PageView
          Expanded(
            child: PageView.builder(
              itemCount: _pages.length,
              controller: _pageViewController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (_, index) {
                return _pages[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildSearch() {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            spreadRadius: 1,
            offset: const Offset(0.0, 0.50),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: InkWell(
            onTap: () {
              setState(() {
                _isSearch = false;
              });
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
    );
  }
}
