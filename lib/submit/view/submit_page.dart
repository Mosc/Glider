import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/widgets/preview_bottom_panel.dart';
import 'package:glider/common/widgets/preview_card.dart';
import 'package:glider/item/widgets/item_data_tile.dart';
import 'package:glider/item/widgets/username_widget.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/submit/cubit/submit_cubit.dart';
import 'package:glider/submit/models/text_input.dart';
import 'package:glider/submit/models/title_input.dart';
import 'package:glider/submit/models/url_input.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage(
    this._submitCubit,
    this._authCubit,
    this._settingsCubit, {
    super.key,
  });

  final SubmitCubit _submitCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmitCubit, SubmitState>(
      bloc: widget._submitCubit,
      listenWhen: (previous, current) => previous.success != current.success,
      listener: (context, state) {
        if (state.success) context.pop();
      },
      builder: (context, state) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const _SliverSubmitAppBar(),
            SliverSafeArea(
              top: false,
              sliver: SliverToBoxAdapter(
                child: _SubmitBody(widget._submitCubit),
              ),
            ),
            const SliverPadding(
              padding: AppSpacing.floatingActionButtonPageBottomPadding,
            ),
          ],
        ),
        bottomNavigationBar: BlocSelector<SubmitCubit, SubmitState, bool>(
          bloc: widget._submitCubit,
          selector: (state) => state.preview,
          builder: (context, preview) => PreviewBottomPanel(
            visible: preview,
            onChanged: widget._submitCubit.setPreview,
            child: _SubmitPreview(
              widget._submitCubit,
              widget._authCubit,
              widget._settingsCubit,
            ),
          ),
        ),
        floatingActionButton: state.isValid
            ? FloatingActionButton.extended(
                onPressed: () async => widget._submitCubit.submit(),
                label: Text(context.l10n.submit),
                icon: const Icon(Icons.send_outlined),
              )
            : null,
      ),
    );
  }
}

class _SliverSubmitAppBar extends StatelessWidget {
  const _SliverSubmitAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(title: Text(context.l10n.submit));
  }
}

class _SubmitBody extends StatelessWidget {
  const _SubmitBody(this._submitCubit);

  final SubmitCubit _submitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitCubit, SubmitState>(
      bloc: _submitCubit,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SubmitForm(_submitCubit),
            if (state.url.hasHost)
              ElevatedButton.icon(
                onPressed: _submitCubit.autofillTitle,
                icon: const Icon(Icons.title_outlined),
                label: Text(context.l10n.autofillTitle),
              ),
          ].spaced(height: AppSpacing.xl),
        ),
      ),
    );
  }
}

class _SubmitForm extends StatefulWidget {
  const _SubmitForm(this._submitCubit);

  final SubmitCubit _submitCubit;

  @override
  State<_SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<_SubmitForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    final state = widget._submitCubit.state;
    _titleController = TextEditingController(text: state.title.value);
    _urlController = TextEditingController(text: state.url.value);
    _textController = TextEditingController(text: state.text.value);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubmitCubit, SubmitState>(
      bloc: widget._submitCubit,
      listener: (context, state) {
        if (state.title.value != _titleController.text) {
          _titleController.value = TextEditingValue(
            text: state.title.value,
            selection:
                TextSelection.collapsed(offset: state.title.value.length),
          );
        }

        if (state.url.value != _urlController.text) {
          _urlController.value = TextEditingValue(
            text: state.url.value,
            selection: TextSelection.collapsed(offset: state.url.value.length),
          );
        }

        if (state.text.value != _textController.text) {
          _textController.value = TextEditingValue(
            text: state.text.value,
            selection: TextSelection.collapsed(offset: state.text.value.length),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SubmitCubit, SubmitState>(
            bloc: widget._submitCubit,
            buildWhen: (previous, current) => previous.title != current.title,
            builder: (context, state) => TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: context.l10n.title,
                errorText: state.title.displayError?.label(context),
              ),
              textCapitalization: TextCapitalization.words,
              maxLength: TitleInput.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              onChanged: widget._submitCubit.setTitle,
            ),
          ),
          BlocBuilder<SubmitCubit, SubmitState>(
            bloc: widget._submitCubit,
            buildWhen: (previous, current) =>
                previous.url != current.url || previous.text != current.text,
            builder: (context, state) => TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: context.l10n.link,
                errorText: state.url.displayError
                    ?.label(context, otherField: context.l10n.text),
              ),
              keyboardType: TextInputType.url,
              onChanged: widget._submitCubit.setUrl,
            ),
          ),
          BlocBuilder<SubmitCubit, SubmitState>(
            bloc: widget._submitCubit,
            buildWhen: (previous, current) =>
                previous.text != current.text || previous.url != current.url,
            builder: (context, state) => TextFormField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: context.l10n.text,
                errorText: state.text.displayError
                    ?.label(context, otherField: context.l10n.link),
              ),
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              onChanged: widget._submitCubit.setText,
            ),
          ),
        ].spaced(height: AppSpacing.m),
      ),
    );
  }
}

class _SubmitPreview extends StatelessWidget {
  const _SubmitPreview(
    this._submitCubit,
    this._authCubit,
    this._settingsCubit,
  );

  final SubmitCubit _submitCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: PreviewCard(
          child: BlocBuilder<SubmitCubit, SubmitState>(
            bloc: _submitCubit,
            buildWhen: (previous, current) =>
                previous.title != current.title ||
                previous.url != current.url ||
                previous.text != current.text,
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
                      type: ItemType.story,
                      title: state.title.value.isNotEmpty
                          ? state.title.value
                          : null,
                      url: state.url.value.isNotEmpty
                          ? Uri.tryParse(state.url.value)
                          : null,
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
