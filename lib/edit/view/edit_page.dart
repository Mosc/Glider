import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/widgets/preview_bottom_panel.dart';
import 'package:glider/common/widgets/preview_card.dart';
import 'package:glider/edit/cubit/edit_cubit.dart';
import 'package:glider/edit/models/text_input.dart';
import 'package:glider/edit/models/title_input.dart';
import 'package:glider/item/widgets/item_data_tile.dart';
import 'package:glider/item/widgets/username_widget.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:go_router/go_router.dart';

class EditPage extends StatefulWidget {
  const EditPage(
    this._editCubitFactory,
    this._settingsCubit, {
    super.key,
    required this.id,
  });

  final EditCubitFactory _editCubitFactory;
  final SettingsCubit _settingsCubit;
  final int id;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final EditCubit _editCubit;

  @override
  void initState() {
    _editCubit = widget._editCubitFactory(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    unawaited(_editCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditCubit, EditState>(
      bloc: _editCubit,
      listenWhen: (previous, current) => previous.success != current.success,
      listener: (context, state) {
        if (state.success) context.pop();
      },
      builder: (context, state) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const _SliverEditAppBar(),
            SliverSafeArea(
              top: false,
              sliver: SliverToBoxAdapter(
                child: _EditBody(_editCubit),
              ),
            ),
            const SliverPadding(
              padding: AppSpacing.floatingActionButtonPageBottomPadding,
            ),
          ],
        ),
        bottomNavigationBar: BlocSelector<EditCubit, EditState, bool>(
          bloc: _editCubit,
          selector: (state) => state.preview,
          builder: (context, preview) => PreviewBottomPanel(
            visible: preview,
            onChanged: _editCubit.setPreview,
            child: _EditPreview(
              _editCubit,
              widget._settingsCubit,
            ),
          ),
        ),
        floatingActionButton: state.isValid
            ? FloatingActionButton.extended(
                onPressed: () async => _editCubit.edit(),
                label: Text(context.l10n.edit),
                icon: const Icon(Icons.edit_outlined),
              )
            : null,
      ),
    );
  }
}

class _SliverEditAppBar extends StatelessWidget {
  const _SliverEditAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(title: Text(context.l10n.edit));
  }
}

class _EditBody extends StatelessWidget {
  const _EditBody(this._editCubit);

  final EditCubit _editCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: _EditForm(_editCubit),
    );
  }
}

class _EditForm extends StatefulWidget {
  const _EditForm(this._editCubit);

  final EditCubit _editCubit;

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  late final TextEditingController _textController;

  @override
  void initState() {
    final state = widget._editCubit.state;
    _titleController = TextEditingController(text: state.title?.value);
    _urlController = TextEditingController(text: state.item?.url?.toString());
    _textController = TextEditingController(text: state.text?.value);
    super.initState();
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
    return BlocConsumer<EditCubit, EditState>(
      bloc: widget._editCubit,
      listener: (context, state) {
        if (state.title?.value case final title?) {
          if (title != _titleController.text) {
            _titleController.value = TextEditingValue(
              text: title,
              selection: TextSelection.collapsed(offset: title.length),
            );
          }
        }

        if (state.item?.url?.toString() case final url?) {
          if (url != _urlController.text) {
            _urlController.value = TextEditingValue(
              text: url,
              selection: TextSelection.collapsed(offset: url.length),
            );
          }
        }

        if (state.text?.value case final text?) {
          if (text != _textController.text) {
            _textController.value = TextEditingValue(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          }
        }
      },
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.title != null)
            BlocBuilder<EditCubit, EditState>(
              bloc: widget._editCubit,
              buildWhen: (previous, current) => previous.title != current.title,
              builder: (context, state) => TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: context.l10n.title,
                  errorText: state.title?.displayError?.label(context),
                  filled: true,
                ),
                textCapitalization: TextCapitalization.words,
                maxLength: TitleInput.maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                onChanged: widget._editCubit.setTitle,
              ),
            ),
          if (state.item?.url != null)
            BlocBuilder<EditCubit, EditState>(
              bloc: widget._editCubit,
              buildWhen: (previous, current) =>
                  previous.item?.url != current.item?.url,
              builder: (context, state) => TextFormField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: context.l10n.link,
                  filled: true,
                ),
                enabled: false,
              ),
            ),
          if (state.text != null)
            BlocBuilder<EditCubit, EditState>(
              bloc: widget._editCubit,
              buildWhen: (previous, current) => previous.text != current.text,
              builder: (context, state) => TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: context.l10n.text,
                  errorText: state.text?.displayError?.label(context),
                  filled: true,
                ),
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                onChanged: widget._editCubit.setText,
              ),
            ),
        ].spaced(height: AppSpacing.m),
      ),
    );
  }
}

class _EditPreview extends StatelessWidget {
  const _EditPreview(
    this._editCubit,
    this._settingsCubit,
  );

  final EditCubit _editCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: PreviewCard(
          child: BlocBuilder<EditCubit, EditState>(
            bloc: _editCubit,
            buildWhen: (previous, current) =>
                previous.item != current.item ||
                previous.title != current.title ||
                previous.text != current.text,
            builder: (context, state) => state.item != null
                ? BlocBuilder<SettingsCubit, SettingsState>(
                    bloc: _settingsCubit,
                    builder: (context, settingsState) => ItemDataTile(
                      state.item!.copyWith(
                        title: () => state.title?.value,
                        text: () => state.text?.value,
                      ),
                      useLargeStoryStyle: settingsState.useLargeStoryStyle,
                      showFavicons: settingsState.showFavicons,
                      showUserAvatars: settingsState.showUserAvatars,
                      usernameStyle: UsernameStyle.loggedInUser,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
