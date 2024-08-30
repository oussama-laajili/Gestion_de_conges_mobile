import 'package:flutter/material.dart';

class CurvedNavigationBar extends StatelessWidget {
  const CurvedNavigationBar({
    Key? key,
    required this.items,
    this.onTap,
    this.unselectedColor = Colors.grey,
    this.selectedColor = Colors.blue,
    this.currentIndex = 0,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  final List<CurvedNavigationBarItem> items;
  final ValueChanged<int>? onTap;
  final Color unselectedColor;
  final Color selectedColor;
  final int currentIndex;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CurvedClipper(),
      child: Container(
        height: kToolbarHeight * 1.7,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;
            return Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Transform(
                  transform: Matrix4.translationValues(
                    0,
                    isSelected ? -10 : 0,
                    0,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          (index == 0 || index == items.length - 1) ? 20.0 : 0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ]
                            : [],
                      ),
                      child: IconButton(
                        onPressed: () => onTap?.call(index),
                        color: isSelected ? selectedColor : unselectedColor,
                        icon: Icon(
                          isSelected
                              ? item.selectedIconData ?? item.iconData
                              : item.iconData,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class CurvedNavigationBarItem {
  const CurvedNavigationBarItem({
    required this.iconData,
    this.selectedIconData,
  });

  final IconData iconData;
  final IconData? selectedIconData;
}

class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..quadraticBezierTo(size.width * .5, kToolbarHeight, size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Example usage
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(child: Text('Curved Navigation Bar')),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          CurvedNavigationBarItem(iconData: Icons.home),
          CurvedNavigationBarItem(iconData: Icons.search),
          CurvedNavigationBarItem(iconData: Icons.notifications),
          CurvedNavigationBarItem(iconData: Icons.message),
          CurvedNavigationBarItem(iconData: Icons.person),
        ],
        onTap: (index) {
          print('Selected index: $index');
        },
        backgroundColor: Colors.black, // Set your desired color here
      ),
    ),
  ));
}
