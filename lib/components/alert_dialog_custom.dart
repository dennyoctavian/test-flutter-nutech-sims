import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/models/information/service.dart';
import 'package:sims_denny/provider/bottom_navigation_bar_provider.dart';
import 'package:sims_denny/provider/user_provider.dart';
import 'package:sims_denny/utils/assets.dart';
import 'package:sims_denny/utils/shared.dart';

Future<void> showConfirmation(BuildContext context,
    {Service? service, int? balanceTopup}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  service != null
                      ? "Beli ${service.serviceName} senilai"
                      : "Anda yakin untuk Top Up sebesar",
                  style: backHeader,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${Shared.formatCurrency.format(service != null ? service.serviceTariff : balanceTopup)} ?",
                  style: titleHeader,
                ),
                TextButton(
                  onPressed: () {
                    if (service != null) {
                      context.read<UserProvider>().payment(service, context);
                    } else {
                      context
                          .read<UserProvider>()
                          .topup(balanceTopup ?? 0, context);
                    }
                  },
                  child: Text(
                    service != null
                        ? "Ya, lanjutkan Bayar"
                        : "Ya, lanjutkan Top Up",
                    style: titleHeader.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Batalkan",
                    style: titleHeader.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}

Future<void> showSuccessOrFailed(BuildContext context,
    {Service? service, int? balanceTopup, bool isSuccess = true}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isSuccess
                    ? Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  service != null
                      ? "Pembayaran ${service.serviceName} sebesar"
                      : "Top Up sebesar",
                  style: backHeader,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${Shared.formatCurrency.format(service != null ? service.serviceTariff : balanceTopup)} ?",
                  style: titleHeader,
                ),
                Text(
                  isSuccess ? "berhasil" : "gagal",
                  style: backHeader,
                ),
                TextButton(
                  onPressed: () {
                    if (service != null) {
                      Navigator.pop(context);
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    context.read<BottomNavigationBarProvider>().reset();
                  },
                  child: Text(
                    "Kembali ke Beranda",
                    style: titleHeader.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
