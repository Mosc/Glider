import 'package:flutter/material.dart';

class MenuActionsBar extends StatelessWidget {
  const MenuActionsBar({Key? key, required this.children}) : super(key: key);

  final Iterable<IconButton> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: children
                  .map(
                    (IconButton iconButton) => IconButton(
                      iconSize: 20,
                      onPressed: iconButton.onPressed,
                      tooltip: iconButton.tooltip,
                      icon: iconButton.icon,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
