enum StoriesMenuAction {
  catchUp,
  favorites,
  submit,
  appearance,
  account,
}

extension StoriesMenuActionExtension on StoriesMenuAction {
  String get title {
    switch (this) {
      case StoriesMenuAction.catchUp:
        return 'Catch up';
      case StoriesMenuAction.favorites:
        return 'Favorites';
      case StoriesMenuAction.submit:
        return 'Submit';
      case StoriesMenuAction.appearance:
        return 'Appearance';
      case StoriesMenuAction.account:
        return 'Account';
    }
  }
}
