import 'package:flutter/material.dart';
import 'package:sims_denny/utils/shared.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function? onTap;
  const CustomButton(this.title, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.red[50],
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        animationDuration: const Duration(seconds: 1),
        fixedSize: const Size(double.infinity, 50),
      ),
      onPressed: onTap != null
          ? () {
              onTap!();
            }
          : null,
      child: Text(
        title,
        style: normalTextStyle.copyWith(color: Colors.white),
      ),
    );
  }
}
