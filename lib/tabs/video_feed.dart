import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/ai_service.dart';

class VideoFeed extends StatefulWidget {
  const VideoFeed({super.key});

  @override
  State<VideoFeed> createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  List<Map<String, dynamic>> videos = [
    {
      "title": "Flutter Basics",
      "date": "2025-11-10",
      "video_url":
      "https://www.shutterstock.com/shutterstock/videos/3880836101/preview/stock-footage-bangkok-thailand-august-asian-teenagers-performing-random-dance.webm"
    },
    {
      "title": "AI Image Analysis",
      "date": "2025-11-11",
      "video_url":
      "https://www.shutterstock.com/shutterstock/videos/3857633283/preview/stock-footage-athletic-woman-with-long-brown-hair-in-a-ponytail-performs-mountain-climbers-on-the-gym-floor.webm"
    },
    {
      "title": "Firebase Setup",
      "date": "2025-11-08",
      "video_url":
      "https://www.shutterstock.com/shutterstock/videos/3790480187/preview/stock-footage-aerial-train-travels-through-a-picturesque-swiss-alpine-valley-passing-through-pine-forests.webm"
    },
    {"title": "Advanced Dart", "date": "2025-11-12"},
    {"title": "App Deployment", "date": "2025-11-09"},
  ];

  final Map<String, String> summaries = {};
  final Map<String, VideoPlayerController> controllers = {};
  String? loadingTitle;

  // Sorting variables
  String sortType = "Title";
  String sortOrder = "Ascending";

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _sortImages() {
    setState(() {
      if (sortType == "Title") {
        videos.sort((a, b) =>
            a['title'].toString().compareTo(b['title'].toString()));
      } else if (sortType == "Date") {
        videos.sort((a, b) =>
            DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
      }

      if (sortOrder == "Descending") {
        videos = videos.reversed.toList();
      }
    });
  }

  Future<void> _summarize(String videoUrl) async {
    setState(() => loadingTitle = videoUrl);
    final result = await AIService.analyzeVideo(videoUrl);
    setState(() {
      summaries[videoUrl] = result;
      loadingTitle = null;
    });
  }

  Future<void> _togglePlay(String title, String url) async {
    if (!controllers.containsKey(title)) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      controllers[title] = controller;
      await controller.initialize();
      controller.setLooping(true);
      setState(() {});
      controller.play();
    } else {
      final controller = controllers[title]!;
      setState(() {
        controller.value.isPlaying ? controller.pause() : controller.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔽 Dropdown Sort Row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  DropdownButton<String>(
                    value: sortType,
                    items: const [
                      DropdownMenuItem(
                          value: "Title", child: Text("Sort by Title")),
                      DropdownMenuItem(
                          value: "Date", child: Text("Sort by Date")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => sortType = value);
                        _sortImages();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: sortOrder,
                    items: const [
                      DropdownMenuItem(
                          value: "Ascending", child: Text("Ascending")),
                      DropdownMenuItem(
                          value: "Descending", child: Text("Descending")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => sortOrder = value);
                        _sortImages();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // 🔽 Video list
        Expanded(
          child: ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final vid = videos[index];
              final summary = summaries[vid['video_url']];
              final controller = controllers[vid['title']];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vid['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Date: ${vid['date']}"),

                      if (summary != null)
                        Text(
                          "AI Summary: $summary",
                          style: const TextStyle(color: Colors.green),
                        ),

                      const SizedBox(height: 8),

                      if (vid['video_url'] != null) ...[
                        controller == null
                            ? TextButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Play Video"),
                          onPressed: () => _togglePlay(
                            vid['title'],
                            vid['video_url'],
                          ),
                        )
                            : AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(controller),
                              if (!controller.value.isPlaying)
                                GestureDetector(
                                  onTap: () => _togglePlay(
                                    vid['title'],
                                    vid['video_url'],
                                  ),
                                  child: const Icon(
                                    Icons.play_circle_fill,
                                    size: 60,
                                    color: Colors.white70,
                                  ),
                                ),
                              if (controller.value.isPlaying)
                                GestureDetector(
                                  onTap: () => _togglePlay(
                                    vid['title'],
                                    vid['video_url'],
                                  ),
                                  child: Container(
                                    color: Colors.transparent,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        TextButton(
                          onPressed: loadingTitle == vid['video_url']
                              ? null
                              : () => _summarize(vid['video_url']),
                          child: loadingTitle == vid['video_url']
                              ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Text("Summarize Video"),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
