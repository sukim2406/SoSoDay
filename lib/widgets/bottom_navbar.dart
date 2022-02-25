import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  var currentIndex;
  final Function setCurIndex;
  BottomNavbar(
      {Key? key, required this.currentIndex, required this.setCurIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color.fromRGBO(255, 222, 158, 1),
      selectedItemColor: Color.fromRGBO(85, 74, 53, 1),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (index) => setCurIndex(index),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.grey[500]),
        BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Photo'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings')
      ],
    );
  }
}

// class BottomNavbar extends StatefulWidget {
//   const BottomNavbar({Key? key}) : super(key: key);

//   @override
//   _BottomNavbarState createState() => _BottomNavbarState();
// }

// class _BottomNavbarState extends State<BottomNavbar> {
//   var currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Colors.white,
//       selectedItemColor: Colors.red,
//       unselectedItemColor: Colors.grey,
//       showUnselectedLabels: false,
//       currentIndex: currentIndex,
//       onTap: (index) => setState(() => currentIndex = index),
//       items: [
//         BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//             backgroundColor: Colors.grey[500]),
//         BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Photo'),
//         BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
//         BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'favorites'),
//         BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings')
//       ],
//     );
//   }
// }
