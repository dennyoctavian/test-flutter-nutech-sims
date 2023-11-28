import 'package:flutter/material.dart';
import 'package:sims_denny/utils/shared.dart';

class CustomOutlineButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const CustomOutlineButton(this.title, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        side: const BorderSide(
          width: 1,
          color: Colors.red,
        ),
        animationDuration: const Duration(seconds: 1),
        fixedSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: normalTextStyle.copyWith(color: Colors.red),
      ),
    );
  }
}
