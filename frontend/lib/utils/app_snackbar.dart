import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSnackBar {
  AppSnackBar._();

  //Colours 
  static const Color _successBg = Color(0xFF2E7D32); // shade of green
  static const Color _errorBg   = Color(0xFFC62828); // deep red
  static const Color _infoBg    = Color(0xFF37474F); // dark blue-grey

  //Public API 
  static void success(BuildContext context, String message) =>
      _show(context, message, _successBg, Icons.check_circle_outline, _Anim.none);

  static void error(BuildContext context, String message) =>
      _show(context, message, _errorBg, Icons.error_outline, _Anim.shake);

  static void info(BuildContext context, String message) =>
      _show(context, message, _infoBg, Icons.info_outline, _Anim.bounce);

  //Core builder
  static void _show(
    BuildContext context,
    String message,
    Color bg,
    IconData icon,
    _Anim anim,
  ) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          padding: EdgeInsets.zero,
          content: _StyledSnackContent(
            message: message,
            bg: bg,
            icon: icon,
            anim: anim,
          ),
        ),
      );
  }
}

enum _Anim { none, shake, bounce, pulse }

/// The actual visual widget shown inside the snack-bar.
class _StyledSnackContent extends StatefulWidget {
  final String message;
  final Color bg;
  final IconData icon;
  final _Anim anim;

  const _StyledSnackContent({
    required this.message,
    required this.bg,
    required this.icon,
    required this.anim,
  });

  @override
  State<_StyledSnackContent> createState() => _StyledSnackContentState();
}

class _StyledSnackContentState extends State<_StyledSnackContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  late final Animation<double> _shake;  //(success)
  late final Animation<double> _bounce; //(info)
  late final Animation<double> _pulse;  //(error)

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: widget.anim == _Anim.none
          ? const Duration(milliseconds: 320)
          : const Duration(milliseconds: 560),
    );

    // Fade + scale pop-in
    final popInterval = const Interval(0.0, 0.35, curve: Curves.easeOutBack);
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: popInterval),
    );
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: popInterval),
    );

    // Error: horizontal shake
    if (widget.anim == _Anim.shake) {
      _shake = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0, end: -1), weight: 1),
        TweenSequenceItem(tween: Tween(begin: -1, end: 1), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 1, end: -0.7), weight: 2),
        TweenSequenceItem(tween: Tween(begin: -0.7, end: 0.5), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 0.5, end: 0), weight: 1),
      ]).animate(
        CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.35, 1.0, curve: Curves.easeInOut)),
      );
    } else {
      _shake = const AlwaysStoppedAnimation(0.0);
    }

    // Info: vertical bounce
    if (widget.anim == _Anim.bounce) {
      _bounce = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 20, end: -8), weight: 3),
        TweenSequenceItem(tween: Tween(begin: -8, end: 4), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 4, end: -2), weight: 1),
        TweenSequenceItem(tween: Tween(begin: -2, end: 0), weight: 1),
      ]).animate(
        CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
      );
    } else {
      _bounce = const AlwaysStoppedAnimation(0.0);
    }

    // Success: pulse 
    if (widget.anim == _Anim.pulse) {
      _pulse = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.06), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.06, end: 0.98), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.98, end: 1.0), weight: 1),
      ]).animate(
        CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.35, 0.85, curve: Curves.easeInOut)),
      );
    } else {
      _pulse = const AlwaysStoppedAnimation(1.0);
    }

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return FadeTransition(
          opacity: _opacity,
          child: Transform.scale(
            scale: _scale.value * _pulse.value, // pop-in scale × pulse scale
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(_shake.value * 10, _bounce.value),
              child: child,
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: widget.bg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: widget.bg.withValues(alpha: 0.45),
              blurRadius: 18,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                widget.message,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
