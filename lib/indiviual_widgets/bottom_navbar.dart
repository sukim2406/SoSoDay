import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

import '../globals.dart' as globals;

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function setCurIndex;
  final Map matchDoc;
  final String myUid;

  const BottomNavbar({
    Key? key,
    required this.currentIndex,
    required this.setCurIndex,
    required this.matchDoc,
    required this.myUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: globals.primaryColor,
      selectedItemColor: globals.secondaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (index) => setCurIndex(index),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.grey[500],
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.photo),
          label: 'Photo',
        ),
        (matchDoc['userMaps'][myUid]['unseenMessage'] > 0)
            ? BottomNavigationBarItem(
                icon: Badge(
                  badgeContent: Text(
                    matchDoc['userMaps'][myUid]['unseenMessage'].toString(),
                  ),
                  child: const Icon(Icons.chat),
                ),
                label: 'Chat',
              )
            : const BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
