import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';
import 'package:smart_ecommerce_app/theme/app_theme.dart';
import 'package:smart_ecommerce_app/screens/home_screen.dart';

void main() {
  runApp(const SmartEcommerceApp());
}

class SmartEcommerceApp extends StatelessWidget {
  const SmartEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProxyProvider<CartProvider, AuthProvider>(
          create: (context) => AuthProvider(context.read<CartProvider>()),
          update: (context, cart, auth) => auth ?? AuthProvider(cart),
        ),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: MaterialApp(
        title: 'Rakhsh Wear PK',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
