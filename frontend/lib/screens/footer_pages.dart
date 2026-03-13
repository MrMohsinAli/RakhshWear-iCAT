import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_ecommerce_app/screens/web_layout.dart';
import 'package:smart_ecommerce_app/widgets/footer.dart';

// ─── Shared Layout Widget ────────────────────────────────────────────────────

class _PageLayout extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _PageLayout({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return WebLayout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(64, 48, 64, 12),
              child: Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Body content
            Padding(
              padding: const EdgeInsets.fromLTRB(64, 0, 64, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
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

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 15,
        height: 1.8,
        color: Colors.black87,
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList(this.items);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16, color: Colors.black54)),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.montserrat(fontSize: 15, height: 1.7, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _InfoCard({required this.icon, required this.title, required this.body});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Text(body, style: GoogleFonts.montserrat(fontSize: 14, height: 1.6, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SUPPORT PAGES ────────────────────────────────────────────────────────────

class TrackOrderPage extends StatelessWidget {
  const TrackOrderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'Track Your Order',
      children: [
        _BodyText(
          'Once your order is dispatched, you will receive a tracking ID via email or SMS. '
          'Use that ID on the courier\'s website to get real-time updates on your shipment.',
        ),
        _SectionTitle('How to Track'),
        _BulletList(const [
          'Check your email or SMS for the tracking ID sent at the time of dispatch.',
          'Visit the courier\'s website (TCS, Leopards, or M&P) and enter your tracking number.',
          'Alternatively, call us at 03369696969 and we will provide an update within minutes.',
        ]),
        _SectionTitle('Estimated Delivery Times'),
        _InfoCard(
          icon: Icons.location_city,
          title: 'Within Lahore',
          body: 'Same-day or next-day delivery for orders placed before 12:00 PM.',
        ),
        _InfoCard(
          icon: Icons.flight_takeoff,
          title: 'Major Cities (Karachi, Islamabad, Rawalpindi)',
          body: '2–3 working days after dispatch.',
        ),
        _InfoCard(
          icon: Icons.map,
          title: 'Rest of Pakistan',
          body: '3–5 working days after dispatch.',
        ),
        const SizedBox(height: 16),
        _BodyText('If your order has not arrived within the estimated time, please contact our support team immediately.'),
      ],
    );
  }
}

class SizeGuidePage extends StatelessWidget {
  const SizeGuidePage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'Size Guide',
      children: [
        _BodyText(
          'Finding your perfect fit is important to us. Use the charts below to select the right size. '
          'All measurements are in inches unless stated otherwise. If you are between sizes, we recommend sizing up.',
        ),
        _SectionTitle('Shirts & Tops'),
        _SizeTable(
          headers: const ['Size', 'Chest', 'Shoulder', 'Length'],
          rows: const [
            ['S', '36–38"', '16.5"', '28"'],
            ['M', '38–40"', '17.5"', '29"'],
            ['L', '40–42"', '18.5"', '30"'],
            ['XL', '42–44"', '19.5"', '31"'],
            ['XXL', '44–46"', '20.5"', '32"'],
          ],
        ),
        _SectionTitle('Jackets & Blazers'),
        _SizeTable(
          headers: const ['Size', 'Chest', 'Shoulder', 'Length', 'Sleeve'],
          rows: const [
            ['S', '40"', '17.5"', '28.5"', '25"'],
            ['M', '42"', '18.5"', '29.5"', '25.5"'],
            ['L', '44"', '19.5"', '30.5"', '26"'],
            ['XL', '46"', '20.5"', '31.5"', '26.5"'],
            ['XXL', '48"', '21.5"', '32.5"', '27"'],
          ],
        ),
        _SectionTitle('Trousers & Bottoms'),
        _SizeTable(
          headers: const ['Size', 'Waist', 'Hip', 'Inseam'],
          rows: const [
            ['S', '28–30"', '36–38"', '29"'],
            ['M', '30–32"', '38–40"', '30"'],
            ['L', '32–34"', '40–42"', '30"'],
            ['XL', '34–36"', '42–44"', '31"'],
            ['XXL', '36–38"', '44–46"', '31"'],
          ],
        ),
        _SectionTitle('Kurta & Traditional Wear'),
        _SizeTable(
          headers: const ['Size', 'Chest', 'Kurta Length', 'Shalwar Length'],
          rows: const [
            ['S', '38"', '42"', '40"'],
            ['M', '40"', '44"', '41"'],
            ['L', '42"', '46"', '42"'],
            ['XL', '44"', '48"', '43"'],
            ['XXL', '46"', '50"', '44"'],
          ],
        ),
        _SectionTitle('Footwear'),
        _SizeTable(
          headers: const ['UK', 'US', 'EU', 'Foot Length (cm)'],
          rows: const [
            ['6', '7', '40', '25.4'],
            ['7', '8', '41', '26.2'],
            ['8', '9', '42', '27.0'],
            ['9', '10', '43', '27.9'],
            ['10', '11', '44', '28.6'],
            ['11', '12', '45', '29.4'],
          ],
        ),
      ],
    );
  }
}

class _SizeTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  const _SizeTable({required this.headers, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF8F5),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Row(
              children: headers
                  .map((h) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          child: Text(
                            h,
                            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          ...rows.map((row) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: row
                      .map((cell) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              child: Text(
                                cell,
                                style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              )),
        ],
      ),
    );
  }
}

class ShippingDeliveryPage extends StatelessWidget {
  const ShippingDeliveryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'Shipment & Delivery',
      children: [
        _BodyText(
          'At RakhshWear, we ensure your order is packed with care and dispatched promptly. '
          'Below you will find all the information about our shipping process and delivery timelines.',
        ),
        _SectionTitle('Free Shipping'),
        _BodyText('We offer free shipping on all orders above PKR 3,000 across Pakistan. '
            'Orders below PKR 3,000 are charged a flat shipping fee of PKR 200.'),
        _SectionTitle('Delivery Timelines'),
        _InfoCard(
          icon: Icons.local_shipping,
          title: 'Standard Delivery',
          body: '3–5 working days for all cities in Pakistan. Orders are dispatched within 24 hours after payment confirmation.',
        ),
        _InfoCard(
          icon: Icons.flash_on,
          title: 'Express Delivery (Lahore only)',
          body: 'Same-day delivery available for orders placed before 12:00 PM within Lahore city limits. Additional charges apply.',
        ),
        _SectionTitle('Order Processing'),
        _BulletList(const [
          'Orders placed before 2:00 PM on working days are dispatched the same day.',
          'Orders placed after 2:00 PM, on weekends, or public holidays are dispatched the next working day.',
          'A confirmation SMS and email are sent once your order is dispatched along with your tracking number.',
        ]),
        _SectionTitle('Shipping Partners'),
        _BodyText('We work with TCS, Leopards Courier, and M&P Express to ensure safe and timely delivery across all cities and towns of Pakistan.'),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.contact_support,
          title: 'Delivery issue?',
          body: 'Call us at 03369696969 or email rakhshwear@hotmail.com and we will resolve it within 24 hours.',
        ),
      ],
    );
  }
}

class ExchangePolicyPage extends StatelessWidget {
  const ExchangePolicyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'Exchange Policy',
      children: [
        _BodyText(
          'We want you to love what you wear. If something isn\'t quite right, our exchange '
          'policy makes it easy to find a better fit or style.',
        ),
        _SectionTitle('Exchange Eligibility'),
        _BulletList(const [
          'Items must be exchanged within 14 days of delivery.',
          'Products must be unworn, unwashed, and in original condition with tags still attached.',
          'Sale or discounted items are not eligible for exchange.',
          'Innerwear and accessories are non-exchangeable for hygiene reasons.',
          'Exchange is only available for a different size or colour of the same item, subject to stock availability.',
        ]),
        _SectionTitle('How to Request an Exchange'),
        _BulletList(const [
          'Contact us at rakhshwear@hotmail.com or call 03369696969 within 14 days of receiving your order.',
          'Provide your order ID, the item name, and the reason for exchange.',
          'Ship the item back to us. The customer bears the return shipping cost.',
          'Once received and inspected, we will dispatch the replacement within 2–3 working days.',
        ]),
        _SectionTitle('Defective or Wrong Items'),
        _BodyText(
          'If you received a defective or incorrect item, please contact us within 48 hours of delivery '
          'with a photo of the item. In such cases, RakhshWear will bear all shipping costs and arrange an immediate replacement.',
        ),
      ],
    );
  }
}

class HowToOrderPage extends StatelessWidget {
  const HowToOrderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'How to Order',
      children: [
        _BodyText('Ordering from RakhshWear is simple and secure. Follow the steps below to place your order.'),
        _SectionTitle('Step-by-Step Guide'),
        _InfoCard(icon: Icons.search, title: 'Step 1 – Browse', body: 'Explore our categories and find the item you love. Use filters to narrow down by size, colour, or category.'),
        _InfoCard(icon: Icons.straighten, title: 'Step 2 – Select Size', body: 'Use our Size Guide to pick the right fit. Click your preferred size to confirm your selection.'),
        _InfoCard(icon: Icons.shopping_cart, title: 'Step 3 – Add to Cart', body: 'Click "Add to Cart". You can continue shopping or go directly to your cart to review your order.'),
        _InfoCard(icon: Icons.payment, title: 'Step 4 – Checkout', body: 'Proceed to checkout. Enter your delivery address and choose your preferred payment method (COD, EasyPaisa, JazzCash, or Bank Transfer).'),
        _InfoCard(icon: Icons.check_circle_outline, title: 'Step 5 – Confirm', body: 'Review your order and click "Place Order". You will receive an SMS and email confirmation shortly after.'),
      ],
    );
  }
}

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'Terms & Conditions',
      children: [
        _BodyText(
          'By accessing or using the RakhshWear website, you agree to be bound by these terms and conditions. '
          'Please read them carefully before using our services.',
        ),
        _SectionTitle('1. Use of Website'),
        _BodyText('You agree to use this website only for lawful purposes and in a manner that does not infringe the rights of others. '
            'Unauthorized use of this website may give rise to a claim for damages and/or be a criminal offence.'),
        _SectionTitle('2. Product Information'),
        _BodyText('We strive to display product colours and details as accurately as possible. However, due to differences in monitors and screens, '
            'actual colours may vary slightly. All sizes, weights, and dimensions are approximate.'),
        _SectionTitle('3. Pricing'),
        _BodyText('All prices are in Pakistani Rupees (PKR) and include applicable taxes. Prices are subject to change without notice. '
            'We reserve the right to cancel any order placed for an item listed at an incorrect price.'),
        _SectionTitle('4. Order Cancellations'),
        _BodyText('Orders can be cancelled within 2 hours of placement by contacting our support team. '
            'Orders that have been dispatched cannot be cancelled.'),
        _SectionTitle('5. Intellectual Property'),
        _BodyText('All content on this website, including images, logos, and text, is the intellectual property of RakhshWear PK. '
            'You may not reproduce or distribute any content without prior written consent.'),
        _SectionTitle('6. Limitation of Liability'),
        _BodyText('RakhshWear shall not be liable for any indirect or consequential loss arising from the use of this website or our products, '
            'to the maximum extent permitted by applicable law.'),
        const SizedBox(height: 16),
        _BodyText('For questions about these terms, contact us at rakhshwear@hotmail.com.'),
      ],
    );
  }
}

// ─── COMPANY PAGES ─────────────────────────────────────────────────────────────

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'About Us',
      children: [
        _BodyText(
          'RakhshWear is a premium Pakistani fashion brand born from the belief that style should be '
          'accessible, authentic, and crafted with intention. Founded in Lahore, we bring together '
          'the richness of traditional craftsmanship with the edge of contemporary design.',
        ),
        _SectionTitle('Our Story'),
        _BodyText(
          'The idea behind RakhshWear began at a family dining table — a shared frustration that quality '
          'Pakistani menswear was either too formal, too generic, or too expensive. We set out to build '
          'something different: clothing that carries pride, identity, and a confidence that\'s uniquely our own.\n\n'
          'We launched our first collection with a handful of kurtas and a small social following. Today, '
          'we serve thousands of customers across Pakistan and internationally.',
        ),
        _SectionTitle('What We Stand For'),
        _BulletList(const [
          'Quality over quantity — every piece is made to last.',
          'Authenticity — designs rooted in Pakistani heritage with a modern edge.',
          'Accessibility — premium fashion at fair prices.',
          'Customer care — we treat every customer like a member of our community.',
        ]),
        _SectionTitle('Our Range'),
        _BodyText(
          'From crisp everyday shirts and tailored trousers to cozy knitwear and statement outerwear, '
          'our collections are built to dress you for every moment — whether it\'s a board meeting, a festive dinner, '
          'or a casual weekend out.',
        ),
      ],
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'Privacy Policy',
      children: [
        _BodyText(
          'At RakhshWear, your privacy is of the utmost importance to us. This Privacy Policy explains '
          'how we collect, use, and protect your personal information when you use our website and services.',
        ),
        _SectionTitle('1. Information We Collect'),
        _BulletList(const [
          'Name, email address, and phone number when you register or place an order.',
          'Delivery address provided for shipment purposes.',
          'Payment details (processed securely; we do not store card information).',
          'Browsing behavior and device information for site analytics (anonymized).',
        ]),
        _SectionTitle('2. How We Use Your Information'),
        _BulletList(const [
          'To process and deliver your orders.',
          'To send order confirmations, tracking updates, and customer service messages.',
          'To send promotional offers or newsletters — only if you have opted in.',
          'To improve our website experience based on usage patterns.',
        ]),
        _SectionTitle('3. Data Security'),
        _BodyText(
          'We use industry-standard encryption (SSL) to secure all data transmissions. '
          'Your personal data is stored on secure servers and is never sold to third parties.',
        ),
        _SectionTitle('4. Cookies'),
        _BodyText(
          'We use cookies to enhance your browsing experience and remember your preferences. '
          'You can disable cookies through your browser settings, though this may affect site functionality.',
        ),
        _SectionTitle('5. Third-Party Services'),
        _BodyText(
          'We may use trusted third-party services for payment processing and courier tracking. '
          'These services operate under their own privacy policies and we are not responsible for their data practices.',
        ),
        _SectionTitle('6. Your Rights'),
        _BodyText(
          'You have the right to request access to, correction of, or deletion of your personal data at any time. '
          'Contact us at rakhshwear@hotmail.com to exercise these rights.',
        ),
      ],
    );
  }
}

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'Payment Methods',
      children: [
        _BodyText(
          'We offer a variety of secure and convenient payment options to make shopping at RakhshWear '
          'as smooth as possible.',
        ),
        _SectionTitle('Available Payment Methods'),
        _InfoCard(
          icon: Icons.money,
          title: 'Cash on Delivery (COD)',
          body: 'Pay in cash when your order arrives at your doorstep. Available nationwide across Pakistan. '
              'No upfront payment required.',
        ),
        _InfoCard(
          icon: Icons.phone_android,
          title: 'EasyPaisa',
          body: 'Send payment to our registered EasyPaisa account. Account details will be shared at checkout. '
              'Confirmation is made within 30 minutes.',
        ),
        _InfoCard(
          icon: Icons.smartphone,
          title: 'JazzCash',
          body: 'Fast and easy mobile wallet payment. Send to our JazzCash number provided at checkout.',
        ),
        _InfoCard(
          icon: Icons.account_balance,
          title: 'Bank Transfer',
          body: 'Transfer payment directly to our bank account. Please send a screenshot or receipt to '
              'rakhshwear@hotmail.com to confirm your payment.',
        ),
        _SectionTitle('Payment Security'),
        _BodyText(
          'All digital transactions are secured with SSL encryption. We never store your card or wallet credentials. '
          'If you experience any payment issue, please contact us immediately.',
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.contact_support_outlined,
          title: 'Payment Support',
          body: 'Facing an issue? WhatsApp us at 03369696969 — Mon to Fri, 9:30 AM – 5:30 PM.',
        ),
      ],
    );
  }
}

class CustomerServicesPage extends StatelessWidget {
  const CustomerServicesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'Customer Services',
      children: [
        _BodyText(
          'Our team is here to help you with any queries, concerns, or feedback. '
          'We are committed to providing a seamless shopping experience from the moment you browse to the moment your order arrives.',
        ),
        _SectionTitle('Contact Us'),
        _InfoCard(icon: Icons.phone, title: 'Phone / WhatsApp', body: '03369696969\nMonday–Friday, 9:30 AM – 5:30 PM'),
        _InfoCard(icon: Icons.chat, title: 'WhatsApp', body: '03369696969\nAvailable 7 days a week, 10:00 AM – 8:00 PM'),
        _InfoCard(icon: Icons.email_outlined, title: 'Email', body: 'rakhshwear@hotmail.com\nWe respond within 24 hours on working days.'),
        _SectionTitle('What We Can Help With'),
        _BulletList(const [
          'Order placement and tracking',
          'Size and fit recommendations',
          'Exchange and return requests',
          'Payment confirmation',
          'Product availability and restocking updates',
          'Bulk or corporate orders',
          'General feedback and suggestions',
        ]),
        _SectionTitle('Our Promise'),
        _BodyText(
          'Every complaint, query, or compliment is treated with the highest level of attention. '
          'We aim to resolve all issues within one working day. '
          'Your satisfaction is at the heart of everything we do at RakhshWear.',
        ),
      ],
    );
  }
}

class BlogNewsPage extends StatelessWidget {
  const BlogNewsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageLayout(
      title: 'Blog News',
      children: [
        _BodyText(
          'Stay up to date with the latest from RakhshWear — fashion tips, style guides, '
          'behind-the-scenes stories, and new collection announcements.',
        ),
        _SectionTitle('Latest Articles'),
        _BlogCard(
          tag: 'STYLE GUIDE',
          title: 'How to Style a Kurta for Eid — 5 Looks for Every Occasion',
          date: 'February 2025',
          description:
              'From a classic white kurta with straight-cut trousers to an embroidered sherwani for the main day, '
              'we break down the best Eid looks for men this season.',
        ),
        _BlogCard(
          tag: 'NEW ARRIVAL',
          title: 'Winter 2025 Collection Is Here',
          date: 'January 2025',
          description:
              'Our Winter 2025 collection features heavyweight knitwear, wool-blend sweaters, and layering-friendly '
              'outerwear pieces inspired by Lahore\'s cool-season palette.',
        ),
        _BlogCard(
          tag: 'TIPS',
          title: 'The Complete Guide to Caring for Your Clothes',
          date: 'December 2024',
          description:
              'Extend the life of your wardrobe with our comprehensive care guide — from washing temperatures '
              'and ironing techniques to proper storage of delicate fabrics.',
        ),
        _BlogCard(
          tag: 'BRAND STORY',
          title: 'Why We Started RakhshWear',
          date: 'November 2024',
          description:
              'A founder\'s note on why RakhshWear was created, what drives our design philosophy, '
              'and what\'s next for the brand.',
        ),
        const SizedBox(height: 16),
        _BodyText('More articles coming soon. Follow us on Instagram and Facebook for the latest updates.'),
      ],
    );
  }
}

class _BlogCard extends StatelessWidget {
  final String tag;
  final String title;
  final String date;
  final String description;
  const _BlogCard({required this.tag, required this.title, required this.date, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(tag, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ),
              const SizedBox(width: 12),
              Text(date, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          Text(description, style: GoogleFonts.montserrat(fontSize: 14, height: 1.7, color: Colors.black87)),
        ],
      ),
    );
  }
}
