import 'package:flutter/material.dart';
import 'package:fnotes/utils/auth_service.dart';
import 'package:fnotes/utils/constants.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('Please sign in to continue',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      await context.read<AuthService>().signInWithGoogle();
                      setState(() => isLoading = false);
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 2),
                                color: secondary,
                                blurRadius: 5),
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            child: const Image(
                              image: AssetImage('assets/images/google.png'),
                              height: 25,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 16, left: 16),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
      ),
    );
  }
}
