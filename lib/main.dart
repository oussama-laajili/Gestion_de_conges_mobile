import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_page.dart';
import 'splash_screen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isPasswordVisible = false;
  bool _isPasswordRecoveryMode = false;
  bool _isPasswordResetMode = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resetKeyController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String _message = '';
  Color _backgroundColor = Colors.white;

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://192.168.1.20:5000/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('access_token') &&
          responseData.containsKey('fullname')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', responseData['access_token']);
        await prefs.setString('fullname', responseData['fullname']);
        await prefs.setString('avatar', responseData['avatar'] ?? '');
        await prefs.setString('email', email);

        final fullname = responseData['fullname'];

        setState(() {
          _message = 'Connexion réussie !';
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomePage(fullname: fullname),
          ),
        );
      } else {
        setState(() {
          _message = 'Login failed: Token or full name not found in response';
        });
      }
    } else {
      setState(() {
        _message = 'Login failed: ${response.reasonPhrase}';
      });
    }
  }

  Future<void> recoverPassword(String email) async {
    final url =
        Uri.parse('http://192.168.1.20:5000/auth/request-password-reset');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _message = '';
        _isPasswordRecoveryMode = false;
        _isPasswordResetMode = true;
      });
    } else {
      setState(() {
        _message = 'Échec de la demande de réinitialisation';
      });
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    final url = Uri.parse('http://192.168.1.20:5000/auth/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _message = 'Mot de passe réinitialisé avec succès !';
        _isPasswordResetMode = false;
      });

// Somewhere in your build method:
      Text(
        _message,
        style: TextStyle(
          color: Colors.green, // Set the text color to green
          fontSize: 16.0, // Adjust the font size as needed
        ),
      );
    } else {
      setState(() {
        _message = 'Échec de la réinitialisation du mot de passe';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _backgroundColor = Colors.white;
                          });
                        },
                        child: FadeInUp(
                            duration: Duration(seconds: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                    ),
                    Positioned(
                      left: 120,
                      width: 80,
                      height: 150,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _backgroundColor = Color(0xFF1a1c23);
                          });
                        },
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1200),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: -80,
                      width: 180,
                      height: 350,
                      child: FadeInUp(
                          duration: Duration(milliseconds: 1300),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      left: 100,
                      top: 180,
                      child: FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Center(
                              child: Text(
                                "Se connecter",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color.fromRGBO(28, 128, 251, 1)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              if (!_isPasswordRecoveryMode &&
                                  !_isPasswordResetMode)
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  28, 128, 251, 1)))),
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            "Email ou numéro de téléphone",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                  ),
                                ),
                              if (!_isPasswordRecoveryMode &&
                                  !_isPasswordResetMode)
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(28, 128, 251,
                                            1), // Match the color of the border to the one used for the email input
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Mot de passe",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700]),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey[700],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              if (_isPasswordRecoveryMode)
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                  ),
                                ),
                              if (_isPasswordResetMode)
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _resetKeyController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "La clé",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[700])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _newPasswordController,
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Nouveau mot de passe",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[700]),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.grey[700],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isPasswordVisible =
                                                      !_isPasswordVisible;
                                                });
                                              },
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 10),
                              Container(
                                height: 45,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(28, 128, 251, 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: MaterialButton(
                                  child: Center(
                                    child: Text(
                                      !_isPasswordRecoveryMode &&
                                              !_isPasswordResetMode
                                          ? "Se connecter"
                                          : _isPasswordRecoveryMode
                                              ? "Envoyer clé"
                                              : "Réinitialiser mot de passe",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (!_isPasswordRecoveryMode &&
                                        !_isPasswordResetMode) {
                                      login(_emailController.text,
                                          _passwordController.text);
                                    } else if (_isPasswordRecoveryMode) {
                                      recoverPassword(_emailController.text);
                                    } else if (_isPasswordResetMode) {
                                      resetPassword(_resetKeyController.text,
                                          _newPasswordController.text);
                                    }
                                  },
                                ),
                              ),
                              if (!_isPasswordRecoveryMode &&
                                  !_isPasswordResetMode)
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Mot de passe oublié ? ",
                                        style:
                                            TextStyle(color: Colors.grey[700]),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isPasswordRecoveryMode = true;
                                          });
                                        },
                                        child: Text(
                                          "Réinitialiser",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  28, 128, 251, 1),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (_isPasswordRecoveryMode ||
                                  _isPasswordResetMode)
                                Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPasswordRecoveryMode = false;
                                        _isPasswordResetMode = false;
                                      });
                                    },
                                    child: Text(
                                      "Retour",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(28, 128, 251, 1),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )),
                    SizedBox(height: 30),
                    Text(
                      _message,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
