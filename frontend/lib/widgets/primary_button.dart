import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final double? width;
  final bool isLoading;

  final Color? bgColor;
  final Color? hoverBgColor;
  final Color? textColor;
  final Color? hoverTextColor;
  final Color? borderColor;
  final double borderRadius;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.height = 50,
    this.width,
    this.isLoading = false,
    this.bgColor,
    this.hoverBgColor,
    this.textColor,
    this.hoverTextColor,
    this.borderColor,
    this.borderRadius = 0,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    final Color defaultBg = widget.bgColor ?? Colors.white;
    final Color defaultText = widget.textColor ?? (widget.bgColor == null ? Colors.black : Colors.white);
    // Allow hover to change bg color if requested
    final Color activeBg = _isHovering && widget.hoverBgColor != null 
        ? widget.hoverBgColor! 
        : defaultBg;

    final Color currentBg = _isPressed && activeBg != Colors.white
        ? activeBg.withValues(alpha: 0.8) 
        : (_isPressed && activeBg == Colors.white ? Colors.grey.shade100 : activeBg);
        
    final Color activeText = _isHovering && widget.hoverTextColor != null
        ? widget.hoverTextColor!
        : defaultText;
        
    final Color currentText = currentBg == Colors.white && activeText == Colors.white ? Colors.black : activeText;
    
    final Color currentBorder = _isHovering && widget.hoverBgColor != null
        ? widget.hoverBgColor!
        : (widget.borderColor ?? Colors.black);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: _isPressed && isEnabled ? 0.98 : (_isHovering && isEnabled ? 1.02 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: isEnabled ? (_) {
            setState(() => _isPressed = false);
            widget.onPressed?.call();
          } : null,
          onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: widget.height,
            width: widget.width ?? double.infinity,
            decoration: BoxDecoration(
              color: currentBg,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: currentBorder,
                width: _isPressed ? 2.5 : 1.5,
              ),
              boxShadow: _isPressed && isEnabled
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      )
                    ]
                  : (_isHovering && isEnabled
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : []),
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: currentText,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: 20,
                            color: currentText,
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          widget.label.toUpperCase(),
                          style: GoogleFonts.montserrat(
                            color: currentText,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
