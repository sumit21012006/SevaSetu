import 'package:flutter/material.dart';

// Professional Design System for SevaSetu
class SevaSetuTheme {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryDarkBlue = Color(0xFF1E40AF);
  static const Color secondaryBlue = Color(0xFF60A5FA);

  // Accent Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFFFA726);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Status Colors
  static const Color statusValid = Color(0xFF10B981);
  static const Color statusExpiring = Color(0xFFFFA726);
  static const Color statusExpired = Color(0xFFEF4444);

  // Neutral Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);

  // Typography
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textTertiary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: textTertiary,
  );

  // Spacing
  static const double spacingXS = 4;
  static const double spacingSM = 8;
  static const double spacingMD = 16;
  static const double spacingLG = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;

  // BorderRadius
  static const BorderRadius borderRadiusSM =
      BorderRadius.all(Radius.circular(8));
  static const BorderRadius borderRadiusMD =
      BorderRadius.all(Radius.circular(12));
  static const BorderRadius borderRadiusLG =
      BorderRadius.all(Radius.circular(16));
  static const BorderRadius borderRadiusXL =
      BorderRadius.all(Radius.circular(20));

  // Shadows
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x10000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Color(0x15000000),
      blurRadius: 15,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> strongShadow = [
    BoxShadow(
      color: Color(0x20000000),
      blurRadius: 20,
      offset: Offset(0, 12),
    ),
  ];

  // Elevation
  static const double elevationLow = 1;
  static const double elevationMedium = 3;
  static const double elevationHigh = 6;
}

// Custom Widgets for consistent design
class SevaSetuCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final List<BoxShadow>? boxShadow;

  const SevaSetuCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.color,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(SevaSetuTheme.spacingMD),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? SevaSetuTheme.borderRadiusMD,
        child: Card(
          color: color ?? SevaSetuTheme.surface,
          elevation: SevaSetuTheme.elevationLow,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? SevaSetuTheme.borderRadiusMD,
          ),
          margin: EdgeInsets.zero,
          shadowColor: boxShadow != null
              ? null
              : SevaSetuTheme.primaryBlue.withOpacity(0.1),
          child: content,
        ),
      );
    }

    return Card(
      color: color ?? SevaSetuTheme.surface,
      elevation: SevaSetuTheme.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? SevaSetuTheme.borderRadiusMD,
      ),
      margin: EdgeInsets.zero,
      shadowColor:
          boxShadow != null ? null : SevaSetuTheme.primaryBlue.withOpacity(0.1),
      child: content,
    );
  }
}

class SevaSetuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool isLoading;

  const SevaSetuButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : (icon != null ? Icon(icon, size: 18) : const SizedBox.shrink()),
        label: Text(
          isLoading ? 'Processing...' : text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? SevaSetuTheme.primaryBlue,
          foregroundColor: foregroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: SevaSetuTheme.borderRadiusMD,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SevaSetuTheme.spacingLG,
            vertical: SevaSetuTheme.spacingMD,
          ),
          elevation: SevaSetuTheme.elevationMedium,
          shadowColor:
              (backgroundColor ?? SevaSetuTheme.primaryBlue).withOpacity(0.3),
        ),
      ),
    );
  }
}

class SevaSetuInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final int? maxLines;
  final int? maxLength;

  const SevaSetuInputField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, size: 18),
                onPressed: onSuffixTap,
              )
            : null,
        filled: true,
        fillColor: SevaSetuTheme.surface,
        border: OutlineInputBorder(
          borderRadius: SevaSetuTheme.borderRadiusMD,
          borderSide: BorderSide(color: SevaSetuTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: SevaSetuTheme.borderRadiusMD,
          borderSide: BorderSide(color: SevaSetuTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: SevaSetuTheme.borderRadiusMD,
          borderSide: BorderSide(color: SevaSetuTheme.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: SevaSetuTheme.borderRadiusMD,
          borderSide: BorderSide(color: SevaSetuTheme.errorRed, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: SevaSetuTheme.borderRadiusMD,
          borderSide: BorderSide(color: SevaSetuTheme.errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SevaSetuTheme.spacingMD,
          vertical: SevaSetuTheme.spacingSM,
        ),
        labelStyle: SevaSetuTheme.bodyMedium
            .copyWith(color: SevaSetuTheme.textSecondary),
        hintStyle: SevaSetuTheme.bodyMedium
            .copyWith(color: SevaSetuTheme.textTertiary),
      ),
      style: SevaSetuTheme.bodyLarge,
    );
  }
}

class SevaSetuStatusIndicator extends StatelessWidget {
  final String status;
  final double size;

  const SevaSetuStatusIndicator({
    super.key,
    required this.status,
    this.size = 8,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'valid':
        return SevaSetuTheme.statusValid;
      case 'expiring soon':
        return SevaSetuTheme.statusExpiring;
      case 'expired':
        return SevaSetuTheme.statusExpired;
      default:
        return SevaSetuTheme.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'valid':
        return '✓ Valid';
      case 'expiring soon':
        return '⚠️ Expiring Soon';
      case 'expired':
        return '❌ Expired';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: SevaSetuTheme.spacingSM),
        Text(
          text,
          style: SevaSetuTheme.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
