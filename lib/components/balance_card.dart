import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/provider/user_provider.dart';
import 'package:sims_denny/utils/shared.dart';
import 'package:skeletons/skeletons.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Consumer<UserProvider>(
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Saldo anda",
                  style: titleTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                value.statusBalance == Status.loading
                    ? SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 20,
                          width: 80,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    : Text(
                        Shared.formatCurrency.format(value.balance),
                        style: titleTextStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
