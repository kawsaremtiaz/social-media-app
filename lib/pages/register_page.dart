import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_button.dart';
import 'package:social_media_app/components/my_textfield.dart';
import 'package:social_media_app/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controller
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController pwController = TextEditingController();

  final TextEditingController confermPwController = TextEditingController();

  // clear textfield methord
  void clearRegisterTextfield() {
    usernameController.clear();
    emailController.clear();
    pwController.clear();
    confermPwController.clear();
  }

  // register methord
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure passwords match
    if (pwController.text != confermPwController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser("Password don't match!", context);
    } else {
      // try creating the user
      try {
        // create the user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: pwController.text,
        );

        // create a user document add to firestore
        createUserDocument(userCredential);

        // clear the textfield
        clearRegisterTextfield();

        // pop loading circle
        // ignore: use_build_context_synchronously
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

        // show error message to user
        // ignore: use_build_context_synchronously
        displayMessageToUser(e.code, context);
      }
    }
  }

  // create a user document and collect them in firestor
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(
                  height: 25,
                ),

                // app name
                const Text(
                  "M I N I M A L",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                // user name textfield
                MyTextfield(
                  hintText: 'Username',
                  onscureText: false,
                  controller: usernameController,
                ),

                const SizedBox(
                  height: 10,
                ),

                // email textfield
                MyTextfield(
                  hintText: 'Email',
                  onscureText: false,
                  controller: emailController,
                ),

                const SizedBox(
                  height: 10,
                ),

                //password textfield
                MyTextfield(
                  hintText: 'Password',
                  onscureText: false,
                  controller: pwController,
                ),

                const SizedBox(
                  height: 10,
                ),

                //conferm password textfield
                MyTextfield(
                  hintText: 'Conterm Password',
                  onscureText: false,
                  controller: confermPwController,
                ),

                const SizedBox(
                  height: 25,
                ),

                // sign up button
                MyButton(
                  text: "Submit",
                  onTap: registerUser,
                ),

                const SizedBox(
                  height: 25,
                ),

                // already you have an account? login here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Here",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
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
}
