import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_ecommerce_app/utils/app_snackbar.dart';
import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';
import 'package:smart_ecommerce_app/screens/signup_screen.dart';
import 'package:smart_ecommerce_app/screens/web_layout.dart';
import 'package:smart_ecommerce_app/screens/home_screen.dart';
import 'package:smart_ecommerce_app/screens/checkout_screen.dart';

import 'package:smart_ecommerce_app/models/data_models.dart';
import 'package:smart_ecommerce_app/services/mock_data_service.dart';

import 'package:smart_ecommerce_app/widgets/custom_text_field.dart';
import 'package:smart_ecommerce_app/widgets/primary_button.dart';
import 'package:smart_ecommerce_app/widgets/footer.dart';

class LoginScreen extends StatefulWidget {
  /// When true, after a successful login the user is taken straight to checkout.
  final bool redirectToCheckout;
  const LoginScreen({super.key, this.redirectToCheckout = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.error(context, 'Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final name = data['name'] ?? 'Customer';
        final userId = data['id'].toString();
        
        // Mark user as logged in
        context.read<AuthProvider>().login(name, userId);
        
        // Restore cart
        final cartProvider = context.read<CartProvider>();
        cartProvider.setUserId(userId);
        
        try {
          if (data['cart_data'] != '[]') {
            final List<dynamic> cartJson = jsonDecode(data['cart_data']);
            final List<CartItem> restoredCart = [];
            for (var itemJson in cartJson) {
              final productData = MockDataService.products.firstWhere(
                (p) => p.id == itemJson['productId'],
                orElse: () => MockDataService.products.first,
              );
              // Only add if we actually found the product (handle deleted products if needed)
              if (productData.id == itemJson['productId']) {
                 restoredCart.add(CartItem(
                   product: productData,
                   selectedSize: itemJson['selectedSize'],
                   quantity: itemJson['quantity'],
                 ));
              }
            }
            cartProvider.restoreCart(restoredCart);
          }
        } catch (e) {
          debugPrint('Error restoring cart: $e');
        }

        AppSnackBar.info(context, 'Welcome back, $name!');

        if (widget.redirectToCheckout) {
          Navigator.pushReplacement(
            context,
            FadeSlideRoute(builder: (context) => const CheckoutScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            FadeSlideRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Login failed';
        AppSnackBar.error(context, error);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('Login Error: $e');
      AppSnackBar.error(context, 'Login attempt failed: $e. Make sure backend is running at http://127.0.0.1:5000');
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
                      'WELCOME BACK',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.black,
                      ),
                    ),
                    if (widget.redirectToCheckout) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Please sign in to continue to checkout.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 48),
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
                      label: 'LOGIN',
                      onPressed: _login,
                      isLoading: _isLoading,
                      bgColor: Colors.grey.shade800,
                      hoverBgColor: Colors.black,
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          FadeSlideRoute(builder: (context) => const SignupScreen()),
                        );
                      },
                      child: const Text('Create an Account'),
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
