import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/utils/url_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutSection extends HookConsumerWidget {
  const AboutSection({super.key});

  static const String _privacyPolicyUrl =
      'https://github.com/Mosc/Glider/blob/master/PRIVACY.md';
  static const String _license = 'MIT';
  static const String _licenseUrl =
      'https://github.com/Mosc/Glider/blob/master/LICENSE';
  static const String _sourceCodeUrl = 'https://github.com/Mosc/Glider';
  static const String _issueTrackerUrl =
      'https://github.com/Mosc/Glider/issues';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<String?> appVersionState = useState(null);

    useMemoized(
      () async {
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
        appVersionState.value = packageInfo.version;
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            AppLocalizations.of(context).about,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        if (appVersionState.value != null)
          ListTile(
            title: Text(AppLocalizations.of(context).appVersion),
            subtitle: Text(appVersionState.value!),
          ),
        ListTile(
          title: Text(AppLocalizations.of(context).privacyPolicy),
          trailing: const Icon(FluentIcons.open_24_regular),
          onTap: () => UrlUtil.tryLaunch(context, ref, _privacyPolicyUrl),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).license),
          subtitle: const Text(_license),
          trailing: const Icon(FluentIcons.open_24_regular),
          onTap: () => UrlUtil.tryLaunch(context, ref, _licenseUrl),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).sourceCode),
          subtitle: const Text(_sourceCodeUrl),
          trailing: const Icon(FluentIcons.open_24_regular),
          onTap: () => UrlUtil.tryLaunch(context, ref, _sourceCodeUrl),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).issueTracker),
          subtitle: const Text(_issueTrackerUrl),
          trailing: const Icon(FluentIcons.open_24_regular),
          onTap: () => UrlUtil.tryLaunch(context, ref, _issueTrackerUrl),
        ),
        ListTile(
          title: Text(MaterialLocalizations.of(context).licensesPageTitle),
          onTap: () => showLicensePage(
            context: context,
            applicationName: AppLocalizations.of(context).appName,
            applicationVersion: appVersionState.value,
          ),
        ),
      ],
    );
  }
}
