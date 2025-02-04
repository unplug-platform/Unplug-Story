import 'package:flutter/material.dart';

/// A custom page route builder that creates a scale transition animation
/// originating from the tap position.
///
/// This route builder is specifically designed for story transitions, creating
/// an Instagram-like effect where the story expands from the point where the
/// user tapped. The animation scales and fades in the content from the tap
/// position, creating a smooth and engaging transition.
///
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   StoryPageRouteBuilder(
///     tapPosition: details.globalPosition,
///     pageBuilder: (context, animation, secondaryAnimation) => StoryDetailWidget(...),
///   ),
/// );
/// ```
final class StoryPageRouteBuilder extends PageRouteBuilder {
  /// The position where the user tapped to trigger the story.
  ///
  /// This position is used as the origin point for the scale animation.
  final Offset tapPosition;

  /// Creates a new [StoryPageRouteBuilder].
  ///
  /// Parameters:
  /// * [pageBuilder] - Required builder function for the page content
  /// * [tapPosition] - Required position where the user tapped
  StoryPageRouteBuilder({
    required super.pageBuilder,
    required this.tapPosition,
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final screenSize = MediaQuery.of(context).size;

            // Calculate the scale alignment based on tap position
            final alignmentX = (tapPosition.dx / screenSize.width) * 2 - 1;
            final alignmentY = (tapPosition.dy / screenSize.height) * 2 - 1;

            return ScaleTransition(
              alignment: Alignment(alignmentX, alignmentY),
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            );
          },
        );
}

/// A custom clipper that creates a circular reveal animation effect.
///
/// This clipper can be used to create a circular reveal/unreval effect where
/// content is shown or hidden within an expanding/contracting circle. The circle's
/// center and size are customizable through the [fraction] and [centerOffset]
/// parameters.
///
/// Example usage:
/// ```dart
/// ClipPath(
///   clipper: CircularRevealClipper(
///     fraction: animation.value,
///     centerOffset: Offset(100, 100),
///   ),
///   child: child,
/// )
/// ```
final class CircularRevealClipper extends CustomClipper<Path> {
  /// The fraction of the reveal animation (0.0 to 1.0).
  ///
  /// A value of 0.0 means fully hidden, 1.0 means fully revealed.
  final double fraction;

  /// The center point of the reveal circle.
  final Offset centerOffset;

  /// Creates a new [CircularRevealClipper].
  ///
  /// Parameters:
  /// * [fraction] - Required animation progress (0.0 to 1.0)
  /// * [centerOffset] - Required center point of the reveal circle
  CircularRevealClipper({
    required this.fraction,
    required this.centerOffset,
  });

  @override
  Path getClip(Size size) {
    final radius = fraction * size.longestSide * 1.5;
    final path = Path()
      ..addOval(
        Rect.fromCircle(
          center: centerOffset,
          radius: radius,
        ),
      );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
