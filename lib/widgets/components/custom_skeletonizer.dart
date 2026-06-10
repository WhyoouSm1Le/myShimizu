import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomSkeletonizer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const CustomSkeletonizer({
    super.key,
    required this.child,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      effect: ShimmerEffect(
        baseColor: Colors.grey[900]!, 
        highlightColor: Colors.grey[800]!, 
        duration: const Duration(milliseconds: 1000),
      ),
      child: child,
    );
  }
}