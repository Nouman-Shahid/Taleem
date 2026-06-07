import 'package:flutter/material.dart';

class LessonTile extends StatelessWidget {
  final String mainText;
  final String? subText;
  final Color tint;
  final Color foreground;
  final double fontSize;
  final VoidCallback onTap;

  const LessonTile({
    super.key,
    required this.mainText,
    this.subText,
    required this.tint,
    required this.foreground,
    this.fontSize = 32,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: foreground.withValues(alpha: 0.15), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mainText,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: foreground,
                ),
              ),
              if (subText != null) ...[
                const SizedBox(height: 2),
                Text(
                  subText!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: foreground.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
