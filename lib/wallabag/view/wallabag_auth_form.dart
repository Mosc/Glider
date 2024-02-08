import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/common/widgets/failure_widget.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/wallabag/cubit/wallabag_cubit.dart';
import 'package:glider_domain/glider_domain.dart';

class WallabagAuthForm extends StatefulWidget {
  const WallabagAuthForm(this._wallabagCubit, {super.key});

  final WallabagCubit _wallabagCubit;

  @override
  State<WallabagAuthForm> createState() => _EditPageState();
}

class _EditPageState extends State<WallabagAuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final WallabagCubit _wallabagCubit;

  late final TextEditingController _endpointController;
  late final TextEditingController _userController;
  late final TextEditingController _passwordController;
  late final TextEditingController _identifierController;
  late final TextEditingController _secretController;

  @override
  void initState() {
    super.initState();
    _wallabagCubit = widget._wallabagCubit;
    unawaited(_wallabagCubit.init());

    final state = _wallabagCubit.state;
    _endpointController = TextEditingController(
      text: state.authData?.endpoint.toString(),
    );
    _userController = TextEditingController(text: state.authData?.user);
    _passwordController = TextEditingController(text: state.authData?.password);
    _identifierController =
        TextEditingController(text: state.authData?.identifier);
    _secretController = TextEditingController(text: state.authData?.secret);
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _identifierController.dispose();
    _secretController.dispose();

    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.emptyError;
    }

    return null;
  }

  Future<void> _validateAuth() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _wallabagCubit.validate(
        WallabagAuthData(
          endpoint: Uri.parse(_endpointController.text),
          user: _userController.text,
          password: _passwordController.text,
          identifier: _identifierController.text.trim(),
          secret: _secretController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WallabagCubit, WallabagState>(
      bloc: _wallabagCubit,
      listener: (context, state) {
        if (state.authData?.endpoint.toString() case final url?) {
          if (url != _endpointController.text) {
            _endpointController.value = TextEditingValue(
              text: url,
              selection: TextSelection.collapsed(offset: url.length),
            );
          }
        }

        if (state.authData?.user case final text?) {
          if (text != _userController.text) {
            _userController.value = TextEditingValue(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          }
        }

        if (state.authData?.password case final text?) {
          if (text != _passwordController.text) {
            _passwordController.value = TextEditingValue(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          }
        }

        if (state.authData?.identifier case final text?) {
          if (text != _identifierController.text) {
            _identifierController.value = TextEditingValue(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          }
        }

        if (state.authData?.secret case final text?) {
          if (text != _secretController.text) {
            _secretController.value = TextEditingValue(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          }
        }
      },
      builder: (context, state) => Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _endpointController,
              decoration: InputDecoration(
                label: Text(context.l10n.wallabagEndpoint),
                hintText: 'https://app.wallabag.it',
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    Uri.tryParse(value) == null) {
                  return context.l10n.invalidUrlError;
                }

                return null;
              },
            ),
            const SizedBox(
              height: AppSpacing.m,
            ),
            TextFormField(
              controller: _userController,
              decoration: InputDecoration(
                label: Text(context.l10n.username),
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(
              height: AppSpacing.m,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                label: Text(context.l10n.password),
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(
              height: AppSpacing.m,
            ),
            TextFormField(
              controller: _identifierController,
              decoration: InputDecoration(
                label: Text(context.l10n.clientId),
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(
              height: AppSpacing.m,
            ),
            TextFormField(
              controller: _secretController,
              decoration: InputDecoration(
                label: Text(context.l10n.clientSecret),
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(
              height: AppSpacing.l,
            ),
            if (state.status == Status.failure)
              FailureWidget(
                title: context.l10n.wallabagTestFailure,
                exception: state.exception ?? context.l10n.wallabagApiError,
              ),
            if (state.status == Status.success)
              Text(context.l10n.wallabagTestSuccess),
            OutlinedButton(
              onPressed:
                  (state.status != Status.loading) ? _validateAuth : null,
              child: SizedBox(
                width: double.infinity,
                child: (state.status == Status.loading)
                    ? const LinearProgressIndicator()
                    : Text(
                        context.l10n.wallabagValidate,
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
