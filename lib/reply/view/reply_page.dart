import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/widgets/preview_bottom_panel.dart';
import 'package:glider/common/widgets/preview_card.dart';
import 'package:glider/item/widgets/item_data_tile.dart';
import 'package:glider/item/widgets/username_widget.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/reply/cubit/reply_cubit.dart';
import 'package:glider/reply/models/text_input.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage(
    this._replyCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
    required this.id,
  });

  final ReplyCubitFactory _replyCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final int id;

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  late final ReplyCubit _replyCubit;

  @override
  void initState() {
    _replyCubit = widget._replyCubitFactory(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    unawaited(_replyCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReplyCubit, ReplyState>(
      bloc: _replyCubit,
      listenWhen: (previous, current) => previous.success != current.success,
      listener: (context, state) {
        if (state.success) context.pop();
      },
      builder: (context, state) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const _SliverReplyAppBar(),
            SliverSafeArea(
              top: false,
              sliver: SliverToBoxAdapter(
                child: _ReplyBody(_replyCubit),
              ),
            ),
            const SliverPadding(
              padding: AppSpacing.floatingActionButtonPageBottomPadding,
            ),
          ],
        ),
        bottomNavigationBar: BlocSelector<ReplyCubit, ReplyState, bool>(
          bloc: _replyCubit,
          selector: (state) => state.preview,
          builder: (context, preview) => PreviewBottomPanel(
            visible: preview,
            onChanged: _replyCubit.setPreview,
            child: _ReplyPreview(
              _replyCubit,
              widget._authCubit,
              widget._settingsCubit,
            ),
          ),
        ),
        floatingActionButton: state.isValid
            ? FloatingActionButton.extended(
                onPressed: () async => _replyCubit.reply(),
                label: Text(context.l10n.reply),
                icon: const Icon(Icons.reply_outlined),
              )
            : null,
      ),
    );
  }
}

class _SliverReplyAppBar extends StatelessWidget {
  const _SliverReplyAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(title: Text(context.l10n.reply));
  }
}

class _ReplyBody extends StatelessWidget {
  const _ReplyBody(this._replyCubit);

  final ReplyCubit _replyCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReplyCubit, ReplyState>(
      bloc: _replyCubit,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: _ReplyForm(_replyCubit),
          ),
          if (state.parentItem?.text != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
              ),
              child: ElevatedButton.icon(
                onPressed: _replyCubit.quoteParent,
                icon: const Icon(Icons.format_quote),
                label: Text(context.l10n.quoteParent),
              ),
            ),
        ].spaced(height: AppSpacing.xl),
      ),
    );
  }
}

class _ReplyForm extends StatefulWidget {
  const _ReplyForm(this._replyCubit);

  final ReplyCubit _replyCubit;

  @override
  State<_ReplyForm> createState() => _ReplyFormState();
}

class _ReplyFormState extends State<_ReplyForm> {
  late final TextEditingController _textController;

  @override
  void initState() {
    final state = widget._replyCubit.state;
    _textController = TextEditingController(text: state.text.value);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReplyCubit, ReplyState>(
      bloc: widget._replyCubit,
      listener: (context, state) {
        if (state.text.value != _textController.text) {
          _textController.value = TextEditingValue(
            text: state.text.value,
            selection: TextSelection.collapsed(offset: state.text.value.length),
          );
        }
      },
      child: BlocBuilder<ReplyCubit, ReplyState>(
        bloc: widget._replyCubit,
        buildWhen: (previous, current) => previous.text != current.text,
        builder: (context, state) => TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: context.l10n.text,
            errorText: state.text.displayError?.label(context),
            filled: true,
          ),
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          maxLines: null,
          onChanged: widget._replyCubit.setText,
        ),
      ),
    );
  }
}

class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview(
    this._replyCubit,
    this._authCubit,
    this._settingsCubit,
  );

  final ReplyCubit _replyCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: PreviewCard(
          child: BlocBuilder<ReplyCubit, ReplyState>(
            bloc: _replyCubit,
            buildWhen: (previous, current) => previous.text != current.text,
            builder: (context, state) =>
                BlocSelector<AuthCubit, AuthState, String?>(
              bloc: _authCubit,
              selector: (state) => state.username,
              builder: (context, username) =>
                  BlocBuilder<SettingsCubit, SettingsState>(
                bloc: _settingsCubit,
                builder: (context, settingsState) => HeroMode(
                  enabled: false,
                  child: ItemDataTile(
                    Item(
                      id: 0,
                      username: username,
                      type: ItemType.comment,
                      text:
                          state.text.value.isNotEmpty ? state.text.value : null,
                      dateTime: clock.now(),
                    ),
                    useLargeStoryStyle: settingsState.useLargeStoryStyle,
                    showFavicons: settingsState.showFavicons,
                    showUserAvatars: settingsState.showUserAvatars,
                    usernameStyle: UsernameStyle.loggedInUser,
                    useInAppBrowser: settingsState.useInAppBrowser,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
