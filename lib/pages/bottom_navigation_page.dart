import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/pages/account_page.dart';
import 'package:sims_denny/pages/home_page.dart';
import 'package:sims_denny/pages/topup_page.dart';
import 'package:sims_denny/pages/transaction_page.dart';
import 'package:sims_denny/provider/bottom_navigation_bar_provider.dart';

class BottomNavigationPage extends StatelessWidget {
  const BottomNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationBarProvider>(
      builder: (context, value, child) => Scaffold(
        body: IndexedStack(
          index: value.currentIndex,
          children: const [
            HomePage(),
            TopUpPage(),
            TransactionPage(),
            AccountPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: value.currentIndex,
          onTap: (index) {
            value.setCurrentIndex(index);
          },
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Top Up',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}
