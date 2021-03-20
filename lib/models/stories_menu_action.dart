enum StoriesMenuAction {
  catchUp,
  favorites,
  submit,
  theme,
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
      case StoriesMenuAction.theme:
        return 'Theme';
      case StoriesMenuAction.account:
        return 'Account';
    }
  }
}
