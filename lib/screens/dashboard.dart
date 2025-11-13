import 'package:flutter/material.dart';
import '../tabs/image_feed.dart';
import '../tabs/video_feed.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI MEDIA"),
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: "Image Feed"),
            Tab(text: "Video Feed"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          ImageFeed(),
          VideoFeed(),
        ],
      ),
    );
  }
}
