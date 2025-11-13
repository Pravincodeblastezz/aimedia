import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class ImageFeed extends StatefulWidget {
  const ImageFeed({super.key});

  @override
  State<ImageFeed> createState() => _ImageFeedState();
}

class _ImageFeedState extends State<ImageFeed> {
  List<Map<String, dynamic>> images = [
    {
      "name": "Chair and Baloon",
      "caption": "Chair and Baloon",
      "date": "2025-11-12",
      "image_url": "https://images.unsplash.com/photo-1429087969512-1e85aab2683d?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "name": "Banana",
      "caption": "Banana PhotoShoot!",
      "date": "2025-11-10",
      "image_url": "https://images.unsplash.com/photo-1481349518771-20055b2a7b24?q=80&w=1239&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "name": "Rose",
      "caption": "Rose in glass vase",
      "date": "2025-11-11",
      "image_url": "https://images.unsplash.com/photo-1518895949257-7621c3c786d7?q=80&w=688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "name": "Sign Board",
      "caption": "Neon Sign Board",
      "date": "2025-11-09",
      "image_url": "https://images.unsplash.com/photo-1496449903678-68ddcb189a24?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "name": "Bulb",
      "caption": "Holding a bulb in hand by sunset",
      "date": "2025-11-08",
      "image_url": "https://images.unsplash.com/photo-1493612276216-ee3925520721?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1964"
    },
  ];

  String sortType = "Title";
  String sortOrder = "Ascending";
  final Map<String, String> aiResults = {};
  String? analyzingImage; // tracks which image is being processed

  void _sortImages() {
    setState(() {
      if (sortType == "Title") {
        images.sort((a, b) => sortOrder == "Ascending"
            ? a['name'].compareTo(b['name'])
            : b['name'].compareTo(a['name']));
      } else if (sortType == "Date") {
        images.sort((a, b) => sortOrder == "Ascending"
            ? a['date'].compareTo(b['date'])
            : b['date'].compareTo(a['date']));
      }
    });
  }

  Future<void> _analyze(String imageUrl) async {
    setState(() => analyzingImage = imageUrl);
    final result = await AIService.analyzeImage(imageUrl);
    setState(() {
      aiResults[imageUrl] = result;
      analyzingImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Sorting Controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
              // ElevatedButton.icon(
              //   onPressed: _sortImages,
              //   icon: const Icon(Icons.sort),
              //   label: const Text("Sort"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blueAccent,
              //   ),
              // ),
            ],
          ),
        ),

        // 🔹 Image List
        Expanded(
          child: ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              final img = images[index];
              final aiOutput = aiResults[img['image_url']];
              final isAnalyzing = analyzingImage == img['image_url'];

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (img['image_url'] != null)
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          img['image_url'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                        ),
                      ),
                    ListTile(
                      title: Text(
                        img['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(img['caption']),
                          Text("📅 Date: ${img['date']}"),
                          const SizedBox(height: 8),
                          if (aiOutput != null)
                            Text(
                              "🧠 AI: $aiOutput",
                              style: const TextStyle(
                                color: Colors.green,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          const SizedBox(height: 4),
                          TextButton.icon(
                            onPressed: isAnalyzing
                                ? null
                                : () => _analyze(img['image_url']),
                            icon: isAnalyzing
                                ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Icon(Icons.auto_awesome),
                            label: Text(isAnalyzing
                                ? "Analyzing..."
                                : "Analyze Image"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
