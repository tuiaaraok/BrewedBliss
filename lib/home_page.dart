import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Добавляем для использования Timer

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final GlobalKey<ScaffoldState> keyDrawer = GlobalKey();

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();


  @override
  void initState() {
    super.initState();
    // Обновляем время каждую секунду

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Важно отменить таймер при удалении виджета
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 30.w),
                child: GestureDetector(
                  onTap: () {
                    keyDrawer.currentState!.openDrawer();
                  },
                  child: SvgPicture.asset("assets/icons/settings.svg"),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Используем _currentTime вместо DateTime.now()
            _buildDateTimeDisplay(_currentTime),
            SizedBox(height: 109.h),
            SizedBox(
              width: 342.w,
              child: ElevatedButton(
                onPressed: () {
                  Hive.box("open").putAt(0, !Hive.box("open").values.first);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Hive.box("open").values.first
                          ? const Color(0xFF8CBBE5)
                          : Color(0xFFFF644D),
                  padding: EdgeInsets.symmetric(vertical: 22.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                ),
                child: Text(
                  Hive.box("open").values.first ? 'Open shift' : 'Close shift',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            Image.asset("assets/home.png", width: 324.w, height: 324.w),
          ],
        ),
      ),
    );
  }

  // Изменяем метод для принятия времени в качестве параметра
  Widget _buildDateTimeDisplay(DateTime time) {
    return Center(
      child: Text(
        DateFormat("dd/MM/yyyy HH:mm").format(time),
        style: GoogleFonts.inter(fontSize: 32.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}

String getCurrencyName(String currencySymbol) {
  switch (currencySymbol) {
    case "\$":
      return "Dollar";
    case "€":
      return "Euro";
    case "¥":
      return "Yen";
    case "£":
      return "Pound Sterling";
    case "A\$":
      return "Australian Dollar";
    case "C\$":
      return "Canadian Dollar";
    case "CHF":
      return "Swiss Franc";
    case "¥/CNY":
      return "Chinese Yuan Renminbi";
    case "HK\$":
      return "Hong Kong Dollar";
    case "NZ\$":
      return "New Zealand Dollar";
    case "SEK":
      return "Swedish Krona";
    case "₩":
      return "South Korean Won";
    case "S\$":
      return "Singapore Dollar";
    case "NOK":
      return "Norwegian Krone";
    case "Mex\$":
      return "Mexican Peso";
    case "₹":
      return "Indian Rupee";
    case "₽":
      return "Russian Ruble";
    case "R":
      return "South African Rand";
    case "R\$":
      return "Brazilian Real";
    case "DKK":
      return "Danish Krone";
    case "zł":
      return "Polish Zloty";
    case "₺":
      return "Turkish Lira";
    case "฿":
      return "Thai Baht";
    case "Rp":
      return "Indonesian Rupiah";
    case "Kč":
      return "Czech Koruna";
    case "Ft":
      return "Hungarian Forint";
    case "CLP\$":
      return "Chilean Peso";
    case "₪":
      return "Israeli New Shekel";
    case "﷼":
      return "Saudi Riyal";
    case "₱":
      return "Philippine Peso";
    default:
      return "Dollar"; // По умолчанию
  }
}

String getCurrencySymbol(String currencyName) {
  switch (currencyName) {
    case "Dollar":
      return "\$";
    case "Euro":
      return "€";
    case "Yen":
      return "¥";
    case "Pound Sterling":
      return "£";
    case "Australian Dollar":
      return "A\$";
    case "Canadian Dollar":
      return "C\$";
    case "Swiss Franc":
      return "CHF";
    case "Chinese Yuan Renminbi":
      return "¥";
    case "Hong Kong Dollar":
      return "HK\$";
    case "New Zealand Dollar":
      return "NZ\$";
    case "Swedish Krona":
      return "SEK";
    case "South Korean Won":
      return "₩";
    case "Singapore Dollar":
      return "S\$";
    case "Norwegian Krone":
      return "NOK";
    case "Mexican Peso":
      return "Mex\$";
    case "Indian Rupee":
      return "₹";
    case "Russian Ruble":
      return "₽";
    case "South African Rand":
      return "R";
    case "Brazilian Real":
      return "R\$";
    case "Danish Krone":
      return "DKK";
    case "Polish Zloty":
      return "zł";
    case "Turkish Lira":
      return "₺";
    case "Thai Baht":
      return "฿";
    case "Indonesian Rupiah":
      return "Rp";
    case "Czech Koruna":
      return "Kč";
    case "Hungarian Forint":
      return "Ft";
    case "Chilean Peso":
      return "CLP\$";
    case "Israeli New Shekel":
      return "₪";
    case "Saudi Riyal":
      return "﷼";
    case "Philippine Peso":
      return "₱";
    default:
      return "\$"; // По умолчанию возвращаем доллар
  }
}
