import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:mobi_div/screens/splash.dart';
import 'package:mobi_div/screens/traveldiary.dart';

import '../models/authservice.dart';
import '../models/usermodel.dart';
import 'googleMapScreen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoggedIn = false;
  bool _isObscured = true;
  bool _isObscured_confirm = true;

  Future<bool> getAvailableUsers(String email, String username, String password) async{
    bool result = false;
    User? user = await authService.userService.getUser();
    if(user == null){
      return false;
    }else{
      if(user.email == email && user.password == password && user.name == username){
        result = true;
        return result;
      }else{
       return result = false;
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    String pattern =
        r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // At least one uppercase, one lowercase, one number and one special character, and at least 8 characters
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters long, include an uppercase letter, number, and symbol.';
    }
    if(_confirmPasswordController.text != value){
      return 'Password mismatch';
    }
    return null;
  }
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // At least one uppercase, one lowercase, one number and one special character, and at least 8 characters
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters long, include an uppercase letter, number, and symbol.';
    }

    if(_passwordController.text != value){
      return 'Password mismatch';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 40.0),

                      const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Create your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _userNameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 12),
                            hintText: "Username",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.black87,
                            filled: true,
                            prefixIcon: const Icon(Icons.person, color: Colors.white,)),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 12),
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.black87,
                            filled: true,
                            prefixIcon: const Icon(Icons.email, color: Colors.white,)),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscured,
                        validator: _validatePassword,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 12),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.black87,
                          filled: true,
                          prefixIcon: const Icon(Icons.password, color: Colors.white,),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              // Toggle the boolean state to show/hide the password
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: _validateConfirmPassword,
                        obscureText: _isObscured_confirm,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 12),
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.black87,
                          filled: true,
                          prefixIcon: const Icon(Icons.password, color: Colors.white,),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured_confirm ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              // Toggle the boolean state to show/hide the password
                              setState(() {
                                _isObscured_confirm = !_isObscured_confirm;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),

                      child: ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate() && _confirmPasswordController.text == _passwordController.text) {
                            GFToast.showToast(
                              'We are signing You in..',
                              context,
                              toastDuration: 3,
                              toastPosition: GFToastPosition.BOTTOM,
                              textStyle: TextStyle(fontSize: 16, color: Colors.white),
                              backgroundColor: Colors.black87,
                            );
                            bool success = await authService.signup(_userNameController.text,_emailController.text, _passwordController.text);
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => user_id != "" && userToken != ""? HomeScreen(userID: user_id, userToken: userToken,) : HomeScreen()),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.purple,
                        ),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, new MaterialPageRoute(builder: (context)=> LoginPage()));
                          },
                          child: const Text("Login", style: TextStyle(color: Colors.purple),)
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoggedIn = false;
  bool _isObscured = false;

  Future<void> _checkLoginStatus() async {
    bool loggedIn = await authService.userService.isUserLoggedIn();
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  void initState() {
    _checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  _header(context),
                  _inputField(context),
                  _forgotPassword(context),
                  _signup(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    String pattern =
        r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // At least one uppercase, one lowercase, one number and one special character, and at least 8 characters
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters long, '
          '\ninclude an uppercase letter, '
          '\nnumber, and symbol.';
    }
    return null;
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "BD Mobility",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Welcomes You"),
        Text("let's get You to login"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20,),
        TextFormField(
          controller: _emailController,
          style: TextStyle(color: Colors.white),
          validator: _validateEmail,
          decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 12),
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              ),
              fillColor: Colors.black87,
              filled: true,
              prefixIcon: const Icon(Icons.email, color: Colors.white,)),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          validator: _validatePassword,
          obscureText: _isObscured,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 12),
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.black87,
            filled: true,
            prefixIcon: const Icon(Icons.password, color: Colors.white,),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              GFToast.showToast(
                'We are getting You logged in',
                context,
                toastDuration: 3,
                toastPosition: GFToastPosition.BOTTOM,
                textStyle: TextStyle(fontSize: 16, color: Colors.white),
                backgroundColor: Colors.black87,
              );
              bool success = await authService.login(_emailController.text, _passwordController.text);
              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text("Forgot password?",
        style: TextStyle(color: Colors.purple),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context)=> SignupPage()));
            },
            child: const Text("Sign Up", style: TextStyle(color: Colors.purple),)
        )
      ],
    );
  }
}
