import 'package:flutter/material.dart';
import 'dart:ui';

class BlurredImage extends StatelessWidget {
  final String imageUrl;
  final bool isBlurred;
  final double blurLevel;
  final Widget? overlay;
  final VoidCallback? onTap;

  const BlurredImage({
    super.key,
    required this.imageUrl,
    this.isBlurred = false,
    this.blurLevel = 5.0,
    this.overlay,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base image
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 50),
              );
            },
          ),
          
          // Blur overlay
          if (isBlurred) ...[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurLevel, sigmaY: blurLevel),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
            
            // Match to unlock overlay
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Match to unlock',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          
          // Custom overlay
          if (overlay != null) overlay!,
        ],
      ),
    );
  }
}

class SafetyBadge extends StatelessWidget {
  final bool isVerified;
  final bool isFlagged;
  final int safetyScore;

  const SafetyBadge({
    super.key,
    this.isVerified = false,
    this.isFlagged = false,
    required this.safetyScore,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    IconData badgeIcon;
    String badgeText;

    if (isFlagged) {
      badgeColor = Colors.red;
      badgeIcon = Icons.warning;
      badgeText = 'Flagged';
    } else if (isVerified) {
      badgeColor = Colors.green;
      badgeIcon = Icons.verified;
      badgeText = 'Verified';
    } else if (safetyScore >= 80) {
      badgeColor = Colors.blue;
      badgeIcon = Icons.shield;
      badgeText = 'Safe';
    } else {
      badgeColor = Colors.orange;
      badgeIcon = Icons.info;
      badgeText = 'New';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class AntiScamAlert extends StatelessWidget {
  final String message;
  final VoidCallback onReport;
  final VoidCallback onDismiss;

  const AntiScamAlert({
    super.key,
    required this.message,
    required this.onReport,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Suspicious Activity Detected',
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.red[700]),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onDismiss,
                child: const Text('Dismiss'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Report User'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}