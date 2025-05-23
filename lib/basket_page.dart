import 'package:cafe/data/currency_model.dart';
import 'package:cafe/data/dish_model.dart';
import 'package:cafe/data/dish_save_model.dart';
import 'package:cafe/data/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  Box<DishModel> dish = Hive.box<DishModel>(HiveBoxes.dishBox);
  Box<DishSaveModel> dishSave = Hive.box<DishSaveModel>(HiveBoxes.dishSaveBox);
  List<DishModel> listDish = [];
  TextEditingController discountController = TextEditingController();
  TextEditingController pointController = TextEditingController();
  FocusNode discountNode = FocusNode();
  FocusNode pointNode = FocusNode();
  double mySale = 0.0;
  double total = 0;
  String currentBuy = "";

  Box<CurrencyModel> currncyModel = Hive.box<CurrencyModel>(
    HiveBoxes.currencyModel,
  );
  @override
  void initState() {
    listDish =
        dish.values.where((test) {
          return test.count > 0;
        }).toList();
    total = listDish.fold(
      0.0,
      (previousValue, element) =>
          previousValue +
          element.count *
              (double.tryParse(element.price.split("\$")[0]) ?? 0.0),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          nextFocus: false,
          actions: [
            KeyboardActionsItem(focusNode: discountNode),
            KeyboardActionsItem(focusNode: pointNode),
          ],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 342.w,
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                    top: 10.h,
                    bottom: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order",
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 9.h),
                      ...listDish.map((toElement) {
                        return Row(
                          children: [
                            Container(
                              height: 17.h,
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Text(
                                "x${toElement.count.toString()}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.14.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: Text(
                                  toElement.dishName,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "${toElement.count * (double.tryParse(toElement.price.split("\$")[0]) ?? 0.0)}${Hive.box<CurrencyModel>(HiveBoxes.currencyModel).values.first.currency}",

                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                Container(
                  width: 342.w,
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                    top: 10.h,
                    bottom: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Loyalty system",
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 9.h),
                      SizedBox(
                        height: 24.h,
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/icons/sale.svg"),
                            SizedBox(width: 6.w),
                            Text(
                              "Set a discount",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: TextField(
                                  textAlign: TextAlign.end,
                                  focusNode: discountNode,
                                  controller: discountController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: '',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  cursorColor: Colors.black,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.sp,
                                  ),
                                  onChanged: (val) {},
                                ),
                              ),
                            ),
                            Text(
                              "%",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/icons/point.svg"),
                            SizedBox(width: 6.w),
                            Text(
                              "Deduct points",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: TextField(
                                  textAlign: TextAlign.end,
                                  focusNode: pointNode,
                                  controller: pointController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: '',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  cursorColor: Colors.black,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.sp,
                                  ),
                                  onChanged: (val) {},
                                ),
                              ),
                            ),
                            Text(
                              "p.",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                GestureDetector(
                  onTap: () {
                    double discountedTotal = total;

                    // Применяем процентную скидку (если указана)
                    if (discountController.text.isNotEmpty) {
                      final discountPercent =
                          double.tryParse(discountController.text) ?? 0.0;
                      discountedTotal = total * (1 - discountPercent / 100);
                    }

                    // Вычитаем баллы (если указаны)
                    if (pointController.text.isNotEmpty) {
                      final points =
                          double.tryParse(pointController.text) ?? 0.0;
                      discountedTotal -= points;

                      // Не позволяем итогу быть меньше 0
                      if (discountedTotal < 0) discountedTotal = 0;
                    }

                    setState(() {
                      mySale = discountedTotal;
                    });
                  },
                  child: Container(
                    width: 342.w,
                    height: 49.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      color: Color(0xFF8CBBE5),
                    ),
                    child: Center(
                      child: Text(
                        "Apply",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                Container(
                  width: 342.w,
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                    top: 10.h,
                    bottom: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total",
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF626262),
                            ),
                          ),
                          Spacer(),
                          mySale != 0
                              ? Row(
                                children: [
                                  Text(
                                    "$total${Hive.box<CurrencyModel>(HiveBoxes.currencyModel).values.first.currency}",
                                    style: GoogleFonts.inter(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFF644D),
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Color(0xFFFF644D),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "$mySale\$",
                                    style: GoogleFonts.inter(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF7CCF59),
                                    ),
                                  ),
                                ],
                              )
                              : Text(
                                '$total\$',
                                style: GoogleFonts.inter(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF7CCF59),
                                ),
                              ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset("assets/icons/sale.svg"),
                              SizedBox(width: 5.w),
                              Text(
                                "Discount",
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            mySale == 0 ? "0" : '${total - mySale}\$',
                            style: GoogleFonts.inter(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7CCF59),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 41.h),
                SizedBox(
                  width: 287.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        ["Cash", "Card"].map((toElement) {
                          return GestureDetector(
                            onTap: () {
                              currentBuy = toElement;
                              setState(() {});
                            },
                            child: Container(
                              width: 136.w,
                              height: 48.h,
                              decoration: BoxDecoration(
                                color:
                                    toElement == currentBuy
                                        ? Color(0xFFFF644D)
                                        : Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14.42.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  toElement,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        toElement == currentBuy
                                            ? Colors.white
                                            : Color(0xFFADADAD),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 58.h),
                GestureDetector(
                  onTap: () {
                    if (currentBuy.isNotEmpty) {
                      final box = Hive.box<DishModel>(HiveBoxes.dishBox);

                      for (var i = 0; i < box.length; i++) {
                        final dish = box.getAt(i);
                        if (dish != null) {
                          dish.count = 0;
                          box.putAt(i, dish);
                        }
                      }

                      dishSave.add(
                        DishSaveModel(
                          date: DateTime.now(),
                          total: total,
                          isCash: currentBuy == "Cash" ? true : false,
                        ),
                      );
                      setState(() {
                        listDish = [];
                        total = 0;
                        mySale = 0;
                        currentBuy = "";
                      });
                    }
                  },
                  child: Container(
                    width: 342.w,
                    height: 49.h,
                    decoration: BoxDecoration(
                      color:
                          currentBuy.isEmpty
                              ? Colors.black.withValues(alpha: 0.7)
                              : Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                    ),
                    child: Center(
                      child: Text(
                        "Pay",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 58.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Пример использования:
}
