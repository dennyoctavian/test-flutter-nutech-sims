import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/components/logo.dart';
import 'package:sims_denny/provider/balance_provider.dart';
import 'package:sims_denny/provider/information_provider.dart';
import 'package:sims_denny/provider/profile_provider.dart';
import 'package:sims_denny/utils/assets.dart';
import 'package:sims_denny/utils/auth_navigation_mixin.dart';
import 'package:sims_denny/utils/constants.dart';
import 'package:sims_denny/utils/shared.dart';
import 'package:skeletons/skeletons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AuthNavigationMixin {
  final VisibilityPrice visibility = VisibilityPrice();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      context.read<ProfileProvider>().getProfile(),
      context.read<BalanceProvider>().getBalance(),
      context.read<BannerProvider>().getBanner(),
      context.read<ServicesProvider>().getServices(),
    ]);

    for (final statusCode in results) {
      if (statusCode == ApiConstants.unauthorized) {
        handleUnauthorized(statusCode);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              Consumer<ProfileProvider>(
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
                                    image: _getProfileImage(
                                        value.user.profileImage),
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
                    const SizedBox(height: 30),
                    Text(
                      "Selamat datang,",
                      style: backHeader.copyWith(fontSize: 20),
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
                    const SizedBox(height: 30),
                    _buildBalanceCard(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              Consumer<ServicesProvider>(
                builder: (context, value, child) =>
                    value.status == Status.loading
                        ? _buildServicesLoading(context)
                        : _buildServicesList(context, value),
              ),
              const SizedBox(height: 30),
              Consumer<BannerProvider>(
                builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Temukan promo menarik",
                      style: titleTextStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: value.status == Status.loading
                            ? _buildBannerLoading()
                            : _buildBannerList(context, value),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _getProfileImage(String? profileImage) {
    if (profileImage != null &&
        profileImage.isNotEmpty &&
        profileImage != AppStrings.nullProfileImageUrl) {
      return NetworkImage(profileImage);
    }
    return AssetImage(Assets.profile);
  }

  Widget _buildBalanceCard() {
    return Consumer<BalanceProvider>(
      builder: (context, balanceValue, child) =>
          ValueListenableBuilder<bool>(
        valueListenable: visibility.visible,
        builder: (context, isVisible, child) => Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                const SizedBox(height: 10),
                balanceValue.statusBalance == Status.loading
                    ? SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 20,
                          width: 80,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    : isVisible
                        ? Text(
                            Shared.formatCurrency.format(balanceValue.balance),
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
                              const SizedBox(width: 5),
                              for (int i = 0; i < 7; i++) ...[
                                const Icon(Icons.circle,
                                    color: Colors.white, size: 12),
                                const SizedBox(width: 3),
                              ],
                            ],
                          ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Lihat Saldo",
                      style: normalTextStyle.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        visibility.changeVisibility();
                      },
                      icon: Icon(
                        isVisible
                            ? Icons.visibility_off
                            : Icons.remove_red_eye_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesLoading(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: [
        for (int i = 0; i < 10; i++)
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
                width: (MediaQuery.of(context).size.width - 48 - 40) / 5,
                height: (MediaQuery.of(context).size.width - 48 - 40) / 5),
          ),
      ],
    );
  }

  Widget _buildServicesList(BuildContext context, ServicesProvider value) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: value.services
          .map(
            (e) => InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/payment", arguments: e);
              },
              child: SizedBox(
                width: (MediaQuery.of(context).size.width - 48 - 40) / 5,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Image.network(
                        e.serviceIcon ?? "",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 30),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      (e.serviceCode ?? "").contains("_")
                          ? e.serviceCode?.split("_")[1] ?? ''
                          : e.serviceCode ?? '',
                      style: normalTextStyle.copyWith(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  List<Widget> _buildBannerLoading() {
    return [
      for (int i = 0; i < 3; i++)
        Container(
          margin: const EdgeInsets.only(right: 30),
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 150,
              width: 250,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildBannerList(BuildContext context, BannerProvider value) {
    return value.banners
        .map(
          (e) => Container(
            width: MediaQuery.of(context).size.width - 48 - 100,
            margin: const EdgeInsets.only(right: 30),
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                e.bannerImage ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}

class VisibilityPrice {
  final ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  void changeVisibility() {
    visible.value = !visible.value;
  }
}
