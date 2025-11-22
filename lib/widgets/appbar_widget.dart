import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarWidget extends StatelessWidget {
  final String title; // Custom text title
  final IconData? icon; // Optional trailing icon
  final VoidCallback? onIconTap;
  final IconData? leadingIcon; // Optional leading icon
  final VoidCallback? onLeadingIconTap;

  const AppbarWidget({
    super.key,
    required this.title,
    this.icon,
    this.onIconTap,
    this.leadingIcon,
    this.onLeadingIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasLeading = leadingIcon != null;
    final bool hasTrailing = icon != null;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              // Leading Icon (optional)
              if (hasLeading)
                IconButton(
                  icon: Icon(leadingIcon, color: Colors.white),
                  onPressed: onLeadingIconTap ?? () {},
                ),

              // Title — aligned based on whether a leading icon exists
              Expanded(
                child: Align(
                  alignment: hasLeading
                      ? Alignment.center // if leading icon present, center
                      : Alignment.centerLeft, // otherwise left-align
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Trailing Icon (optional)
              if (hasTrailing)
                IconButton(
                  icon: Icon(icon, color: Colors.white),
                  onPressed: onIconTap ?? () {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}
