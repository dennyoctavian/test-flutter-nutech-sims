import 'package:flutter/material.dart';
import 'package:sims_denny/utils/assets.dart';
import 'package:sims_denny/utils/shared.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 30,
          width: 30,
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
          width: 5,
        ),
        Text(
          "SIMS PPBOB",
          style: logoTextStyle,
        )
      ],
    );
  }
}
