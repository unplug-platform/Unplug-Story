import 'dart:ui';

import 'package:flutter/material.dart';

import '../enum/animation_enum.dart';

final class CubeWidget extends StatelessWidget {
  final int index;
  final double pageNotifier;
  final Widget child;
  final CubeAnimationStyle animationStyle;

  const CubeWidget({
    super.key,
    required this.index,
    required this.pageNotifier,
    required this.child,
    required this.animationStyle,
  });

  @override
  Widget build(BuildContext context) {
    final t = (index - pageNotifier);

    switch (animationStyle) {
      case CubeAnimationStyle.fade:
        return _buildFadeAnimation(t);
      case CubeAnimationStyle.cube:
        return _buildCubeAnimation(t);
      case CubeAnimationStyle.slide:
        return _buildSlideAnimation(t);
      case CubeAnimationStyle.scale:
        return _buildScaleAnimation(t);
      case CubeAnimationStyle.flip:
        return _buildFlipAnimation(t);
      case CubeAnimationStyle.rotation:
        return _buildRotationAnimation(t);
      case CubeAnimationStyle.zoom:
        return _buildZoomAnimation(t);
    }
  }

  Widget _buildFadeAnimation(double t) {
    final opacity = lerpDouble(0, 1, 1 - t.abs())?.clamp(0.0, 1.0) ?? 0;
    return Opacity(
      opacity: opacity,
      child: child,
    );
  }

  Widget _buildCubeAnimation(double t) {
    final isLeaving = t <= 0;
    final transform = Matrix4.identity();
    transform.setEntry(3, 2, 0.003);
    final rotationY = lerpDouble(0.0, 90.0, t)?.toDouble() ?? 0.0;
    transform.rotateY(-degToRad(rotationY).toDouble());
    return Transform(
      alignment: isLeaving ? Alignment.centerRight : Alignment.centerLeft,
      transform: transform,
      child: child,
    );
  }

  Widget _buildSlideAnimation(double t) {
    final dx = lerpDouble(300, 0, 1 - t.abs()) ?? 0.0;
    return Transform.translate(
      offset: Offset(dx * (t < 0 ? -1 : 1), 0),
      child: child,
    );
  }

  Widget _buildScaleAnimation(double t) {
    final scale = lerpDouble(0.8, 1.0, 1 - t.abs()) ?? 1.0;
    return Transform.scale(
      scale: scale,
      child: child,
    );
  }

  Widget _buildFlipAnimation(double t) {
    final transform = Matrix4.identity();
    final rotationX = lerpDouble(0.0, 180.0, t)?.toDouble() ?? 0.0;
    transform.rotateX(degToRad(rotationX));
    return Transform(
      alignment: Alignment.center,
      transform: transform,
      child: child,
    );
  }

  Widget _buildRotationAnimation(double t) {
    final transform = Matrix4.identity();
    final rotationZ = lerpDouble(0.0, 360.0, t)?.toDouble() ?? 0.0;
    transform.rotateZ(degToRad(rotationZ.toDouble()));
    return Transform(
      alignment: Alignment.center,
      transform: transform,
      child: child,
    );
  }

  Widget _buildZoomAnimation(double t) {
    final scale = lerpDouble(1.5, 1.0, 1 - t.abs()) ?? 1.0;
    return Transform.scale(
      scale: scale,
      child: child,
    );
  }

  double degToRad(num degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }
}
