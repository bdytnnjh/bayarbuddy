import 'package:flutter/material.dart';

class NavBottomBarCustomItem {
  String imagePath;
  String text;

  NavBottomBarCustomItem({required this.imagePath, required this.text});
}

class NavBottomBarCustomWidget extends StatefulWidget {
  final List<NavBottomBarCustomItem> items;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color unselectedColor;
  final Color selectedColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int> onTabSelected;
  final int selected;

  const NavBottomBarCustomWidget({
    super.key,
    required this.items,
    this.height = 75.0,
    this.iconSize = 30.0,
    required this.backgroundColor,
    required this.unselectedColor,
    required this.selectedColor,
    this.notchedShape,
    required this.onTabSelected,
    required this.selected,
  });

  @override
  State<StatefulWidget> createState() => NavBottomBarCustomWidgetState();
}

class NavBottomBarCustomWidgetState extends State<NavBottomBarCustomWidget> {
  _updateIndex(int index) {
    widget.onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    return BottomAppBar(
      elevation: 15,
      notchMargin: 10.0,
      height: widget.height,
      shape: widget.notchedShape,
      shadowColor: Colors.black,
      padding: const EdgeInsets.all(4),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required NavBottomBarCustomItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    Color color = widget.selected == index
        ? widget.selectedColor
        : widget.unselectedColor;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: TextButton(
            onPressed: () => onPressed(index),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  item.imagePath,
                  color: color,
                  width: widget.iconSize,
                  height: widget.iconSize,
                ),
                Text(item.text, style: TextStyle(color: color, fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
