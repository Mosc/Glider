enum UserStyle {
  full(showPrimary: true, showSecondary: true),
  primary(showPrimary: true),
  secondary(showSecondary: true);

  const UserStyle({
    this.showPrimary = false,
    this.showSecondary = false,
  });

  final bool showPrimary;
  final bool showSecondary;
}
