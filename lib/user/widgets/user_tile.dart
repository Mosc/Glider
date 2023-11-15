import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_style.dart';
import 'package:glider/user/typedefs/user_typedefs.dart';
import 'package:glider/user/widgets/user_data_tile.dart';
import 'package:glider/user/widgets/user_loading_tile.dart';
import 'package:go_router/go_router.dart';

class UserTile extends StatelessWidget {
  const UserTile(
    this._userCubit, {
    super.key,
    this.style = UserStyle.full,
    this.padding = AppSpacing.defaultTilePadding,
    this.onTap,
  });

  final UserCubit _userCubit;
  final UserStyle style;
  final EdgeInsets padding;
  final UserCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: _userCubit,
      builder: (context, state) => state.whenOrDefaultWidgets(
        loading: () => UserLoadingTile(
          style: style,
          padding: padding,
        ),
        success: () {
          final user = state.data!;
          return UserDataTile(
            user,
            parsedAbout: state.parsedAbout,
            blocked: state.blocked,
            style: style,
            padding: padding,
            onTap: onTap,
            onLongPress: (context, item) async => context.push(
              AppRoute.userBottomSheet
                  .location(parameters: {'id': user.username}),
            ),
          );
        },
        onRetry: () async => _userCubit.load(),
      ),
    );
  }
}
