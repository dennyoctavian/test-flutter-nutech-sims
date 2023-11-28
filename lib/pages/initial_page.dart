import 'package:flutter/material.dart';
import 'package:sims_denny/pages/bottom_navigation_page.dart';
import 'package:sims_denny/pages/login_page.dart';
import 'package:sims_denny/pages/splash_scereen.dart';
import 'package:sims_denny/utils/session.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Session.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return const BottomNavigationPage();
            } else {
              return const LoginPage();
            }
          }
          return const SplashScreen();
        });
  }
}
