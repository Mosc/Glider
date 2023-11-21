import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/uri_extension.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/user/view/user_page.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage(
    this._authCubit,
    this._settingsCubit,
    this._userCubitFactory,
    this._itemCubitFactory,
    this._userItemSearchBlocFactory, {
    super.key,
  });

  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final UserCubitFactory _userCubitFactory;
  final ItemCubitFactory _itemCubitFactory;
  final UserItemSearchBlocFactory _userItemSearchBlocFactory;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final InAppBrowser _browser;

  @override
  void initState() {
    _browser = _AuthInAppBrowser(widget._authCubit);

    if (!kIsWeb && defaultTargetPlatform != TargetPlatform.iOS) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => _browser.addMenuItem(
          InAppBrowserMenuItem(
            id: 0,
            title: MaterialLocalizations.of(context).closeButtonLabel,
            showAsAction: true,
            onClick: () async => _browser.close(),
          ),
        ),
      );
    }

    unawaited(widget._authCubit.init());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current.isLoggedIn,
      listener: (context, state) async {
        await _browser.close();
        final confirm = await context.push<bool>(
          AppRoute.confirmDialog.location(),
          extra: (
            title: context.l10n.synchronize,
            text: context.l10n.synchronizeDescription,
          ),
        );
        if (confirm ?? false) {
          await widget._userCubitFactory(state.username!).synchronize();
        }
      },
      bloc: widget._authCubit,
      builder: (context, state) => state.isLoggedIn
          ? UserPage(
              widget._userCubitFactory,
              widget._itemCubitFactory,
              widget._userItemSearchBlocFactory,
              widget._authCubit,
              widget._settingsCubit,
              username: state.username!,
            )
          : Scaffold(
              body: const CustomScrollView(
                slivers: [
                  _SliverAuthAppBar(),
                  SliverSafeArea(
                    top: false,
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: _AuthBody(),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async => _browser.openUrlRequest(
                  settings: InAppBrowserClassSettings(
                    browserSettings: InAppBrowserSettings(
                      hideUrlBar: true,
                      hideDefaultMenuItems: true,
                      hideToolbarBottom: true,
                    ),
                    webViewSettings: InAppWebViewSettings(
                      isInspectable: kDebugMode,
                      clearCache: true,
                    ),
                  ),
                  urlRequest: URLRequest(
                    url: WebUri(
                      Uri.https('news.ycombinator.com', 'login').toString(),
                    ),
                  ),
                ),
                icon: const Icon(Icons.login_outlined),
                label: Text(context.l10n.login),
              ),
            ),
    );
  }
}

class _SliverAuthAppBar extends StatelessWidget {
  const _SliverAuthAppBar();

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar();
  }
}

class _AuthBody extends StatelessWidget {
  const _AuthBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.defaultTilePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.authDescription),
          TextButtonTheme(
            data: TextButtonThemeData(
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            child: ButtonBar(
              children: [
                TextButton(
                  onPressed: () async => Uri.https(
                    'github.com',
                    'Mosc/Glider/blob/master/PRIVACY.md',
                  ).tryLaunch(),
                  child: Text(context.l10n.privacyPolicy),
                ),
                TextButton(
                  onPressed: () async => Uri.https(
                    'www.ycombinator.com',
                    'legal',
                  ).replace(fragment: 'privacy').tryLaunch(),
                  child: Text(context.l10n.privacyPolicyYc),
                ),
                TextButton(
                  onPressed: () async => Uri.https(
                    'www.ycombinator.com',
                    'legal',
                  ).replace(fragment: 'tou').tryLaunch(),
                  child: Text(context.l10n.termsOfUseYc),
                ),
              ],
            ),
          ),
        ].spaced(height: AppSpacing.m),
      ),
    );
  }
}

class _AuthInAppBrowser extends InAppBrowser {
  _AuthInAppBrowser(this._authCubit);

  final AuthCubit _authCubit;

  @override
  void onPageCommitVisible(WebUri? url) {
    _authCubit.login();
    super.onPageCommitVisible(url);
  }
}
