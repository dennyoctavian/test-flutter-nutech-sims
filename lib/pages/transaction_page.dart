import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/components/app_bar_custom.dart';
import 'package:sims_denny/components/balance_card.dart';
import 'package:sims_denny/provider/transaction_provider.dart';
import 'package:sims_denny/provider/user_provider.dart';
import 'package:sims_denny/utils/shared.dart';
import 'package:skeletons/skeletons.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionProvider>().getTransaction(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarCustom("Transaksi"),
        body: Container(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: RefreshIndicator(
            onRefresh: () {
              context.read<UserProvider>().getBalance(context);
              context.read<TransactionProvider>().getTransaction(context);
              return Future<void>.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              children: [
                const BalanceCard(),
                Text(
                  "Transaksi",
                  style: titleTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<TransactionProvider>(
                  builder: (context, value, child) => Column(
                    children: value.status == Status.loading
                        ? [
                            for (int i = 0; i < 3; i++) ...[
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: SkeletonLine(
                                  style: SkeletonLineStyle(
                                    height: 75,
                                    width: double.infinity,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            ]
                          ]
                        : value.transaction.isEmpty
                            ? [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Maaf tidak ada histori transaksi saat ini",
                                  style: normalTextStyle,
                                )
                              ]
                            : value.transaction
                                    .map((e) => Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          padding: const EdgeInsets.all(10),
                                          height: 85,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${e.transactionType == "PAYMENT" ? "-" : "+"} ${Shared.formatCurrency.format(e.totalAmount)}",
                                                      style: normalTextStyle
                                                          .copyWith(
                                                        color:
                                                            e.transactionType ==
                                                                    "PAYMENT"
                                                                ? Colors.red
                                                                : Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                        Shared.formatDate(
                                                              DateTime.tryParse(
                                                                      e.createdOn ??
                                                                          "") ??
                                                                  DateTime
                                                                      .now(),
                                                            ) +
                                                            ' WIB',
                                                        style: normalTextStyle
                                                            .copyWith(
                                                          color: Colors.grey,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(e.description ?? ""),
                                            ],
                                          ),
                                        ))
                                    .toList() +
                                (value.status == Status.loadingMore
                                    ? [
                                        for (int i = 0; i < 3; i++) ...[
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            child: SkeletonLine(
                                              style: SkeletonLineStyle(
                                                height: 75,
                                                width: double.infinity,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          )
                                        ]
                                      ]
                                    : []),
                  ),
                ),
                Consumer<TransactionProvider>(
                  builder: (context, value, child) =>
                      value.status == Status.loading ||
                              value.status == Status.loadingMore
                          ? const SizedBox()
                          : value.hasNextPage
                              ? TextButton(
                                  onPressed: () {
                                    context
                                        .read<TransactionProvider>()
                                        .loadMoreTransaction(context);
                                  },
                                  child: const Text(
                                    "Show More",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              : const SizedBox(),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
