import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../screens/assistant_screen.dart';

class CompanionOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => const CompanionWidget(),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class CompanionWidget extends StatefulWidget {
  const CompanionWidget({super.key});

  @override
  State<CompanionWidget> createState() => _CompanionWidgetState();
}

class _CompanionWidgetState extends State<CompanionWidget> {
  Offset position = const Offset(20, 100);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        onDoubleTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AssistantScreen()),
          );
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceHigh,
            border: Border.all(color: AppColors.cyanGlow, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyanGlow.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.smart_toy, color: AppColors.cyanGlow, size: 30),
          ),
        ),
      ),
    );
  }
}
