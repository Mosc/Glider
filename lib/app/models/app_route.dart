enum AppRoute {
  stories,
  catchUp,
  favorites,
  inbox,
  whatsNew,
  auth,
  settings,
  themeColorDialog(parent: settings),
  submit,
  item,
  edit(parent: item),
  reply(parent: item),
  itemValueDialog(parent: item),
  user,
  userValueDialog(parent: user),
  textSelectDialog,
  confirmDialog;

  const AppRoute({this.parent});

  final AppRoute? parent;

  String get path => [if (parent == null) '/', name].join();

  String location({Map<String, Object?>? parameters}) => Uri(
        path: [if (parent case final parent?) '${parent.path}/', path].join(),
        queryParameters: parameters != null
            ? {
                for (final parameter in parameters.entries)
                  parameter.key: parameter.value?.toString(),
              }
            : null,
      ).toString();
}
