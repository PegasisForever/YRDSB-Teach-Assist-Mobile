import 'package:flutter/material.dart';

class WithContextMenu extends StatefulWidget {
  final Widget child;
  final Map<String, VoidCallback> menuItems;

  WithContextMenu({this.child, this.menuItems});

  @override
  _WithContextMenuState createState() => _WithContextMenuState();
}

class _WithContextMenuState extends State<WithContextMenu> {
  Offset _tapPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        final RenderBox overlay = Overlay.of(context).context.findRenderObject();

        var list = List<Widget>();
        widget.menuItems.forEach((name, callback) => list.add(ListTile(
              title: Text(name),
              onTap: callback,
            )));

        await showMenu(
            context: context,
            items: <PopupMenuEntry>[
              ContainerMenuEntry(
                child: Column(
                  children: list,
                ),
              )
            ],
            position: RelativeRect.fromRect(
                _tapPosition & Size(40, 40), // smaller rect, the touch area
                Offset.zero & overlay.size // Bigger rect, the entire screen
                ));
      },
      onTapDown: (details) => _tapPosition = details.globalPosition,
      child: widget.child,
    );
  }
}

class ContainerMenuEntry extends PopupMenuEntry {
  final Widget child;

  ContainerMenuEntry({this.child});

  @override
  final double height = 0;

  @override
  bool represents(value) => true;

  @override
  ContainerMenuEntryState createState() => ContainerMenuEntryState();
}

class ContainerMenuEntryState extends State<ContainerMenuEntry> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
