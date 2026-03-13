
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';
import 'package:smart_ecommerce_app/widgets/logo.dart';
import 'package:smart_ecommerce_app/widgets/menu_drawer.dart';
import 'package:smart_ecommerce_app/widgets/search_modal.dart' show SearchOverlay;
import 'package:smart_ecommerce_app/screens/cart_screen.dart';
import 'package:smart_ecommerce_app/services/mock_data_service.dart';
import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:smart_ecommerce_app/screens/product_listing_page.dart';
import 'package:smart_ecommerce_app/screens/login_screen.dart';
import 'package:smart_ecommerce_app/models/data_models.dart';

class WebLayout extends StatefulWidget {
  final Widget body;

  const WebLayout({super.key, required this.body});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  final _drawerOpenNotifier = ValueNotifier<bool>(false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _drawerOpenNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: MenuDrawer(),
      onDrawerChanged: (isOpen) {
        _drawerOpenNotifier.value = isOpen;
      },
      body: ValueListenableBuilder<bool>(
        valueListenable: _drawerOpenNotifier,
        builder: (context, isOpen, _) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: isOpen ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            builder: (context, t, _) {
              return Stack(
                children: [
                  // ── Translated content (slides right as drawer opens) ──
                  Transform.translate(
                    offset: Offset(60 * t, 0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            const _AnnouncementBar(),
                            _NavBar(
                              drawerOpenNotifier: _drawerOpenNotifier,
                              scaffoldKey: _scaffoldKey,
                            ),
                            Expanded(child: widget.body),
                          ],
                        ),
                        // ── White light overlay ────────────────────────────
                        if (t > 0)
                          IgnorePointer(
                            child: Container(
                              color: Colors.white.withValues(alpha: 0.55 * t),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // ── Dim overlay ────────────────────────────────────────
                  if (t > 0)
                    GestureDetector(
                      onTap: () {
                        _drawerOpenNotifier.value = false;
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.18 * t),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _AnnouncementBar extends StatefulWidget {
  const _AnnouncementBar();

  @override
  State<_AnnouncementBar> createState() => _AnnouncementBarState();
}

class _AnnouncementBarState extends State<_AnnouncementBar>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  AnimationController? _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || _ctrl == null) return const SizedBox.shrink();

    return Material(
      color: const Color(0xFF37474F),
      child: SizedBox(
        height: 24,
        width: double.infinity,
        child: Stack(
          children: [
            // ── The Scrolling Ticker ─────────────────────────────────────
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _ctrl!,
                builder: (context, child) {
                  return OverflowBox(
                    maxWidth: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: FractionalTranslation(
                      translation: Offset(-_ctrl!.value * (1 / 20), 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(20, (i) => _buildAnnouncement()),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Gradient Fades (Left/Right) ──────────────────────────────
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 40,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF37474F),
                      Color(0x0037474F),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 40,
              top: 0,
              bottom: 0,
              width: 40,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color(0xFF37474F),
                      Color(0x0037474F),
                    ],
                  ),
                ),
              ),
            ),

            // ── Close Button ─────────────────────────────────────────────
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF37474F),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF37474F),
                        blurRadius: 10,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 16),
                    onPressed: () => setState(() => _isVisible = false),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Text(
        'FREE SHIPPING ON ORDERS ABOVE PKR 3000',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _NavBar extends StatefulWidget {
  final ValueNotifier<bool> drawerOpenNotifier;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _NavBar({required this.drawerOpenNotifier, required this.scaffoldKey});

  @override
  State<_NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<_NavBar> {
  OverlayEntry? _searchOverlayEntry;
  final GlobalKey _navBarKey = GlobalKey();

  void _openSearch() {
    if (_searchOverlayEntry != null) return;

    // Measure where the bottom of the navbar is
    final RenderBox? renderBox =
        _navBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final navbarBottom =
        renderBox.localToGlobal(Offset(0, renderBox.size.height)).dy;

    _searchOverlayEntry = OverlayEntry(
      builder: (context) => SearchOverlay(
        navbarBottom: navbarBottom,
        onClose: _closeSearch,
      ),
    );

    Overlay.of(context).insert(_searchOverlayEntry!);
  }

  void _closeSearch() {
    _searchOverlayEntry?.remove();
    _searchOverlayEntry = null;
  }

  @override
  void dispose() {
    _closeSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 950;

    return Material(
      key: _navBarKey,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(
          left: 0,
          right: isMobile ? 12 : 32,
          top: 12,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: isMobile ? 12 : 20),
            // Far Left: Hamburger Menu
            SelectionContainer.disabled(
              child: IconButton(
                onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu, size: 28, color: Colors.black),
              ),
            ),

            const SizedBox(width: 12),

            // Logo
            const RakhshLogo(size: 32, dark: true),

            if (!isMobile) ...[
              const SizedBox(width: 8),
              // Center: Horizontal Categories Menu Slider (Constrained)
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 950),
                    child: _HorizontalMenu(),
                  ),
                ),
              ),
            ] else
              const Spacer(),

            const SizedBox(width: 8),

            // Right Icons: Search, Login, Cart
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search Icon
                _NavBarIcon(
                  icon: Icons.search,
                  tooltip: 'Search',
                  onTap: _openSearch,
                ),
                SizedBox(width: isMobile ? 4 : 8),
                // Login/User Icon
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return _NavBarIcon(
                      icon: auth.isLoggedIn ? Icons.person : Icons.person_outlined,
                      isActive: auth.isLoggedIn,
                      tooltip: auth.isLoggedIn ? auth.userName : 'Login / Signup',
                      onTap: () {
                        if (auth.isLoggedIn) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Logout', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
                              content: Text('Are you sure you want to log out, ${auth.userName}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    auth.logout();
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('LOGOUT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            FadeSlideRoute(builder: (context) => const LoginScreen()),
                          );
                        }
                      },
                    );
                  },
                ),
                SizedBox(width: isMobile ? 4 : 8),
                // Cart Icon
                const _NavBarCartIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final String? tooltip;

  const _NavBarIcon({
    required this.icon, 
    required this.onTap, 
    this.isActive = false,
    this.tooltip,
  });

  @override
  State<_NavBarIcon> createState() => _NavBarIconState();
}

class _NavBarIconState extends State<_NavBarIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Tooltip(
          message: widget.tooltip ?? '',
          waitDuration: const Duration(milliseconds: 500),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _isHovering ? Colors.black.withValues(alpha: 0.05) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 6,
                          spreadRadius: 0.5,
                        )
                      ]
                    : null,
              ),
              child: Icon(
                widget.icon, 
                size: widget.isActive ? 24 : 22, 
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarCartIcon extends StatefulWidget {
  const _NavBarCartIcon();

  @override
  State<_NavBarCartIcon> createState() => _NavBarCartIconState();
}

class _NavBarCartIconState extends State<_NavBarCartIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Tooltip(
          message: 'Cart',
          waitDuration: const Duration(milliseconds: 500),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _isHovering ? Colors.black.withValues(alpha: 0.05) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 22, color: Colors.black),
                      if (cart.itemCount > 0)
                        Positioned(
                          top: -6,
                          right: -6,
                          child: Container(
                            width: 16,
                            height: 16,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizontalMenu extends StatefulWidget {
  const _HorizontalMenu();

  @override
  State<_HorizontalMenu> createState() => _HorizontalMenuState();
}

class _HorizontalMenuState extends State<_HorizontalMenu> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<String?> _hoveredCategoryIdNotifier = ValueNotifier<String?>(null);
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateArrows();
    });
    _scrollController.addListener(_updateArrows);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrows);
    _scrollController.dispose();
    _hoveredCategoryIdNotifier.dispose();
    super.dispose();
  }

  void _updateArrows() {
    if (!_scrollController.hasClients) return;
    setState(() {
      _showLeftArrow = _scrollController.position.pixels > 5;
      _showRightArrow = _scrollController.position.pixels < _scrollController.position.maxScrollExtent - 5;
    });
  }

  void _scroll(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showLeftArrow)
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20, color: Colors.black),
            onPressed: () => _scroll(-200),
          ),
        Flexible(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: MockDataService.categories.map((category) {
                return _MenuNavLink(
                  category: category,
                  hoverNotifier: _hoveredCategoryIdNotifier,
                );
              }).toList(),
            ),
          ),
        ),
        if (_showRightArrow)
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20, color: Colors.black),
            onPressed: () => _scroll(200),
          ),
      ],
    );
  }
}

class _MenuNavLink extends StatefulWidget {
  final Category category;
  final ValueNotifier<String?> hoverNotifier;

  const _MenuNavLink({required this.category, required this.hoverNotifier});

  @override
  State<_MenuNavLink> createState() => _MenuNavLinkState();
}

class _MenuNavLinkState extends State<_MenuNavLink> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    widget.hoverNotifier.addListener(_handleHoverChange);
  }

  @override
  void dispose() {
    widget.hoverNotifier.removeListener(_handleHoverChange);
    _hideDropdown();
    super.dispose();
  }

  void _handleHoverChange() {
    if (widget.hoverNotifier.value != widget.category.id) {
      _hideDropdown();
    }
    if (mounted) setState(() {});
  }

  bool get _isHovered => widget.hoverNotifier.value == widget.category.id;

  void _showDropdown() {
    if (widget.category.subcategories.isEmpty) return;
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 170,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: MouseRegion(
            onEnter: (_) => widget.hoverNotifier.value = widget.category.id,
            onExit: (event) {
              if (event.localPosition.dy > 0 ||
                  event.localPosition.dx < 0 ||
                  event.localPosition.dx > 170) {
                widget.hoverNotifier.value = null;
              }
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.92 + 0.08 * value,
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Material(
                elevation: 4,
                shadowColor: Colors.black26,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade100, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.category.subcategories.map((sub) {
                    return _SubcategoryDropdownItem(
                      text: sub,
                      onTap: () {
                        _hideDropdown();
                        widget.hoverNotifier.value = null;
                        Navigator.push(
                          context,
                          FadeSlideRoute(
                            builder: (context) => WebLayout(
                              body: ProductListingPage(
                                categoryId: widget.category.id,
                                subcategory: sub,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          widget.hoverNotifier.value = widget.category.id;
          _showDropdown();
        },
        onExit: (event) {
          // If moving upwards or to the sides, clear hover. 
          // If dy > height, we are moving into the dropdown.
          if (renderBox != null) {
            if (event.localPosition.dy < 0 || 
                event.localPosition.dx < 0 || 
                event.localPosition.dx > renderBox.size.width) {
              widget.hoverNotifier.value = null;
            }
          }
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              FadeSlideRoute(
                builder: (context) => WebLayout(
                  body: ProductListingPage(
                    categoryId: widget.category.id,
                  ),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category.title.toUpperCase(),
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: _isHovered ? Colors.black : Colors.grey.shade700,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(height: 4),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 1.5,
                      width: _isHovered ? double.infinity : 0,
                      decoration: BoxDecoration(
                        color: _isHovered ? Colors.black : Colors.transparent,
                      ),
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

class _SubcategoryDropdownItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _SubcategoryDropdownItem({required this.text, required this.onTap});

  @override
  State<_SubcategoryDropdownItem> createState() => _SubcategoryDropdownItemState();
}

class _SubcategoryDropdownItemState extends State<_SubcategoryDropdownItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.text,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: _isHovering ? FontWeight.w600 : FontWeight.w500,
                    color: _isHovering ? Colors.black : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.only(top: 4),
                  height: 1.5,
                  width: _isHovering ? 28.0 : 0,
                  decoration: BoxDecoration(
                    color: _isHovering ? Colors.black : Colors.transparent,
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
