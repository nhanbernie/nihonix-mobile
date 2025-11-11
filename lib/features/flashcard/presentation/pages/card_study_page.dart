import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class CardStudyPage extends StatefulWidget {
  final String setId;
  final String setName;

  const CardStudyPage({
    super.key,
    required this.setId,
    required this.setName,
  });

  @override
  State<CardStudyPage> createState() => _CardStudyPageState();
}

class _CardStudyPageState extends State<CardStudyPage> {
  int _currentCardIndex = 0;
  bool _isFlipped = false;

  // Hardcoded demo data
  final List<Map<String, String>> _cards = [
    {'front': '犬', 'back': 'inu - con chó'},
    {'front': '猫', 'back': 'neko - con mèo'},
    {'front': '鳥', 'back': 'tori - con chim'},
  ];

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _nextCard() {
    if (_currentCardIndex < _cards.length - 1) {
      setState(() {
        _currentCardIndex++;
        _isFlipped = false;
      });
    }
  }

  void _previousCard() {
    if (_currentCardIndex > 0) {
      setState(() {
        _currentCardIndex--;
        _isFlipped = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = _cards[_currentCardIndex];

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
                        '${_currentCardIndex + 1} / ${_cards.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${((_currentCardIndex + 1) / _cards.length * 100).toInt()}%',
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
                    value: (_currentCardIndex + 1) / _cards.length,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s40),

            // Flashcard
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      final rotate = Tween(begin: 0.0, end: 1.0).animate(animation);
                      return AnimatedBuilder(
                        animation: rotate,
                        child: child,
                        builder: (context, child) {
                          final angle = rotate.value * 3.14159;
                          final isUnder = angle > 1.5708;
                          return Transform(
                            transform: Matrix4.rotationY(angle),
                            alignment: Alignment.center,
                            child: isUnder
                                ? Transform(
                                    transform: Matrix4.rotationY(3.14159),
                                    alignment: Alignment.center,
                                    child: child,
                                  )
                                : child,
                          );
                        },
                      );
                    },
                    child: _isFlipped
                        ? _buildCard(
                            key: const ValueKey('back'),
                            text: currentCard['back']!,
                            isBack: true,
                          )
                        : _buildCard(
                            key: const ValueKey('front'),
                            text: currentCard['front']!,
                            isBack: false,
                          ),
                  ),
                ),
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
                    onPressed: _currentCardIndex < _cards.length - 1 ? _nextCard : null,
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
              ? [AppColors.accent2.withValues(alpha: 0.2), AppColors.accent1.withValues(alpha: 0.2)]
              : [AppColors.primary.withValues(alpha: 0.2), AppColors.accent3.withValues(alpha: 0.2)],
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
          child: Text(
            text,
            style: TextStyle(
              fontSize: isBack ? 20 : 48,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
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

