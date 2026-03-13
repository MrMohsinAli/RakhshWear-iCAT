import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_ecommerce_app/screens/home_screen.dart';

class RakhshLogo extends StatelessWidget {
  final double size;
  final bool dark;

  const RakhshLogo({super.key, this.size = 24, this.dark = true});

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              FadeSlideRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
          child: Image.asset(
            'assets/images/logo.png',
            height: size * 1.8, // Reduced for a more compact header
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Text(
                'رخش',
                style: GoogleFonts.notoNastaliqUrdu(
                  fontSize: size * 2,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.black : Colors.white,
                  height: 1.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
