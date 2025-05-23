import 'dart:math';

import 'package:cafe/data/currency_model.dart';
import 'package:cafe/data/dish_save_model.dart';
import 'package:cafe/data/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<String> items = ["Day", "Month", "Year", "Period"];
  String currentStatistic = "Day";
  DateTime? startDate;
  DateTime? endDate;

  // Helper function to calculate total earnings based on the selected filter
  double calculateTotalEarnings(String filter) {
    final dishSaveBox = Hive.box<DishSaveModel>(HiveBoxes.dishSaveBox);
    final List<DishSaveModel> allTransactions = dishSaveBox.values.toList();
    double total = 0;

    switch (filter) {
      case "Day":
        total = allTransactions
            .where(
              (transaction) =>
                  transaction.date.year == DateTime.now().year &&
                  transaction.date.month == DateTime.now().month &&
                  transaction.date.day == DateTime.now().day,
            )
            .fold(0, (sum, transaction) => sum + transaction.total);
        break;
      case "Month":
        total = allTransactions
            .where(
              (transaction) =>
                  transaction.date.year == DateTime.now().year &&
                  transaction.date.month == DateTime.now().month,
            )
            .fold(0, (sum, transaction) => sum + transaction.total);
        break;
      case "Year":
        total = allTransactions
            .where(
              (transaction) => transaction.date.year == DateTime.now().year,
            )
            .fold(0, (sum, transaction) => sum + transaction.total);
        break;
      case "Period":
        total = allTransactions
            .where(
              (transaction) =>
                  startDate != null &&
                  endDate != null &&
                  transaction.date.isAfter(
                    startDate!.subtract(Duration(days: 1)),
                  ) &&
                  transaction.date.isBefore(endDate!.add(Duration(days: 1))),
            )
            .fold(0, (sum, transaction) => sum + transaction.total);

        break;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double allTimeEarnings = Hive.box<DishSaveModel>(
      HiveBoxes.dishSaveBox,
    ).values.fold(0.0, (sum, item) => sum + item.total);
    double filteredEarnings = calculateTotalEarnings(currentStatistic);

    // Calculate cash and card transaction counts for the selected filter
    final dishSaveBox = Hive.box<DishSaveModel>(HiveBoxes.dishSaveBox);
    final List<DishSaveModel> allTransactions = dishSaveBox.values.toList();
    int cashTransactions = 0;
    int cardTransactions = 0;

    switch (currentStatistic) {
      case "Day":
        cashTransactions =
            allTransactions
                .where(
                  (transaction) =>
                      transaction.date.year == DateTime.now().year &&
                      transaction.date.month == DateTime.now().month &&
                      transaction.date.day == DateTime.now().day &&
                      transaction.isCash,
                )
                .length;
        cardTransactions =
            allTransactions
                .where(
                  (transaction) =>
                      transaction.date.year == DateTime.now().year &&
                      transaction.date.month == DateTime.now().month &&
                      transaction.date.day == DateTime.now().day &&
                      !transaction.isCash,
                )
                .length;
        break;
      case "Month":
        cashTransactions =
            allTransactions
                .where(
                  (transaction) =>
                      transaction.date.year == DateTime.now().year &&
                      transaction.date.month == DateTime.now().month &&
                      transaction.isCash,
                )
                .length;
        cardTransactions =
            allTransactions
                .where(
                  (transaction) =>
                      transaction.date.year == DateTime.now().year &&
                      transaction.date.month == DateTime.now().month &&
                      !transaction.isCash,
                )
                .length;
        break;
      case "Year":
        cashTransactions =
            allTransactions
                .where(
                  (transaction) =>
                      transaction.date.year == DateTime.now().year &&
                      transaction.isCash,
                )
                .length;
        cardTransactions =
            allTransactions
                .where(
                  (transaction) =>
                      transaction.date.year == DateTime.now().year &&
                      !transaction.isCash,
                )
                .length;
        break;
      case "Period":
        cashTransactions =
            allTransactions
                .where(
                  (transaction) =>
                      startDate != null &&
                      endDate != null &&
                      transaction.date.isAfter(
                        startDate!.subtract(Duration(days: 1)),
                      ) &&
                      transaction.date.isBefore(
                        endDate!.add(Duration(days: 1)),
                      ) &&
                      transaction.isCash,
                )
                .length;
        cardTransactions =
            allTransactions
                .where(
                  (transaction) =>
                      startDate != null &&
                      endDate != null &&
                      transaction.date.isAfter(
                        startDate!.subtract(Duration(days: 1)),
                      ) &&
                      transaction.date.isBefore(
                        endDate!.add(Duration(days: 1)),
                      ) &&
                      !transaction.isCash,
                )
                .length;

        break;
    }

    int totalTransactions = cashTransactions + cardTransactions;

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentStatistic = items[index];
                      });
                      if (currentStatistic == "Period") {
                        _showDateRangePicker();
                      }
                    },
                    child: Center(
                      child: Container(
                        height:
                            currentStatistic == items[index]
                                ? 36.37.h
                                : 32.87.h,
                        padding:
                            currentStatistic == items[index]
                                ? EdgeInsets.symmetric(horizontal: 18.36.w)
                                : EdgeInsets.symmetric(horizontal: 16.87.w),
                        margin: EdgeInsets.symmetric(horizontal: 7.35.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color:
                              currentStatistic == items[index]
                                  ? const Color(0xFF8CBBE5)
                                  : const Color(
                                    0xFF8CBBE5,
                                  ).withValues(alpha: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            items[index],
                            style: GoogleFonts.inter(
                              fontSize:
                                  currentStatistic == items[index]
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
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h, top: 50.h),
              child: FinancialStats(
                startDate: startDate,
                endDate: endDate,
                allEarnings: allTimeEarnings,
                filterEarnings: filteredEarnings,
                filter: currentStatistic,
              ),
            ),
            SizedBox(
              width: 309.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 188.w,
                    height: 188.h,
                    child: CustomPaint(
                      painter: PieChartPainter(
                        cash: cashTransactions.toDouble(),
                        card: cardTransactions.toDouble(),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 90.w,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "$totalTransactions\n",
                              style: GoogleFonts.inter(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "Payments",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 188.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 10.h,
                              color: Color(0xFF8CBBE5),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Card $cardTransactions",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 10.h,
                              color: Color(0xFFFF644D),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Cash $cashTransactions",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white, // Фон за пределами диалога
            primaryColor: const Color(0xFF8CBBE5),
            hintColor: const Color(0xFF8CBBE5),
            colorScheme: const ColorScheme.light(primary: Color(0xFF8CBBE5)),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.grey[100]),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }
}

class PieChartPainter extends CustomPainter {
  final double cash;
  final double card;

  PieChartPainter({required this.cash, required this.card});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 15;
    final total = cash + card;

    double startAngle = -pi / 2;

    if (total == 0) {
      // Handle the case where there are no transactions.
      // For example, you could draw a gray circle.
      final paint =
          Paint()
            ..color = Colors.grey
            ..strokeWidth = 30
            ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * pi, // Full circle
        false,
        paint,
      );
      return; // Exit the paint method to prevent errors.
    }

    // Cash
    final cashSweepAngle = 2 * pi * (cash / total);
    final cashPaint =
        Paint()
          ..color = Color(0xFFFF644D)
          ..strokeWidth = 30
          ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      cashSweepAngle,
      false,
      cashPaint,
    );

    startAngle += cashSweepAngle;

    // Card
    final cardSweepAngle = 2 * pi * (card / total);
    final cardPaint =
        Paint()
          ..color = Color(0xFF8CBBE5)
          ..strokeWidth = 30
          ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      cardSweepAngle,
      false,
      cardPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is PieChartPainter) {
      return cash != oldDelegate.cash || card != oldDelegate.card;
    }
    return true;
  }
}

class FinancialStats extends StatelessWidget {
  const FinancialStats({
    super.key,
    required this.allEarnings,
    required this.filterEarnings,
    required this.filter,
    this.startDate,
    this.endDate,
  });

  final String filter;
  final double allEarnings;
  final double filterEarnings;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364.w,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 32.h, bottom: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 312.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow(
              filter == "Day"
                  ? "Today"
                  : filter == "Month"
                  ? "This Month"
                  : filter == "Year"
                  ? "This Year"
                  : filter == "Period"
                  ? (startDate != null && endDate != null
                      ? "From ${DateFormat('d.MM.yy').format(startDate!)} To ${DateFormat('d.MM.yy').format(endDate!)}"
                      : "Select Date Range")
                  : filter,

              "${NumberFormat("#,##0.00", "en_US").format(filterEarnings)}${Hive.box<CurrencyModel>(HiveBoxes.currencyModel).values.first.currency}",
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Stack(
                children: [
                  Container(
                    width: 312.w,
                    height: 9.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                    ),
                  ),
                  Container(
                    width:
                        allEarnings == 0
                            ? 0
                            : (312.w * filterEarnings) / allEarnings,
                    height: 9.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF8CBBE5),
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                    ),
                  ),
                ],
              ),
            ),
            _buildStatRow(
              "For all time",
              "${NumberFormat("#,##0.00", "en_US").format(allEarnings)}${Hive.box<CurrencyModel>(HiveBoxes.currencyModel).values.first.currency}",
              size: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value, {
    FontWeight fontWeight = FontWeight.w600,
    double size = 20,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: size * 1.sp,
              fontWeight: fontWeight,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: size * 1.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF7CCF59),
          ),
        ),
      ],
    );
  }
}
