import 'package:flutter/material.dart';

class MenuListTile<T> extends StatelessWidget {
  const MenuListTile({
    super.key,
    this.title,
    this.trailing,
    this.enabled = true,
    this.onChanged,
    required this.values,
    required this.selected,
    required this.labelBuilder,
  });

  final Widget? title;
  final Widget? trailing;
  final bool enabled;
  final void Function(T)? onChanged;
  final Iterable<T> values;
  final bool Function(T) selected;
  final String Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: Theme.of(context)
          .menuTheme
          .style
          ?.copyWith(alignment: AlignmentDirectional.bottomEnd),
      menuChildren: [
        for (final value in values)
          MenuItemButton(
            onPressed: () => onChanged?.call(value),
            leadingIcon: Visibility.maintain(
              visible: selected(value),
              child: const Icon(Icons.check_outlined),
            ),
            child: Text(labelBuilder(value)),
          ),
      ],
      builder: (context, controller, child) => ListTile(
        title: title,
        trailing: trailing,
        enabled: enabled,
        onTap: () async =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}
