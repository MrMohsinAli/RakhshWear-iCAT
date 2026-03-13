import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_ecommerce_app/utils/app_snackbar.dart';
import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';
import 'package:smart_ecommerce_app/screens/web_layout.dart';
import 'package:smart_ecommerce_app/screens/home_screen.dart';
import 'package:smart_ecommerce_app/widgets/custom_text_field.dart';
import 'package:smart_ecommerce_app/widgets/footer.dart';
import 'package:smart_ecommerce_app/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      AppSnackBar.error(context, 'Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final returnedName = data['name'] ?? name;
        final userId = data['id'].toString();

        // Auto-login
        context.read<AuthProvider>().login(returnedName, userId);
        context.read<CartProvider>().setUserId(userId);

        AppSnackBar.success(context, 'Welcome to RakhshWear, $returnedName!');
        
        // Navigate to Home
        Navigator.pushReplacement(
          context,
          FadeSlideRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Sign up failed';
        AppSnackBar.error(context, error);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('Signup Error: $e');
      AppSnackBar.error(context, 'Signup failed: $e. Make sure backend is running at http://127.0.0.1:5000');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebLayout(
      body: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'CREATE ACCOUNT',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: 48),
                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'SIGN UP',
                      onPressed: _isLoading ? null : _signup,
                      isLoading: _isLoading,
                      bgColor: Colors.grey.shade800,
                      hoverBgColor: Colors.black,
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                         Navigator.pop(context);
                      },
                      child: const Text('Already have an account? Login'),
                    ),
                     const SizedBox(height: 16),
                    Text(
                      'Need help? Contact rakhshwear@hotmail.com',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Footer(),
              const CopyrightFooter(),
            ],
          ),
      ),
    );
  }
}
