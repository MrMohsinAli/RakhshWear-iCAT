import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';
import 'package:smart_ecommerce_app/screens/home_screen.dart';
import 'package:smart_ecommerce_app/widgets/primary_button.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  
  int _currentStep = 0; // 0: Shipping, 1: Payment
  String _selectedPayment = 'COD'; // Default
  bool _isLoading = false;

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() => _currentStep = 1);
    }
  }

  void _placeOrder() async {
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      context.read<CartProvider>().clearCart();
      setState(() => _isLoading = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Order Placed!', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          content: Text('Your order has been placed successfully using $_selectedPayment. You will receive an email confirmation shortly.'),
          actions: [
            PrimaryButton(
              label: 'CONTINUE SHOPPING',
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  FadeSlideRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              width: 210,
              height: 42,
              bgColor: Colors.white,
              textColor: const Color(0xFF37474F),
              borderColor: const Color(0xFF37474F),
              hoverBgColor: const Color(0xFF37474F),
              hoverTextColor: Colors.white,
              borderRadius: 30,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final bool isMobile = MediaQuery.of(context).size.width < 900;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('CHECKOUT', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 40),
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),
            const SizedBox(height: 48),
            
            Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Step Content
                Expanded(
                  flex: isMobile ? 0 : 3,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _currentStep == 0 
                        ? _buildShippingForm() 
                        : _buildPaymentMethod(),
                  ),
                ),

                if (!isMobile) const SizedBox(width: 48),
                if (isMobile) const SizedBox(height: 40),
                
                // Right Side: Order Summary
                if (isMobile)
                  SizedBox(
                    width: double.infinity,
                    child: _buildSummary(cart),
                  )
                else
                  Expanded(
                    flex: 2,
                    child: _buildSummary(cart),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepDot('Shipping', _currentStep >= 0),
        Container(width: 40, height: 1.5, color: _currentStep == 1 ? Colors.black : Colors.grey.shade300),
        _buildStepDot('Payment', _currentStep == 1),
      ],
    );
  }

  Widget _buildStepDot(String label, bool isActive) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 12, height: 12,
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.transparent,
            border: Border.all(color: isActive ? Colors.black : Colors.grey.shade400, width: 2),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text(label.toUpperCase(), style: GoogleFonts.montserrat(
          fontSize: 10, 
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          color: isActive ? Colors.black : Colors.grey,
        )),
      ],
    );
  }

  Widget _buildShippingForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SHIPPING DETAILS', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 32),
          CheckoutTextField(controller: _nameController, label: 'Full Name', icon: Icons.person),
          const SizedBox(height: 20),
          CheckoutTextField(controller: _addressController, label: 'Detailed Address', icon: Icons.location_on),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: CheckoutTextField(controller: _cityController, label: 'City', icon: Icons.location_city)),
              const SizedBox(width: 16),
              Expanded(child: CheckoutTextField(controller: _phoneController, label: 'Phone Number', icon: Icons.phone_android)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CHOOSE PAYMENT METHOD', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 32),
        _PaymentOption(
          id: 'COD',
          icon: Icons.money, 
          label: 'Cash on Delivery (COD)', 
          desc: 'Pay when you receive your parcel',
          isSelected: _selectedPayment == 'COD',
          onTap: () => setState(() => _selectedPayment = 'COD'),
        ),
        const SizedBox(height: 16),
        _PaymentOption(
          id: 'JazzCash',
          icon: Icons.account_balance_wallet, 
          label: 'JazzCash', 
          desc: 'Instant payment via JazzCash App/USSD',
          color: const Color(0xFFED1C24),
          isSelected: _selectedPayment == 'JazzCash',
          onTap: () => setState(() => _selectedPayment = 'JazzCash'),
        ),
        const SizedBox(height: 16),
        _PaymentOption(
          id: 'EasyPaisa',
          icon: Icons.account_balance_wallet, 
          label: 'EasyPaisa', 
          desc: 'Instant payment via EasyPaisa Wallet',
          color: const Color(0xFF00C853),
          isSelected: _selectedPayment == 'EasyPaisa',
          onTap: () => setState(() => _selectedPayment = 'EasyPaisa'),
        ),
      ],
    );
  }

  Widget _buildSummary(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR ORDER',
            style: GoogleFonts.montserrat(
              textStyle: Theme.of(context).textTheme.titleLarge,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 24),
          ...cart.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Expanded(child: Text('${item.product.title} (x${item.quantity})', style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey.shade800))),
                 const SizedBox(width: 16),
                 RichText(
                   text: TextSpan(
                     text: 'PKR ',
                     style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                     children: [
                       TextSpan(
                         text: item.totalPrice.toStringAsFixed(0),
                         style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                       ),
                     ],
                   ),
                 ),
              ],
            ),
          )),
          const Divider(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL AMOUNT', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold)),
              RichText(
                text: TextSpan(
                  text: 'PKR ',
                  style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade700),
                  children: [
                    TextSpan(
                      text: cart.totalAmount.toStringAsFixed(0),
                      style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            height: 54,
            label: _currentStep == 0 ? 'PROCEED TO PAYMENT' : 'PLACE ORDER',
            onPressed: _isLoading ? null : (_currentStep == 0 ? _nextStep : _placeOrder),
            isLoading: _isLoading,
            bgColor: _currentStep == 0 ? Colors.white : Colors.black,
            textColor: _currentStep == 0 ? Colors.black : Colors.white,
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String id;
  final IconData icon;
  final String label;
  final String desc;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.id,
    required this.icon, 
    required this.label, 
    required this.desc,
    this.isSelected = false, 
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
             color: isSelected ? const Color(0xFFF8F8F8) : Colors.white,
             border: Border.all(
               color: isSelected ? Colors.black : Colors.grey.shade300, 
               width: 1.5,
             ),
          ),
          child: Row(
            children: [
               Container(
                 padding: const EdgeInsets.all(10),
                 color: (color ?? Colors.grey.shade800).withValues(alpha: 0.1),
                 child: Icon(icon, color: color ?? Colors.grey.shade800, size: 24),
               ),
               const SizedBox(width: 20),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(label, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14)),
                     const SizedBox(height: 4),
                     Text(desc, style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey.shade600)),
                   ],
                 ),
               ),
               AnimatedOpacity(
                 opacity: isSelected ? 1.0 : 0.0,
                 duration: const Duration(milliseconds: 250),
                 curve: Curves.easeInOut,
                 child: const Icon(Icons.check_circle, color: Colors.black, size: 22),
               ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const CheckoutTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  State<CheckoutTextField> createState() => _CheckoutTextFieldState();
}

class _CheckoutTextFieldState extends State<CheckoutTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      style: GoogleFonts.montserrat(fontSize: 14),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon, size: 20, color: Colors.grey.shade600),
        labelStyle: GoogleFonts.montserrat(color: Colors.grey.shade600, fontSize: 13),
        filled: true,
        fillColor: _isFocused ? Colors.white : const Color(0xFFF5F5F5),
        hoverColor: Colors.transparent,
        border: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.black)),
        errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.red, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (v) => v!.isEmpty ? 'Field required' : null,
    );
  }
}
