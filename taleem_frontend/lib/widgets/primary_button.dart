import 'package:flutter/material.dart';
import '../theme.dart';
import 'animations.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final bool useGradient;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.useGradient = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return Pressable(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: fullWidth ? double.infinity : null,
        height: 54,
        child: Opacity(
          opacity: disabled ? 0.6 : 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: useGradient && color == null ? kPurpleGradient : null,
              color: color ?? (useGradient ? null : AppColors.brandPurple),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: (color ?? AppColors.purple500).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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

class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          backgroundColor: AppColors.surface(context),
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColors.textBody),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
