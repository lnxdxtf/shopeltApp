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

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin {
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
      if (_isLogin()) {
        _animationController?.reverse();
      } else {
        _animationController?.forward();
      }
    });
  }

  bool _errorAuth = false;
  String _errorMessage = '';

  void _showErrorMessage(String error) {
    setState(() {
      _errorAuth = true;
      _errorMessage = error;
    });
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() => _isLoading = false);
      return;
    }
    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);
    try {
      _isLogin() ? await auth.login(_authData['email']!, _authData['password']!) : await auth.signUp(_authData['email']!, _authData['password']!);
      setState(() {
        _isLoading = false;
        _errorAuth = false;
        _errorMessage = '';
      });
    } on AuthException catch (err) {
      _showErrorMessage(err.toString());
      setState(() => _isLoading = false);
    } catch (err) {
      _showErrorMessage('Unexpected Error');
      setState(() => _isLoading = false);
    }
  }

  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      color: Colors.white54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedContainer(
        curve: Curves.linear,
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        // height: _isLogin() ? 270 : 392,
        // height: _isLogin() ? deviceSize.height * 0.40 : deviceSize.height * 0.48,
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
                  return email.trim().isEmpty || !email.contains('@') ? 'Email invalid' : null;
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
                  return password.isEmpty || password.length < 8 ? 'Password Invalid, try >8 characters' : null;
                },
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Confirm Password'),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      validator: _isLogin()
                          ? null
                          : (_confirmPassword) {
                              final confirmPassword = _confirmPassword ?? '';
                              return confirmPassword != _passwordController.text ? 'The Passwords dont matches' : null;
                            },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (!_isLoading && _errorAuth)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                  child: Text(_isLogin() ? 'Login' : 'Sign Up'),
                ),
              const SizedBox(height: 10),
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
