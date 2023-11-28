import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/components/app_bar_custom.dart';
import 'package:sims_denny/components/custom_outline_button.dart';
import 'package:sims_denny/components/cutom_button.dart';
import 'package:sims_denny/components/text_form.dart';
import 'package:sims_denny/provider/bottom_navigation_bar_provider.dart';
import 'package:sims_denny/provider/user_provider.dart';
import 'package:sims_denny/utils/assets.dart';
import 'package:sims_denny/utils/session.dart';
import 'package:sims_denny/utils/shared.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    emailController.text = user.email ?? "";
    firstNameController.text = user.firstName ?? "";
    lastNameController.text = user.lastName ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    isEdit = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarCustom("Akun"),
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () {
            context.read<UserProvider>().getProfile(context);
            return Future<void>.delayed(const Duration(seconds: 1));
          },
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Consumer<UserProvider>(
              builder: (context, value, child) => ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Shared.changeImageProfile(context, value);
                    },
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
                              image: value.user.profileImage != null &&
                                      value.user.profileImage != "" &&
                                      value.user.profileImage !=
                                          "https://minio.nutech-integrasi.app/take-home-test/null"
                                  ? NetworkImage(value.user.profileImage ?? "")
                                  : AssetImage(Assets.profile) as ImageProvider,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () async {
                                Shared.changeImageProfile(context, value);
                              },
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
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      "${value.user.firstName} ${value.user.lastName}",
                      style: titleTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Email",
                    style: backHeader,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormCustom(
                    "",
                    emailController,
                    const Icon(Icons.alternate_email_outlined),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (!Shared.emailRegExp.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Nama Depan",
                    style: backHeader,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormCustom(
                    "",
                    firstNameController,
                    const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    readOnly: isEdit ? false : true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Nama Belakang",
                    style: backHeader,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormCustom(
                    "",
                    lastNameController,
                    const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    readOnly: isEdit ? false : true,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  isEdit
                      ? CustomButton("Simpan", () async {
                          setState(() {
                            isLoading = true;
                          });
                          value.updateProfile(
                            firstNameController.text,
                            lastNameController.text,
                            context,
                          );
                          setState(() {
                            isLoading = false;
                            isEdit = false;
                          });
                        })
                      : CustomButton("Edit Profile", () async {
                          setState(() {
                            isEdit = true;
                          });
                        }),
                  const SizedBox(
                    height: 30,
                  ),
                  isEdit
                      ? CustomOutlineButton("Batalkan", () async {
                          setState(() {
                            isEdit = false;
                          });
                        })
                      : CustomOutlineButton("Logout", () async {
                          await Session.clearToken();
                          // ignore: use_build_context_synchronously
                          context.read<BottomNavigationBarProvider>().reset();
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(
                            context,
                            '/login',
                          );
                        }),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
