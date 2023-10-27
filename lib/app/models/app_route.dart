enum AppRoute {
  stories,
  catchUp,
  favorites,
  history,
  inbox,
  whatsNew,
  auth,
  settings,
  themeColorDialog(parent: settings),
  submit,
  item,
  itemBottomSheet(parent: item),
  edit(parent: item),
  reply(parent: item),
  itemValueDialog(parent: item),
  user,
  userBottomSheet(parent: user),
  userValueDialog(parent: user),
  textSelectDialog,
  confirmDialog;

  const AppRoute({this.parent});

  final AppRoute? parent;

  String get path => parent != null ? name : '/$name';

  String location({Map<String, Object?>? parameters}) => Uri(
        path: parent != null ? '${parent!.path}/$path' : path,
        queryParameters: parameters != null
            ? {
                for (final parameter in parameters.entries)
                  parameter.key: parameter.value?.toString(),
              }
            : null,
      ).toString();
}
