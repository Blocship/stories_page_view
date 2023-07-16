import 'package:example/model/story.dart';
import 'package:example/view/progress_bar.dart';
import 'package:example/view/snap_view.dart';
import 'package:flutter/material.dart';
import 'package:stories_page_view/stories_page_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SukukStoriesPage(index: 0),
              ),
            );
          },
          child: const Text("Go to Sukuk Stories"),
        ),
      ),
    );
  }
}

class SukukStoriesPage extends StatefulWidget {
  final int index;
  const SukukStoriesPage({
    super.key,
    required this.index,
  });

  @override
  State<SukukStoriesPage> createState() => _SukukStoriesPageState();
}

class _SukukStoriesPageState extends State<SukukStoriesPage> {
  final List<Story> storiesData = [];

  Future<void> getData() async {
    await Future.delayed(const Duration(seconds: 5));
    storiesData.add(
      Story.fromJson({
        "data": "Story 1",
        "snaps": [
          {
            "type": "text",
            "data": "Hello World",
            "duration": "5",
          },
          {
            "type": "image",
            "data":
                "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            "duration": "5"
          },
          {
            "type": "video",
            "data":
                "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            "duration": "10"
          },
        ],
      }),
    );
    storiesData.add(
      Story.fromJson({
        "data": "Story 2",
        "snaps": [
          {
            "type": "image",
            "data":
                "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            "duration": "5"
          },
          {
            "type": "text",
            "data": "Hello World 2",
            "duration": "5",
          },
        ],
      }),
    );
    storiesData.add(
      Story.fromJson({
        "data": "Story 3",
        "snaps": [
          {
            "type": "video",
            "data":
                "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            "duration": "10"
          },
        ],
      }),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget getChild(
    int storyPageIndex,
    int snapIndex,
    StoryController controller,
  ) {
    final snap = storiesData[storyPageIndex].snaps[snapIndex];
    return SnapView.fromSnap(controller: controller, snap: snap);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (storiesData.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: StoryPageView(
        pageCount: storiesData.length,
        outOfRangeCompleted: () {
          Navigator.of(context).pop();
        },
        durationBuilder: (pageIndex, snapIndex) {
          return storiesData[pageIndex].snaps[snapIndex].duration;
        },
        snapCountBuilder: (pageIndex) {
          return storiesData[pageIndex].snaps.length;
        },
        snapInitialIndexBuilder: (pageIndex) {
          return 0;
        },
        itemBuilder: (context, pageIndex, snapIndex, animation, controller) {
          return Stack(
            children: [
              getChild(pageIndex, snapIndex, controller),
              SafeArea(
                child: StoryProgressBars(
                  snapIndex: snapIndex,
                  snapCount: storiesData[pageIndex].snaps.length,
                  animation: animation,
                  builder: (progress) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                        child: ProgressBarIndicator(
                          progress: progress,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
