import 'dart:math';

import 'package:cafe/data/category_model.dart';
import 'package:cafe/data/currency_model.dart';
import 'package:cafe/data/dish_model.dart';
import 'package:cafe/data/hive_boxes.dart';
import 'package:cafe/my_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String currerntCategory = "";
  HomePageWidget currentHomeState = HomePageWidget.home;
  Box<DishModel> saveDish = Hive.box<DishModel>(HiveBoxes.dishBox);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable:
                      Hive.box<CategoryModel>(
                        HiveBoxes.categoryBox,
                      ).listenable(),
                  builder: (context, Box<CategoryModel> box, _) {
                    return SizedBox(
                      height: 50.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: box.values.length + 1,
                        itemBuilder: (context, index) {
                          if (index == box.values.length) {
                            return Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 7.35.w,
                                ),
                                width: 38.73.w,
                                height: 32.87.h,
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFF8CBBE5,
                                  ).withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7.35.r),
                                  ),
                                ),
                                child: _buildDropdown(),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (currerntCategory ==
                                    box.values.elementAt(index).categoryName) {
                                  currerntCategory = "";
                                } else {
                                  currerntCategory =
                                      box.values.elementAt(index).categoryName;
                                }
                              });
                            },
                            child: Center(
                              child: Container(
                                height:
                                    currerntCategory ==
                                            box.values
                                                .elementAt(index)
                                                .categoryName
                                        ? 36.37.h
                                        : 32.87.h,
                                padding:
                                    currerntCategory ==
                                            box.values
                                                .elementAt(index)
                                                .categoryName
                                        ? EdgeInsets.symmetric(
                                          horizontal: 18.36.w,
                                        )
                                        : EdgeInsets.symmetric(
                                          horizontal: 16.87.w,
                                        ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 7.35.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color:
                                      currerntCategory ==
                                              box.values
                                                  .elementAt(index)
                                                  .categoryName
                                          ? const Color(0xFF8CBBE5)
                                          : const Color(
                                            0xFF8CBBE5,
                                          ).withValues(alpha: 0.5),
                                ),
                                child: Center(
                                  child: Text(
                                    box.values.elementAt(index).categoryName,
                                    style: GoogleFonts.inter(
                                      fontSize:
                                          currerntCategory ==
                                                  box.values
                                                      .elementAt(index)
                                                      .categoryName
                                              ? 14.69.sp
                                              : 13.49.sp,
                                      height: 1,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 43.h),
                ValueListenableBuilder(
                  valueListenable:
                      Hive.box<DishModel>(HiveBoxes.dishBox).listenable(),
                  builder: (context, Box<DishModel> box, _) {
                    final places =
                        box.values.where((item) {
                          if (currerntCategory.isEmpty) {
                            return true;
                          }
                          return item.category.toLowerCase() ==
                              currerntCategory.toLowerCase();
                        }).toList();
                    return Hive.box<CategoryModel>(
                          HiveBoxes.categoryBox,
                        ).values.isEmpty
                        ? Column(
                          children: [
                            Image.asset(
                              "assets/home.png",
                              width: 324.w,
                              height: 324.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                "Create your first menu",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                currentHomeState = HomePageWidget.addCategory;
                                setState(() {});
                              },
                              child: Container(
                                width: 209.w,
                                height: 41.56.h,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF644D),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7.33.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "+Add a Category",
                                    style: TextStyle(
                                      fontSize: 12.22.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : SizedBox(
                          width: 355.w,
                          child: Wrap(
                            spacing: 33.w,
                            runSpacing: 30.h,
                            children:
                                places.map((toElement) {
                                  return Container(
                                    width: 161.w,
                                    alignment: Alignment.topCenter,
                                    padding: EdgeInsets.only(
                                      left: 12.w,
                                      right: 12.w,
                                      bottom: 10.35.h,
                                      top: 24.65.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF8CBBE5),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.r),
                                      ),
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 83.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.r),
                                              ),
                                              image: DecorationImage(
                                                image: MemoryImage(
                                                  toElement.image!,
                                                ),
                                                fit: BoxFit.fill,
                                              ),

                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      toElement.dishName,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 17.18.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      toElement.price +
                                                          Hive.box<
                                                            CurrencyModel
                                                          >(
                                                            HiveBoxes
                                                                .currencyModel,
                                                          ).values.first.currency,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 15.59.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (toElement.count == 0) ...[
                                                GestureDetector(
                                                  onTap: () {
                                                    toElement.count++;
                                                    final index = saveDish
                                                        .values
                                                        .toList()
                                                        .indexWhere(
                                                          (d) =>
                                                              d.dishName ==
                                                                  toElement
                                                                      .dishName &&
                                                              d.category ==
                                                                  toElement
                                                                      .category &&
                                                              d.price ==
                                                                  toElement
                                                                      .price,
                                                        );
                                                    saveDish.putAt(
                                                      index,
                                                      toElement,
                                                    );
                                                    setState(() {});
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/icons/add.svg",
                                                  ),
                                                ),
                                              ] else ...[
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        toElement.count--;
                                                        final index = saveDish
                                                            .values
                                                            .toList()
                                                            .indexWhere(
                                                              (d) =>
                                                                  d.dishName ==
                                                                      toElement
                                                                          .dishName &&
                                                                  d.category ==
                                                                      toElement
                                                                          .category &&
                                                                  d.price ==
                                                                      toElement
                                                                          .price,
                                                            );
                                                        saveDish.putAt(
                                                          index,
                                                          toElement,
                                                        );
                                                        setState(() {});
                                                      },
                                                      child: Text(
                                                        "- ",
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontSize:
                                                                  15.59.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                    ),
                                                    Text(
                                                      toElement.count
                                                          .toString(),
                                                      style: GoogleFonts.inter(
                                                        fontSize: 15.59.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        toElement.count++;
                                                        final index = saveDish
                                                            .values
                                                            .toList()
                                                            .indexWhere(
                                                              (d) =>
                                                                  d.dishName ==
                                                                      toElement
                                                                          .dishName &&
                                                                  d.category ==
                                                                      toElement
                                                                          .category &&
                                                                  d.price ==
                                                                      toElement
                                                                          .price,
                                                            );
                                                        saveDish.putAt(
                                                          index,
                                                          toElement,
                                                        );
                                                        setState(() {});
                                                      },
                                                      child: Text(
                                                        " +",
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontSize:
                                                                  15.59.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        );
                  },
                ),
                // Добавьте остальной контент страницы здесь
              ],
            ),
          ),
          homePageWidgetState(currentHomeState),
        ],
      ),
    );
  }

  Widget homePageWidgetState(HomePageWidget state) {
    switch (state) {
      case HomePageWidget.home:
        return SizedBox();
      case HomePageWidget.addCategory:
        return AddCategory(
          onStateChanged: (newState) {
            setState(() {
              currentHomeState = newState;
            });
          },
        );
      case HomePageWidget.addDish:
        return AddDishWidget(
          onStateChanged: (newState) {
            setState(() {
              currentHomeState = newState;
            });
          },
        );
    }
  }

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        onChanged: (value) {
          if (value == "Add dish") {
            currentHomeState = HomePageWidget.addDish;
          } else if (value == "Add category") {
            currentHomeState = HomePageWidget.addCategory;
          } else {
            currentHomeState = HomePageWidget.home;
          }
          setState(() {});
        },
        customButton: Center(child: SvgPicture.asset("assets/icons/more.svg")),

        items: [
          DropdownMenuItem(
            value: "Add dish",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 5.w),
                  Text(
                    "Add dish",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DropdownMenuItem(
            value: "Enter",
            child: Divider(height: 1.h, color: Color(0xFF959595)),
          ),
          DropdownMenuItem(
            value: "Add category",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 5.w),
                  Text(
                    "Add category",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        dropdownStyleData: DropdownStyleData(
          maxHeight: 191.h,
          width: 159.w,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: const Color(0xFFE9E9E9),
          ),
          offset: Offset(-130.w, -10),
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.all(0),
          customHeights: [31.h, 1.h, 31.h],
        ),
      ),
    );
  }
}

class MenuElem {
  bool isOpen;
  String selectedElem;
  List<String> listElements;

  MenuElem({
    required this.isOpen,
    required this.selectedElem,
    required this.listElements,
  });
}

enum HomePageWidget { home, addDish, addCategory }

class AddCategory extends StatefulWidget {
  const AddCategory({super.key, required this.onStateChanged});
  final Function(HomePageWidget) onStateChanged;
  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  Box<CategoryModel> categoryBox = Hive.box<CategoryModel>(
    HiveBoxes.categoryBox,
  );

  TextEditingController categoryNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 150.h),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 288.w,
          padding: EdgeInsets.symmetric(vertical: 24.h),
          decoration: BoxDecoration(
            color: Color(0xFFF0F0F0),
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextField.textFieldForm(
                "Category name",
                242.w,
                categoryNameController,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: 62.h),
              SizedBox(
                width: 242.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.onStateChanged(HomePageWidget.home);
                      },
                      child: Container(
                        width: 116.w,
                        height: 41.h,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF644D),
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.inter(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (categoryNameController.text.isNotEmpty) {
                          categoryBox.add(
                            CategoryModel(
                              categoryName: categoryNameController.text,
                            ),
                          );
                          widget.onStateChanged(HomePageWidget.home);
                        }
                      },
                      child: Container(
                        width: 116.w,
                        height: 41.h,
                        decoration: BoxDecoration(
                          color:
                              categoryNameController.text.isNotEmpty
                                  ? Color(0xFF8CBBE5)
                                  : Color(0xFF8CBBE5).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        ),
                        child: Center(
                          child: Text(
                            "Save",
                            style: GoogleFonts.inter(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddDishWidget extends StatefulWidget {
  const AddDishWidget({super.key, required this.onStateChanged});

  final Function(HomePageWidget) onStateChanged;
  @override
  State<AddDishWidget> createState() => _AddDishWidgetState();
}

class _AddDishWidgetState extends State<AddDishWidget> {
  Box<DishModel> dishBox = Hive.box<DishModel>(HiveBoxes.dishBox);
  final MenuElem selectCategoryElem = MenuElem(
    isOpen: false,
    selectedElem: "",
    listElements: [],
  );
  Uint8List? _image;
  Future getLostData() async {
    XFile? picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker == null) return;
    List<int> imageBytes = await picker.readAsBytes();
    _image = Uint8List.fromList(imageBytes);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectCategoryElem.listElements =
        Hive.box<CategoryModel>(HiveBoxes.categoryBox).values.map((toElement) {
          return toElement.categoryName;
        }).toList();
  }

  bool isValid() {
    if (_image != null &&
        dishNameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectCategoryElem.selectedElem.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  TextEditingController dishNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  FocusNode priceNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        nextFocus: false,
        actions: [KeyboardActionsItem(focusNode: priceNode)],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 150.h),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 288.w,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.all(Radius.circular(16.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField.textFieldForm(
                  "Dish name",
                  242.w,
                  dishNameController,
                  onChanged: (p0) {
                    setState(() {});
                  },
                ),
                SizedBox(height: 14.h),
                MyTextField.textFieldForm(
                  "Price",
                  242.w,
                  priceController,
                  keyboard: TextInputType.numberWithOptions(decimal: true),
                  myNode: priceNode,
                  onChanged: (p0) {
                    setState(() {});
                  },
                ),
                SizedBox(height: 14.h),
                _buildDropdownSection(
                  menu: selectCategoryElem,
                  title: "Category",
                ),
                SizedBox(height: 30.h),
                if (_image == null) ...[
                  SizedBox(
                    width: 242.w,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          getLostData();
                        },
                        child: Text(
                          "+Add photo",
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0087FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 137.w,
                    height: 83.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.r)),
                      image: DecorationImage(
                        image: MemoryImage(_image!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 30.h),
                SizedBox(
                  width: 242.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.onStateChanged(HomePageWidget.home);
                        },
                        child: Container(
                          width: 116.w,
                          height: 41.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF644D),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.inter(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isValid()) {
                            dishBox.add(
                              DishModel(
                                dishName: dishNameController.text,
                                price: priceController.text,
                                category: selectCategoryElem.selectedElem,
                                image: _image,
                              ),
                            );
                            widget.onStateChanged(HomePageWidget.home);
                          }
                        },
                        child: Container(
                          width: 116.w,
                          height: 41.h,
                          decoration: BoxDecoration(
                            color:
                                isValid()
                                    ? Color(0xFF8CBBE5)
                                    : Color(0xFF8CBBE5).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Save",
                              style: GoogleFonts.inter(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSection({
    required String title,
    required MenuElem menu,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 18.sp,

            fontWeight: FontWeight.w400,
          ),
        ),
        _buildDropdownCategory(menu: menu, controller: controller),
      ],
    );
  }

  Widget _buildDropdownCategory({
    required MenuElem menu,
    TextEditingController? controller,
  }) {
    return Container(
      height: 43.h,
      width: 242.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          onChanged: (value) {
            setState(() {
              if (controller != null) {
                controller.text = value.toString();
              }
              menu.selectedElem = value.toString();
            });
          },
          onMenuStateChange: (isOpen) {
            setState(() {
              menu.isOpen = isOpen;
            });
          },
          customButton: Row(
            children: [
              Expanded(
                child:
                    controller != null
                        ? TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: '',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 18.sp,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                          ),
                        )
                        : Text(
                          menu.selectedElem,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
              ),

              menu.isOpen
                  ? Transform.rotate(
                    angle: pi,
                    child: SvgPicture.asset("assets/icons/arrow-up.svg"),
                  )
                  : SvgPicture.asset("assets/icons/arrow-up.svg"),
            ],
          ),
          items:
              menu.listElements.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: SizedBox(
                    width: 242.w,
                    height: 50.h,
                    child: Center(
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ),
                  ),
                );
              }).toList(),
          dropdownStyleData: DropdownStyleData(
            width: 242.w,
            maxHeight: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            offset: Offset(-15.w, 0),
          ),
          menuItemStyleData: MenuItemStyleData(
            customHeights: List.filled(menu.listElements.length, 50.h),
            padding: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
          ),
        ),
      ),
    );
  }
}
