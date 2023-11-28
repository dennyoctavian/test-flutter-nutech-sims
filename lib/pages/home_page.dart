import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/components/logo.dart';
import 'package:sims_denny/provider/information_provider.dart';
import 'package:sims_denny/provider/user_provider.dart';
import 'package:sims_denny/utils/assets.dart';
import 'package:sims_denny/utils/shared.dart';
import 'package:skeletons/skeletons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VisibiltyPrice visibility = VisibiltyPrice();
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().getProfile(context);
    context.read<UserProvider>().getBalance(context);
    context.read<BannerProvider>().getBanner(context);
    context.read<ServicesProvider>().getServices(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<UserProvider>().getProfile(context);
            context.read<UserProvider>().getBalance(context);
            context.read<BannerProvider>().getBanner(context);
            context.read<ServicesProvider>().getServices(context);
            return Future<void>.delayed(const Duration(seconds: 1));
          },
          child: ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              Consumer<UserProvider>(
                builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Logo(),
                        value.status == Status.loading
                            ? const SkeletonAvatar(
                                style:
                                    SkeletonAvatarStyle(width: 30, height: 30))
                            : Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: value.user.profileImage != null &&
                                            value.user.profileImage != "" &&
                                            value.user.profileImage !=
                                                "https://minio.nutech-integrasi.app/take-home-test/null"
                                        ? NetworkImage(
                                            value.user.profileImage ?? "")
                                        : AssetImage(Assets.profile)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Selamat datang,",
                      style: backHeader.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    value.status == Status.loading
                        ? SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 20,
                              width: 200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        : Text(
                            "${value.user.firstName ?? ''} ${value.user.lastName ?? ''}",
                            style: titleTextStyle,
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: visibility.visible,
                      builder: (context, newValue, child) => Container(
                        height: 180,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Padding(
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
                                  : newValue
                                      ? Text(
                                          Shared.formatCurrency
                                              .format(value.balance),
                                          style: titleTextStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              "Rp",
                                              style: titleTextStyle.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            for (int i = 0; i < 7; i++) ...[
                                              const Icon(
                                                Icons.circle,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              )
                                            ],
                                          ],
                                        ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Lihat Saldo",
                                    style: normalTextStyle.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  newValue
                                      ? IconButton(
                                          onPressed: () {
                                            visibility.changeVisibility();
                                          },
                                          icon: const Icon(
                                            Icons.visibility_off,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            visibility.changeVisibility();
                                          },
                                          icon: const Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Consumer<ServicesProvider>(
                builder: (context, value, child) => value.status ==
                        Status.loading
                    ? Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          for (int i = 0; i < 10; i++) ...[
                            SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                  width: (MediaQuery.of(context).size.width -
                                          48 -
                                          40) /
                                      5,
                                  height: (MediaQuery.of(context).size.width -
                                          48 -
                                          40) /
                                      5),
                            ),
                          ],
                        ],
                      )
                    : Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: value.services
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/payment",
                                    arguments: e,
                                  );
                                },
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width -
                                          48 -
                                          40) /
                                      5,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              e.serviceIcon ?? "",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        (e.serviceCode ?? "").contains("_")
                                            ? e.serviceCode?.split("_")[1] ?? ''
                                            : e.serviceCode ?? '',
                                        style: normalTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
              const SizedBox(
                height: 30,
              ),
              Consumer<BannerProvider>(
                builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Temukan promo menarik",
                      style: titleTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: value.status == Status.loading
                            ? [
                                for (int i = 0; i < 3; i++) ...[
                                  Container(
                                    margin: const EdgeInsets.only(right: 30),
                                    child: SkeletonLine(
                                      style: SkeletonLineStyle(
                                        height: 150,
                                        width: 250,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                ]
                              ]
                            : value.banners
                                .map(
                                  (e) => Container(
                                    width: MediaQuery.of(context).size.width -
                                        48 -
                                        100,
                                    margin: const EdgeInsets.only(right: 30),
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          e.bannerImage ?? "",
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VisibiltyPrice {
  final ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  void changeVisibility() {
    visible.value = !visible.value;
  }
}
