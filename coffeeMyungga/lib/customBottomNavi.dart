import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavi {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  bottomNavigationContainer({var selectedIndex, setStateCallback}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
      ]),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 800),
              tabBackgroundColor: Colors.grey[800],
              tabs: [
                GButton(
                  icon: Icons.today,
                  text: 'Today',
                ),
                GButton(
                  icon: Icons.calendar_today_rounded,
                  text: 'Calendar',
                ),
                GButton(
                  icon: Icons.bug_report,
                  text: 'Report',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Manager',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) => setStateCallback(index)),
        ),
      ),
    );
  }
}
