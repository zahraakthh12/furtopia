// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:furtopia/view/bottom/home_screen.dart';
// import 'package:furtopia/view/bottom/profile_screen.dart';

// class CurvedBottomNav extends StatefulWidget {
//   const CurvedBottomNav({super.key});

//   @override
//   State<CurvedBottomNav> createState() => _CurvedBottomNavState();
// }

// class _CurvedBottomNavState extends State<CurvedBottomNav> {
//   int _selectedIndex = 0;
//   static const List<Widget> _widgetOptions = [
//     // Center(child: Text("Home")),
//     HomePage(),
//     HomePage(),
//     // ProfilePage()
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text("Bottom Navigation")),
//       body: _widgetOptions[_selectedIndex],
//       bottomNavigationBar: CurvedNavigationBar(
//         backgroundColor: Colors.brown,
//         items: <Widget>[
//           Icon(Icons.home, size: 30),
//           Icon(Icons.person, size: 30),
//         ],
//         onTap: (index) {
//           print(index);
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }