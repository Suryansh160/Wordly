import 'package:flutter/material.dart';

class TabControl extends StatefulWidget {
  final TabController? controller;
  final Function(TabController)? onControllerCreated;

  const TabControl({super.key, this.controller, this.onControllerCreated});

  @override
  _TabControlState createState() => _TabControlState();
}

class _TabControlState extends State<TabControl>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override //
  void initState() {
    super.initState();
    _tabController = widget.controller ?? TabController(length: 3, vsync: this);

    // If a callback is provided, send the controller back to parent
    widget.onControllerCreated?.call(_tabController);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      dividerColor: Colors.grey,
      tabs: const [
        Tab(
          text: "Noun",
        ),
        Tab(text: "Verb"),
        Tab(text: "Synonyms"),
        Tab(text: "hi"),
      ],
    );
  }
}
