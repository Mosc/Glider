enum ItemStyle {
  full(showPrimary: true, showSecondary: true),
  overview(showPrimary: true, showUrlHost: true),
  primary(showPrimary: true),
  secondary(showSecondary: true);

  const ItemStyle({
    this.showPrimary = false,
    this.showSecondary = false,
    this.showUrlHost = false,
  });

  final bool showPrimary;
  final bool showSecondary;
  final bool showUrlHost;
}
