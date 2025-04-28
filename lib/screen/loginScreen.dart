import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard.dart';
import '../provider/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();

  bool isLoading = false;
  bool isSignup = false;
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              // Logo
              Image.asset(
                "assets/images/logo.png",
                height: 50,
              ),
              SizedBox(height: 40),
              // Title
              Text(
                isSignup ? "Create Account" : "Welcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                isSignup ? "Sign up to get started" : "Sign in to continue",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),

              // Form fields
              if (isSignup) ...[
                // Admin/Staff toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleOption("Admin", !isAdmin),
                    SizedBox(width: 30),
                    _buildRoleOption("Staff", isAdmin),
                  ],
                ),
                SizedBox(height: 20),

                // Name field
                _buildTextField(
                  controller: nameCtrl,
                  label: "Full Name",
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 16),

                // Phone field
                _buildTextField(
                  controller: phoneCtrl,
                  label: "Phone Number",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
              ],

              // Email field
              _buildTextField(
                controller: emailCtrl,
                label: "Username",
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 16),

              // Password field
              _buildTextField(
                controller: passwordCtrl,
                label: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              SizedBox(height: 40),

              // Login/Signup button
              _buildActionButton(),

              SizedBox(height: 20),

              // Switch between login/signup
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSignup = !isSignup;
                  });
                },
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                    children: [
                      TextSpan(
                        text: isSignup
                            ? "Already have an account? "
                            : "Don't have an account? ",
                      ),
                      TextSpan(
                        text: isSignup ? "Sign In" : "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isAdmin = title == "Admin";
        });
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
              color: isSelected ? Colors.blue : Colors.transparent,
            ),
            child: isSelected
                ? Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          hintText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            isLoading ? null : () => isSignup ? signUp(isAdmin) : logIn(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                isSignup ? "Create Account" : "Sign In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void logIn() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      _showSnackBar("Please enter username and password");
      return;
    }

    setState(() {
      isLoading = true;
    });

    Provider.of<AuthProvider>(context, listen: false)
        .getLoginData(emailCtrl.text, passwordCtrl.text)
        .then((value) async {
      if (value.isNotEmpty) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('logged', "true");
        await pref.setString('userId', value[0]["id"]);
        await pref.setString('name', value[0]["name"]);
        await pref.setString('username', value[0]["useName"]);
        await pref.setString('phoneNo', value[0]["phoneNo"]);
        await pref.setString('userType', value[0]["userType"]);

        _showSnackBar("Login successful");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashBoardScreen()));
      } else {
        _showSnackBar("Invalid username or password");
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  void signUp(bool userType) {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty) {
      _showSnackBar("Please fill all required fields");
      return;
    }

    setState(() {
      isLoading = true;
    });

    Provider.of<AuthProvider>(context, listen: false)
        .createUser(nameCtrl.text, emailCtrl.text, passwordCtrl.text,
            phoneCtrl.text, userType)
        .then((val) {
      if (val == 200) {
        _showSnackBar("Account created successfully");
        setState(() {
          isSignup = false;
          nameCtrl.clear();
          emailCtrl.clear();
          passwordCtrl.clear();
          phoneCtrl.clear();
        });
      } else {
        _showSnackBar("Username already exists");
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }
}
