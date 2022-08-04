import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_one/pages/home_page.dart';
import 'package:firebase_note_one/pages/sign_up_page.dart';
import 'package:firebase_note_one/services/auth_service.dart';
import 'package:firebase_note_one/services/db_service.dart';
import 'package:firebase_note_one/services/util_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  static const id = "/sign_in_page";
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _signIn() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email.isEmpty || password.isEmpty) {
      Utils.fireSnackBar("Please fill all gaps", context);
      return;
    }

    isLoading = true;
    setState(() {});

    AuthService.signInUser(context, email, password).then((user) => _checkUser(user));

  }

  void _checkUser(User? user) async {
    if(user != null) {
      debugPrint(user.toString());
      await DBService.saveUserId(user.uid);
      if(mounted) Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireSnackBar("Please check your entered data, Please try again!", context);
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> _catchError() async{
    Utils.fireSnackBar("Something error in Service, Please try again later", context);
    isLoading = false;
    setState(() {});
  }

  void _goSignUp() {
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // #email
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
                style: const TextStyle(fontSize: 18, color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20,),

              // #password
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
                style: const TextStyle(fontSize: 18, color: Colors.black),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: true,
              ),
              const SizedBox(height: 20,),

              // #sign_in
              ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)
                ),
                child: const Text("Sign In", style: TextStyle(fontSize: 16),),
              ),
              const SizedBox(height: 20,),

              // #sign_up
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "Don't have an account?  ",
                    ),
                    TextSpan(
                      style: const TextStyle(color: Colors.blue),
                      text: "Sign Up",
                      recognizer: TapGestureRecognizer()..onTap = _goSignUp,
                    ),
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
