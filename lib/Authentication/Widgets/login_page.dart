import 'package:devies_books/Authentication/authenticated_user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      child: Center(
        child: SizedBox(
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: CupertinoTextField(
                      controller: _usernameController,
                      placeholder: 'Username',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 48,
                    child: CupertinoTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              CupertinoButton.filled(
                  onPressed: () {
                    context.read<AuthenticatedUserController>().login(
                          username: _usernameController.text,
                          password: _passwordController.text,
                        );
                  },
                  child: const Text('Login')),
              CupertinoButton(
                onPressed: () async {
                  context.read<AuthenticatedUserController>().registerUser(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      );
                },
                child: const Text('Register new user'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
