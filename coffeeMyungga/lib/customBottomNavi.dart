import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavi {
  TextStyle optionStyle =
      TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold);

  bottomNavigationContainer({var selectedIndex, setStateCallback}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
      ]),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 8.h),
          child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24.sp,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
