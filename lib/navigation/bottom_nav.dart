import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/cart_screen.dart';
import 'package:furtopia/view/home_page.dart';
import 'package:furtopia/view/petlist_screen.dart';
import 'package:furtopia/view/profile_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    // Center(child: Text("Home")),
    HomePage(),
    PetListScreen(),
    CartPage(),
    ProfilePage()

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Bottom Navigation")),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar( backgroundColor: AppColors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          print(index);
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.pets_outlined), label: "Pet"),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}