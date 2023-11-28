import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/components/alert_dialog_custom.dart';
import 'package:sims_denny/components/balance_card.dart';
import 'package:sims_denny/components/cutom_button.dart';
import 'package:sims_denny/components/text_form.dart';
import 'package:sims_denny/models/information/service.dart';
import 'package:sims_denny/provider/user_provider.dart';
import 'package:sims_denny/utils/shared.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController topupController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    topupController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Service;
    topupController.text = topupController.text =
        Shared.formatCurrency.format(args.serviceTariff).replaceAll("Rp ", "");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "PemBayaran",
            style: titleTextStyle.copyWith(color: Colors.black, fontSize: 16),
          ),
          leading: SizedBox(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Kembali",
                  style: normalTextStyle.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          leadingWidth: 120,
        ),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: ListView(
            children: [
              const BalanceCard(),
              Text(
                "Pembayaran",
                style: titleTextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(args.serviceIcon ?? ''),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    (args.serviceCode ?? "").contains("_")
                        ? args.serviceCode?.split("_")[1] ?? ''
                        : args.serviceCode ?? '',
                    style: normalTextStyle.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormCustom(
                "",
                topupController,
                const Icon(
                  Icons.account_balance_wallet_outlined,
                ),
                readOnly: true,
              ),
              const SizedBox(
                height: 30,
              ),
              Consumer<UserProvider>(
                builder: (context, value, child) =>
                    value.statusBalance == Status.loading
                        ? const UnconstrainedBox(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ),
                          )
                        : CustomButton("Bayar", () async {
                            showConfirmation(context, service: args);
                          }),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
