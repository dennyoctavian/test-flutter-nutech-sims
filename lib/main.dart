import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/pages/account_page.dart';
import 'package:sims_denny/pages/home_page.dart';
import 'package:sims_denny/pages/initial_page.dart';
import 'package:sims_denny/pages/login_page.dart';
import 'package:sims_denny/pages/payment_page.dart';
import 'package:sims_denny/pages/register_page.dart';
import 'package:sims_denny/pages/topup_page.dart';
import 'package:sims_denny/pages/transaction_page.dart';
import 'package:sims_denny/provider/bottom_navigation_bar_provider.dart';
import 'package:sims_denny/provider/information_provider.dart';
import 'package:sims_denny/provider/transaction_provider.dart';
import 'package:sims_denny/provider/user_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  await initializeDateFormatting("id_ID");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BannerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ServicesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavigationBarProvider(),
        ),
      ],
      child: MaterialApp(
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => const InitialPage(),
          "/home": (context) => const HomePage(),
          "/login": (context) => const LoginPage(),
          "/topup": (context) => const TopUpPage(),
          "/payment": (context) => const PaymentPage(),
          "/account": (context) => const AccountPage(),
          "/transaction": (context) => const TransactionPage(),
          "/register": (context) => const RegisterPage(),
        },
      ),
    );
  }
}
