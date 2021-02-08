enum AccountMenuAction {
  synchronize,
  logOut,
}

extension StoriesMenuActionExtension on AccountMenuAction {
  String get title {
    switch (this) {
      case AccountMenuAction.synchronize:
        return 'Synchronize';
      case AccountMenuAction.logOut:
        return 'Log out';
    }

    throw UnsupportedError('$this does not have a title');
  }
}
