import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider_data/glider_data.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

part 'wallabag_state.dart';

class WallabagCubit extends Cubit<WallabagState> {
  WallabagCubit(this._authRepository) : super(const WallabagState());

  final AuthRepository _authRepository;

  Future<WallabagAuthData?> init() async {
    final auth = await _authRepository.getWallabagAuth();
    safeEmit(WallabagState(authData: auth));
    return auth;
  }

  Future<WallabagApiService?> validate([WallabagAuthData? auth]) async {
    late final WallabagAuthData? obtainedAuth;
    if (auth != null) {
      await _authRepository.setWallabagAuth(auth);
      obtainedAuth = auth;
    } else {
      obtainedAuth = await init();
    }

    if (obtainedAuth != null) {
      safeEmit(WallabagState(authData: obtainedAuth, status: Status.loading));

      try {
        final service = await oauth2
            .resourceOwnerPasswordGrant(
              obtainedAuth.endpoint.replace(path: 'oauth/v2/token'),
              obtainedAuth.user,
              obtainedAuth.password,
              identifier: obtainedAuth.identifier,
              secret: obtainedAuth.secret,
            )
            .then(
              (client) => WallabagApiService(client, obtainedAuth!.endpoint),
            );

        final user = await service.currentUser();
        if (user != obtainedAuth.user) {
          safeEmit(state.copyWith(status: () => Status.failure));
          return null;
        }

        safeEmit(
          state.copyWith(data: () => service, status: () => Status.success),
        );
        return service;
      } on Object catch (exception) {
        safeEmit(
          state.copyWith(
            status: () => Status.failure,
            exception: () => exception,
          ),
        );
      }
    }

    return null;
  }
}
