import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubcategoryCard extends StatefulWidget {
  final String title;
  final String categoryId;
  final VoidCallback? onTap;
  final List<String> images;
  final Duration waveDelay;

  const SubcategoryCard({
    super.key,
    required this.title,
    required this.categoryId,
    this.onTap,
    this.images = const [],
    this.waveDelay = Duration.zero,
  });

  @override
  State<SubcategoryCard> createState() => _SubcategoryCardState();
}

class _SubcategoryCardState extends State<SubcategoryCard>
    with TickerProviderStateMixin {
  // Hover animation
  late final AnimationController _hoverCtrl;
  late final Animation<double> _scaleAnim;
  bool _isHovering = false;

  int _currentIndex = 0;
  int _nextIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Hover scale
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));

    if (widget.images.length > 1) {
      Future.delayed(widget.waveDelay, () {
        if (mounted) _startSlideshow();
      });
    }
  }

  void _startSlideshow() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || widget.images.length <= 1) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hoverCtrl.dispose();
    super.dispose();
  }

  String _imageAt(int index) {
    if (widget.images.isEmpty) return '';
    return widget.images[index % widget.images.length];
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovering = true);
        _hoverCtrl.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _hoverCtrl.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 175,
          height: 215,
          margin: const EdgeInsets.only(right: 12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Cross-fade image stack
              ScaleTransition(
                scale: _scaleAnim,
                child: Stack(
                  fit: StackFit.expand,
                  children: List.generate(widget.images.length, (i) {
                    return AnimatedOpacity(
                      opacity: i == _currentIndex ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      child: _buildImage(i),
                    );
                  }),
                ),
              ),

              // ── Gradient overlay
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: _isHovering ? 0.45 : 0.62),
                    ],
                    stops: const [0.38, 1.0],
                  ),
                ),
              ),

              //Label
              Positioned(
                left: 12,
                right: 12,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title.toUpperCase(),
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        height: 1.3,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      margin: const EdgeInsets.only(top: 5),
                      height: 1.5,
                      width: _isHovering ? 28.0 : 0.0,
                      color: Colors.white,
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

  Widget _buildImage(int index) {
    final img = _imageAt(index);
    if (img.isEmpty) return Container(color: Colors.grey.shade300);
    if (img.startsWith('http')) {
      return Image.network(img, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300));
    }
    return Image.asset(img, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300));
  }
}
