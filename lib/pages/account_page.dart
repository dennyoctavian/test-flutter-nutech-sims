import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/components/app_bar_custom.dart';
import 'package:sims_denny/components/custom_button.dart';
import 'package:sims_denny/components/custom_outline_button.dart';
import 'package:sims_denny/components/text_form.dart';
import 'package:sims_denny/provider/bottom_navigation_bar_provider.dart';
import 'package:sims_denny/provider/profile_provider.dart';
import 'package:sims_denny/utils/assets.dart';
import 'package:sims_denny/utils/auth_navigation_mixin.dart';
import 'package:sims_denny/utils/constants.dart';
import 'package:sims_denny/utils/session.dart';
import 'package:sims_denny/utils/shared.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with AuthNavigationMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileProvider>().user;
    emailController.text = user.email ?? "";
    firstNameController.text = user.firstName ?? "";
    lastNameController.text = user.lastName ?? "";
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> _handleChangeImage(ProfileProvider profileProvider) async {
    final result = await Shared.changeImageProfile(profileProvider);
    if (!mounted || result == null) return;

    if (result.statusCode == ApiConstants.unauthorized) {
      handleUnauthorized(result.statusCode);
      return;
    }
    showSnackBar(context, result.message, isSuccess: result.success);
  }

  Future<void> _handleUpdateProfile(ProfileProvider profileProvider) async {
    setState(() => isLoading = true);

    final result = await profileProvider.updateProfile(
      firstNameController.text,
      lastNameController.text,
    );

    if (!mounted) return;
    setState(() {
      isLoading = false;
      isEdit = false;
    });

    if (result.statusCode == ApiConstants.unauthorized) {
      handleUnauthorized(result.statusCode);
      return;
    }
    showSnackBar(context, result.message, isSuccess: result.success);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarCustom("Akun"),
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () async {
            final statusCode =
                await context.read<ProfileProvider>().getProfile();
            if (!mounted) return;
            handleUnauthorized(statusCode);
          },
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Consumer<ProfileProvider>(
              builder: (context, value, child) => ListView(
                children: [
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => _handleChangeImage(value),
                    child: UnconstrainedBox(
                      child: SizedBox(
                        height: 190,
                        width: 190,
                        child: Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.grey),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _getProfileImage(value.user.profileImage),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () => _handleChangeImage(value),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    )),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      "${value.user.firstName} ${value.user.lastName}",
                      style: titleTextStyle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Email", style: backHeader),
                  const SizedBox(height: 10),
                  TextFormCustom(
                    "",
                    emailController,
                    const Icon(Icons.alternate_email_outlined),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired;
                      } else if (!Shared.emailRegExp.hasMatch(value)) {
                        return AppStrings.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Text("Nama Depan", style: backHeader),
                  const SizedBox(height: 10),
                  TextFormCustom(
                    "",
                    firstNameController,
                    const Icon(Icons.person),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      return null;
                    },
                    readOnly: !isEdit,
                  ),
                  const SizedBox(height: 30),
                  Text("Nama Belakang", style: backHeader),
                  const SizedBox(height: 10),
                  TextFormCustom(
                    "",
                    lastNameController,
                    const Icon(Icons.person),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      return null;
                    },
                    readOnly: !isEdit,
                  ),
                  const SizedBox(height: 50),
                  isEdit
                      ? CustomButton(
                          "Simpan", () => _handleUpdateProfile(value))
                      : CustomButton("Edit Profile", () {
                          setState(() => isEdit = true);
                        }),
                  const SizedBox(height: 30),
                  isEdit
                      ? CustomOutlineButton("Batalkan", () {
                          setState(() => isEdit = false);
                        })
                      : CustomOutlineButton("Logout", () async {
                          await Session.clearToken();
                          if (!mounted) return;
                          context.read<BottomNavigationBarProvider>().reset();
                          Navigator.pushReplacementNamed(context, '/login');
                        }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        )),
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
}
