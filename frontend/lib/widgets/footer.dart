import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_ecommerce_app/screens/footer_pages.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';

import 'package:smart_ecommerce_app/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    final List<Widget> sections = [
      // 1. Connect With RAKHSH
      SizedBox(
        width: isMobile ? double.infinity : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect With RAKHSH',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _ContactItem(icon: Icons.phone, text: 'Phone: 03369696969'),
            const SizedBox(height: 6),
            _ContactItem(icon: Icons.access_time, text: 'Mon-Fri 9:30 to 5:30'),
            const SizedBox(height: 6),
            _ContactItem(icon: Icons.email, text: 'rakhshwear@hotmail.com'),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  if (auth.isLoggedIn) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF37474F), // Exactly #37474F
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Hello, ',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${auth.userName}.',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () => auth.logout(),
                          icon: const Icon(Icons.power_settings_new, size: 20),
                          color: Colors.red.shade700,
                          tooltip: 'Logout',
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    );
                  }

                  return Align(
                    alignment: Alignment.centerLeft,
                    child: _HoverIconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          FadeSlideRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'LOGIN / SIGNUP',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 2. Support
      SizedBox(
        width: isMobile ? double.infinity : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Support', style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
            const SizedBox(height: 16),
            _FooterLink(text: 'Track Your Order', destination: const TrackOrderPage()),
            _FooterLink(text: 'Size Guide', destination: const SizeGuidePage()),
            _FooterLink(text: 'Shipment & Delivery', destination: const ShippingDeliveryPage()),
            _FooterLink(text: 'Exchange Policy', destination: const ExchangePolicyPage()),
            _FooterLink(text: 'How to Order', destination: const HowToOrderPage()),
            _FooterLink(text: 'Terms & Conditions', destination: const TermsConditionsPage()),
          ],
        ),
      ),

      // 3. Company
      SizedBox(
        width: isMobile ? double.infinity : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company', style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
            const SizedBox(height: 16),
            _FooterLink(text: 'About us', destination: const AboutUsPage()),
            _FooterLink(text: 'Privacy Policy', destination: const PrivacyPolicyPage()),
            _FooterLink(text: 'Payment Method', destination: const PaymentMethodPage()),
            _FooterLink(text: 'Customer Services', destination: const CustomerServicesPage()),
            _FooterLink(text: 'Blog News', destination: const BlogNewsPage()),
          ],
        ),
      ),

      // 4. Social
      SizedBox(
        width: isMobile ? double.infinity : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Follow Us', style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
            const SizedBox(height: 16),
            _SocialLink(icon: FontAwesomeIcons.facebook, text: 'Facebook', url: 'https://facebook.com', hoverColor: const Color(0xFF1877F2)),
            const SizedBox(height: 8),
            _SocialLink(icon: FontAwesomeIcons.instagram, text: 'Instagram', url: 'https://instagram.com', hoverColor: const Color(0xFFE4405F)),
            const SizedBox(height: 8),
            _SocialLink(icon: FontAwesomeIcons.whatsapp, text: 'Whatsapp', url: 'https://web.whatsapp.com', hoverColor: const Color(0xFF25D366)),
            const SizedBox(height: 8),
            _SocialLink(icon: FontAwesomeIcons.youtube, text: 'YouTube', url: 'https://youtube.com', hoverColor: const Color(0xFFFF0000)),
            const SizedBox(height: 8),
            _SocialLink(icon: FontAwesomeIcons.snapchat, text: 'Snapchat', url: 'https://snapchat.com', hoverColor: const Color(0xFFFFFC00)),
          ],
        ),
      ),
    ];

    if (isMobile) {
      return Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sections.expand((s) => [s, const SizedBox(height: 40)]).toList()..removeLast(),
        ),
      );
    }

    return Container(
      color: Colors.black, // Whole theme of footer to black
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.map((s) => Expanded(child: s)).toList(),
      ),
    );
  }
}

// Copyright footer section
class CopyrightFooter extends StatelessWidget {
  const CopyrightFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        '© Copyright 2026 RAKHSH. All rights reserved.',
        textAlign: TextAlign.left,
        style: GoogleFonts.montserrat(
          color: Colors.white38,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white70),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String text;
  final Widget? destination;

  const _FooterLink({required this.text, this.destination});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: () {
            if (widget.destination != null) {
               Navigator.push(
                  context,
                  FadeSlideRoute(builder: (context) => widget.destination!),
               );
            }
          },
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(
              bottom: 6,
              left: _isHovering ? 16 : 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.text,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: _isHovering ? Colors.white : Colors.white70,
                    fontWeight: _isHovering ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLink extends StatefulWidget {
  final IconData icon;
  final String text;
  final String url;
  final Color hoverColor;

  const _SocialLink({required this.icon, required this.text, required this.url, required this.hoverColor});

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.parse(widget.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 18,
                  color: _isHovering ? widget.hoverColor : Colors.white70,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.text,
                  style: GoogleFonts.montserrat(
                    color: _isHovering ? widget.hoverColor : Colors.white70,
                    fontWeight: _isHovering ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverIconButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? hoverBgColor;
  final bool isCapsule;

  const _HoverIconButton({
    required this.child, 
    required this.onPressed,
    this.bgColor,
    this.hoverBgColor,
    this.isCapsule = false,
  });

  @override
  State<_HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<_HoverIconButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: AnimatedScale(
          scale: _isHovering ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isHovering 
                  ? Colors.grey.shade100
                  : Colors.white, // White login box
              foregroundColor: Colors.black, // Text inside box to black
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              elevation: _isHovering ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.isCapsule ? 30 : 8),
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
