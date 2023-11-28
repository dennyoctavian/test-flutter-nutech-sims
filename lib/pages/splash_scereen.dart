import 'package:flutter/material.dart';
import 'package:sims_denny/utils/assets.dart';
import 'package:sims_denny/utils/shared.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Assets.logo,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "SIMS PPBOB",
              style: logoTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Denny Octavian",
              style: normalTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
