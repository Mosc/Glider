import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.defaultTilePadding,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
