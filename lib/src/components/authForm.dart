import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/exceptions/authException.dart';
import 'package:shopelt/src/models/auth.dart';

enum AuthMode { SignUp, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();
  Map<String, String> _authData = {"email": "", "password": ""};
  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignUp() => _authMode == AuthMode.SignUp;
  void _switchAuthMode() {
    setState(() {
      _authMode = _isLogin() ? AuthMode.SignUp : AuthMode.Login;
    });
  }

  bool _errorAuth = false;
  String _errorMessage = '';

  void _showErrorMessage(String error) {
    setState(() {
      _errorAuth = true;
      _errorMessage = error;
    });
    // showDialog(
    //   context: context,
    //   builder: (ctx) => AlertDialog(
    //     title: const Text('Auth Error'),
    //     content: Text(error),
    //     actions: [
    //       TextButton(
    //           onPressed: () => Navigator.of(context).pop(),
    //           child: const Text('Close'))
    //     ],
    //   ),
    // );
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);
    try {
      _isLogin()
          ? await auth.login(_authData['email']!, _authData['password']!)
          : await auth.signUp(_authData['email']!, _authData['password']!);
    } on AuthException catch (err) {
      _showErrorMessage(err.toString());
      setState(() => _isLoading = false);
    } catch (err) {
      _showErrorMessage('Unexpected Error');
      setState(() => _isLoading = false);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(18),
        // height: deviceSize.height * 0.30,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  return email.trim().isEmpty || !email.contains('@')
                      ? 'Email invalid'
                      : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  if (_isLogin()) return null;
                  final password = _password ?? '';
                  return password.isEmpty || password.length < 8
                      ? 'Password Invalid, try >8 characters'
                      : null;
                },
              ),
              if (_isSignUp())
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (_confirmPassword) {
                          final confirmPassword = _confirmPassword ?? '';
                          return confirmPassword != _passwordController.text
                              ? 'The Passwords dont matches'
                              : null;
                        },
                ),
              const SizedBox(height: 20),
              if (!_isLoading && _errorAuth)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10)),
                  child: Text(_isLogin() ? 'Login' : 'Sign Up'),
                ),
              if (!_isLoading)
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(_isLogin() ? 'Sign Up' : 'Login'),
                )
            ],
          ),
        ),
      ),
    );
  }
}
