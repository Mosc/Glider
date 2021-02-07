enum MenuAction {
  catchUp,
  favorites,
  submit,
  theme,
  synchronize,
  account,
}

extension MenuActionExtension on MenuAction {
  String get title {
    switch (this) {
      case MenuAction.catchUp:
        return 'Catch up';
      case MenuAction.favorites:
        return 'Favorites';
      case MenuAction.submit:
        return 'Submit';
      case MenuAction.theme:
        return 'Theme';
      case MenuAction.synchronize:
        return 'Synchronize';
      case MenuAction.account:
        return 'Account';
    }

    throw UnsupportedError('$this does not have a title');
  }
}
