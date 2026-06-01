import 'package:flutter/material.dart';
import 'package:firebaseesp32/Email.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isSecurePassword = true;
  final _formKey = GlobalKey<FormState>();

  // المتغيرات الخاصة باسم المستخدم وكلمة المرور
  final String correctUsername = "admin";
  final String correctPassword = "123";

  // Controllers للحقلين
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 10000,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "GAS LEVEL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _usernameController, // ربط الحقل بمتحكم
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The field is empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Enter Your Username", // تغيير النص هنا
                            labelStyle: const TextStyle(color: Colors.green),
                            suffixIcon: const Icon(Icons.person,
                                size: 20, color: Colors.green), // تغيير الأيقونة
                            hintText: "Enter your username",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 50),
                        TextFormField(
                          controller: _passwordController, // ربط الحقل بمتحكم
                          obscureText: _isSecurePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Enter your password",
                            labelStyle: const TextStyle(color: Colors.green),
                            suffixIcon: togglePasswordVisibility(),
                            hintText: "****",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            child: const Text(
                              "Forget Password?",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // التحقق من اسم المستخدم وكلمة المرور
                              final username = _usernameController.text;
                              final password = _passwordController.text;

                              if (username == correctUsername && password == correctPassword) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Emails()),
                                );
                              } else {
                                // عرض رسالة تحذير إذا كانت بيانات الدخول غير صحيحة
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Login Failed"),
                                      content: const Text("Invalid username or password"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.green,
                            elevation: 5,
                          ),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "-OR-",
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget togglePasswordVisibility() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: Icon(_isSecurePassword ? Icons.visibility : Icons.visibility_off,
          color: Colors.green),
    );
  }
}
