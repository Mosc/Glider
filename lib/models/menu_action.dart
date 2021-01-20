enum MenuAction {
  favorites,
  submit,
  account,
}

extension MenuActionExtension on MenuAction {
  String get title {
    switch (this) {
      case MenuAction.favorites:
        return 'Favorites';
      case MenuAction.submit:
        return 'Submit';
      case MenuAction.account:
        return 'Account';
    }

    throw UnsupportedError('$this does not have a title');
  }
}
