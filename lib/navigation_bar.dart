import 'dart:developer';

import 'package:cafe/basket_page.dart';
import 'package:cafe/data/currency_model.dart';
import 'package:cafe/data/dish_model.dart';
import 'package:cafe/data/hive_boxes.dart';
import 'package:cafe/home_page.dart';
import 'package:cafe/menu_page.dart';
import 'package:cafe/report_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationIndicatorBar extends StatefulWidget {
  const NavigationIndicatorBar({super.key});

  @override
  State<NavigationIndicatorBar> createState() => _NavigationIndicatorBarState();
}

class _NavigationIndicatorBarState extends State<NavigationIndicatorBar> {
  String currerntElem = "Home";
  Box<CurrencyModel> currncyModel = Hive.box<CurrencyModel>(
    HiveBoxes.currencyModel,
  );
  TextStyle drawerTextStyle = GoogleFonts.inter(
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  MenuElem menu = MenuElem(
    isOpen: false,
    selectedElem: "Dollar",
    listElements: [
      "Dollar",
      "Euro",
      "Yen",
      "Pound Sterling",
      "Australian Dollar",
      "Canadian Dollar",
      "Swiss Franc",
      "Chinese Yuan Renminbi",
      "Hong Kong Dollar",
      "New Zealand Dollar",
      "Swedish Krona",
      "South Korean Won",
      "Singapore Dollar",
      "Norwegian Krone",
      "Mexican Peso",
      "Indian Rupee",
      "Russian Ruble",
      "South African Rand",
      "Brazilian Real",
      "Danish Krone",
      "Polish Zloty",
      "Turkish Lira",
      "Thai Baht",
      "Indonesian Rupiah",
      "Czech Koruna",
      "Hungarian Forint",
      "Chilean Peso",
      "Israeli New Shekel",
      "Saudi Riyal",
      "Philippine Peso",
    ],
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menu.selectedElem = getCurrencyName(
      currncyModel.getAt(0)?.currency.toString() ?? "Dollar",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyDrawer,
      drawer: Container(
        width: 268.w,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF8CBBE5),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 26.w),
            alignment: Alignment.topLeft,
            width: 222.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Settings', drawerTextStyle),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Currency", style: drawerTextStyle),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        onChanged: (value) {
                          setState(() {
                            menu.selectedElem = value.toString();
                            currncyModel.putAt(
                              0,
                              CurrencyModel(
                                currency: getCurrencySymbol(value.toString()),
                              ),
                            );
                          });
                        },
                        onMenuStateChange: (isOpen) {
                          setState(() {
                            menu.isOpen = isOpen;
                          });
                        },
                        customButton: Row(
                          children: [
                            Text(menu.selectedElem, style: drawerTextStyle),
                            Icon(
                              menu.isOpen
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 30.h,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        items:
                            menu.listElements.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: SizedBox(
                                  width: 355.w,
                                  height: 50.h,
                                  child: Center(
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                        dropdownStyleData: DropdownStyleData(
                          width: 300.w,
                          maxHeight: 300.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          offset: Offset(-60.w, 0),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          customHeights: List.filled(
                            menu.listElements.length,
                            50.h,
                          ),
                          padding: EdgeInsets.only(
                            top: 5.h,
                            left: 10.w,
                            right: 10.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 84.h),
                _buildSectionHeader('Contact center', drawerTextStyle),
                SizedBox(height: 44.h),
                _buildActionItem(
                  'Contact us',
                  "assets/icons/contact.svg",
                  drawerTextStyle,
                  () async {
                    String? encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map(
                            (MapEntry<String, String> e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                          )
                          .join('&');
                    }

                    // ···
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'nuriaydinbayburtlu23@icloud.com',
                      query: encodeQueryParameters(<String, String>{'': ''}),
                    );
                    try {
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        throw Exception("Could not launch $emailLaunchUri");
                      }
                    } catch (e) {
                      log('Error launching email client: $e'); // Log the error
                    }
                  },
                ),
                _buildActionItem(
                  'Privacy policy',
                  "assets/icons/privacy.svg",
                  drawerTextStyle,
                  () async {
                    final Uri url = Uri.parse(
                      'https://docs.google.com/document/d/1HDEwAnum_VfLBlBVBP-kyax6Z130l2z6_rUI3bbC47U/mobilebasic',
                    );
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                ),
                _buildActionItem(
                  'Rate us',
                  "assets/icons/rate.svg",
                  drawerTextStyle,
                  () {
                    InAppReview.instance.openStoreListing(
                      appStoreId: '6746253514',
                    );
                    // 6746253514
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBarWidget(
        changeBody: (p0) {
          currerntElem = p0;
          setState(() {});
        },
        currerntElem: currerntElem,
      ),
      body: myBody(currerntElem),
    );
  }

  Widget _buildSectionHeader(String title, TextStyle style) {
    return Text(title, style: style);
  }

  Widget _buildActionItem(
    String title,
    String svgPath,
    TextStyle style,
    Function() onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      title: Text(title, style: style),

      leading: SvgPicture.asset(svgPath),
      onTap: onTap,
    );
  }

  Widget myBody(String currerntElem) {
    switch (currerntElem) {
      case "Home":
        return HomePage();
      case "Menu":
        return MenuPage();
      case "Basket":
        return BasketPage();
      case "Report":
        return ReportPage();
      default:
        return MenuPage();
    }
  }
}

// ignore: must_be_immutable
class NavBarWidget extends StatefulWidget {
  NavBarWidget({
    super.key,
    required this.changeBody,
    required this.currerntElem,
  });
  Function(String) changeBody;
  String currerntElem;
  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<DishModel>(HiveBoxes.dishBox).listenable(),
      builder: (context, Box<DishModel> box, _) {
        int count = 0;
        for (var element in box.values) {
          count += element.count;
        }
        return Container(
          height: 97.h,
          width: double.infinity,
          color: const Color(0xFFE8F4FF),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                ["Home", "Menu", "Basket", "Report"].map((toElement) {
                  return GestureDetector(
                    onTap: () {
                      widget.changeBody(toElement);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 46.w,
                              height: 46.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/$toElement.svg",
                                  // ignore: deprecated_member_use
                                  color:
                                      widget.currerntElem == toElement
                                          ? const Color(0xFF2F6CA2)
                                          : Colors.black.withValues(alpha:  0.5),
                                ),
                              ),
                            ),
                            if (toElement == "Basket" && count != 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Text(
                                      count.toString(),
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        Text(
                          toElement,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color:
                                widget.currerntElem == toElement
                                    ? const Color(0xFF2F6CA2)
                                    : Colors.black.withValues(alpha:  0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
