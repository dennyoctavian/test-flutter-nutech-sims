import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/components/alert_dialog_custom.dart';
import 'package:sims_denny/components/app_bar_custom.dart';
import 'package:sims_denny/components/balance_card.dart';
import 'package:sims_denny/components/cutom_button.dart';
import 'package:sims_denny/components/text_form.dart';
import 'package:sims_denny/provider/user_provider.dart';
import 'package:sims_denny/utils/shared.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController topupController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    topupController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarCustom("Top Up"),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: RefreshIndicator(
            onRefresh: () {
              context.read<UserProvider>().getBalance(context);
              return Future<void>.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              children: [
                const BalanceCard(),
                Text(
                  "Silakan masukan",
                  style: titleTextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "nominal Top Up",
                  style: titleTextStyle.copyWith(color: Colors.black),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: TextFormCustom(
                    "masukan nominimal Top Up",
                    topupController,
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                    formatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(r'^0*'),
                      ),
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyTextInputFormatter(
                        locale: "id_ID",
                        symbol: '',
                        decimalDigits: 0,
                      )
                    ],
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      setState(() {});
                      return null;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      int amount = int.tryParse(value.replaceAll(".", "")) ?? 0;
                      if (amount < 10000) {
                        return 'Minimal Top Up Rp 10.000';
                      }
                      if (amount > 1000000) {
                        return 'Maksimal Top Up Rp 1.000.000';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    10000,
                    20000,
                    50000,
                    100000,
                    250000,
                    500000,
                  ]
                      .map((e) => GestureDetector(
                            onTap: () {
                              topupController.text = Shared.formatCurrency
                                  .format(e)
                                  .replaceAll("Rp ", "");
                              setState(() {});
                            },
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width - 68) / 3,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                child: Text(
                                  Shared.formatCurrency.format(e),
                                  style: titleTextStyle.copyWith(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(
                  height: 80,
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
                          : CustomButton(
                              "Top Up",
                              topupController.text != ""
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        int totalAmount = int.tryParse(
                                                topupController.text
                                                    .replaceAll(".", "")) ??
                                            0;
                                        showConfirmation(context,
                                            balanceTopup: totalAmount);
                                      }
                                    }
                                  : null),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
