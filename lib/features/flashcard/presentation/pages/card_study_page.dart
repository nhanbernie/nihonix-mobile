import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import '../../domain/entities/flashcard.dart';
import '../providers/set_cards_provider.dart';

class CardStudyPage extends ConsumerStatefulWidget {
  final String setId;
  final String setName;

  const CardStudyPage({
    super.key,
    required this.setId,
    required this.setName,
  });

  @override
  ConsumerState<CardStudyPage> createState() => _CardStudyPageState();
}

class _CardStudyPageState extends ConsumerState<CardStudyPage> {
  int _currentCardIndex = 0;
  late PageController _pageController;
  Map<int, FlipCardController> _flipControllers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initializeControllers(int cardCount) {
    if (_flipControllers.isEmpty || _flipControllers.length != cardCount) {
      _flipControllers = {
        for (var i = 0; i < cardCount; i++) i: FlipCardController()
      };
    }
  }

  void _flipCard() {
    final controller = _flipControllers[_currentCardIndex];
    if (controller != null) {
      controller.toggleCard();
      print('DEBUG: Flipping card at index $_currentCardIndex');
    } else {
      print('DEBUG: FlipCard controller is null for index $_currentCardIndex');
    }
  }

  void _nextCard(int maxCards) {
    if (_currentCardIndex < maxCards - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousCard() {
    if (_currentCardIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(setCardsProvider(widget.setId));

    return cardsAsync.when(
      data: (cards) => _buildStudyContent(cards),
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  Widget _buildLoadingState() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            widget.setName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            widget.setName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
              const SizedBox(height: AppSizes.s16),
              Text(
                'Lỗi: $error',
                style: TextStyle(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.s16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(setCardsProvider(widget.setId));
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudyContent(List<Flashcard> cards) {
    // Initialize controllers for all cards
    _initializeControllers(cards.length);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            widget.setName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.s16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_currentCardIndex + 1} / ${cards.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${((_currentCardIndex + 1) / cards.length * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s8),
                  LinearProgressIndicator(
                    value: (_currentCardIndex + 1) / cards.length,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s40),

            // Flashcard with PageView for swipe
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final currentCard = cards[index];
                  final flipController = _flipControllers[index]!;

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        // Scale effect: zoom out khi kéo, zoom in khi về giữa
                        value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                      }

                      return Center(
                        child: Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: FlipCard(
                      controller: flipController,
                      flipOnTouch: true, // TEST: Enable tap on card to flip
                      direction: FlipDirection.HORIZONTAL,
                      speed: 300,
                      front: _buildCard(
                        key: ValueKey('front-$index'),
                        text: currentCard.front.text,
                        meaning: currentCard.front.meaning,
                        isBack: false,
                      ),
                      back: _buildCard(
                        key: ValueKey('back-$index'),
                        text: currentCard.back.text,
                        meaning: currentCard.back.meaning,
                        isBack: true,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Previous Button
                  _buildNavButton(
                    icon: Icons.arrow_back,
                    onPressed: _currentCardIndex > 0 ? _previousCard : null,
                  ),

                  // Flip Button
                  _buildFlipButton(),

                  // Next Button
                  _buildNavButton(
                    icon: Icons.arrow_forward,
                    onPressed: _currentCardIndex < cards.length - 1
                        ? () => _nextCard(cards.length)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required Key key,
    required String text,
    String? meaning,
    required bool isBack,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isBack
              ? [
                  AppColors.accent2.withValues(alpha: 0.2),
                  AppColors.accent1.withValues(alpha: 0.2)
                ]
              : [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.accent3.withValues(alpha: 0.2)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.s32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: isBack ? 24 : 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              if (meaning != null && meaning.isNotEmpty) ...[
                const SizedBox(height: AppSizes.s16),
                Text(
                  meaning,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: onPressed != null ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: onPressed != null ? Colors.black87 : Colors.grey.shade400,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildFlipButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent3],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.flip),
        color: Colors.white,
        iconSize: 28,
        onPressed: _flipCard,
      ),
    );
  }
}
