import 'package:flutter/material.dart';

class UpliftBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  
  const UpliftBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFF4ECDC4),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: "Discover",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: "Post",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          label: "Messages",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          label: "Applications",
        ),
      ],
      onTap: onTap,
    );
  }
}