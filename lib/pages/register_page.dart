import 'package:flutter/material.dart';
import 'package:sims_denny/components/cutom_button.dart';
import 'package:sims_denny/components/logo.dart';
import 'package:sims_denny/components/text_form.dart';
import 'package:sims_denny/models/request_body/register_body.dart';
import 'package:sims_denny/services/member_service.dart';
import 'package:sims_denny/utils/shared.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirPasswordController =
      TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirPasswordController.dispose();
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
                  "Lengkapi data untuk membuat akun",
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
                  'nama depan',
                  firstNameController,
                  const Icon(Icons.person),
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
                TextFormCustom(
                  'nama belakang',
                  lastNameController,
                  const Icon(Icons.person),
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
                TextFormCustom(
                  'buat password',
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
                TextFormCustom(
                  'konfirmasi password',
                  confirPasswordController,
                  const Icon(Icons.lock_outline),
                  isObsure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (passwordController.text != value) {
                      return 'Password tidak sama';
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
                    : CustomButton("Registrasi", () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          final registerBody = RegisterBody(
                            email: emailController.text,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            password: passwordController.text,
                          );
                          final response =
                              await MemberService().register(registerBody);
                          setState(() {
                            isLoading = false;
                          });
                          if (response?.status == 0) {
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, response?.message ?? "",
                                isSuccess: true);
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
                      "sudah punya akun? login",
                      style: normalTextStyle,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/login");
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
