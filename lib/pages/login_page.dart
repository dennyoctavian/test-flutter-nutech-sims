import 'package:flutter/material.dart';
import 'package:sims_denny/components/cutom_button.dart';
import 'package:sims_denny/components/logo.dart';
import 'package:sims_denny/components/text_form.dart';
import 'package:sims_denny/services/member_service.dart';
import 'package:sims_denny/utils/session.dart';
import 'package:sims_denny/utils/shared.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Logo(),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Masuk atau buat akun untuk memulai",
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormCustom(
                  'masukan email anda',
                  emailController,
                  const Icon(Icons.alternate_email_outlined),
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
                TextFormCustom(
                  'masukan password anda',
                  passwordController,
                  const Icon(Icons.lock_outline),
                  isObsure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                isLoading
                    ? const UnconstrainedBox(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        ),
                      )
                    : CustomButton("Masuk", () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          final response = await MemberService().login(
                            emailController.text,
                            passwordController.text,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          if (response?.status == 0) {
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, response?.message ?? "",
                                isSuccess: true);
                            Session.setToken(response?.data?.token ?? '');
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "/",
                              (route) => false,
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, response?.message ?? "");
                          }
                        }
                      }),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "belum punya akun? registrasi",
                      style: normalTextStyle,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text(
                        "di sini",
                        style: linkTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
