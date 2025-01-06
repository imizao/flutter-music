import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'page/homePage.dart';
import 'page/LivePage.dart';
import 'page/RadarPage.dart';
import 'page/GamesPage.dart';
import 'page/ProfilePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentSong =
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";

  int _currentIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // 底部导航栏对应的路由
  final List<Widget> _pages = [
    HomePage(),
    LivePage(),
    RadarPage(),
    GamesPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // 更新当前选中的索引
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '音乐播放器',
          style: TextStyle(
            color: Colors.white, // 设置字体颜色为白色
          ),
        ),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // 搜索功能
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              // 更多选项
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.redAccent, // 选中项的颜色
        unselectedItemColor:
            const Color.fromARGB(255, 141, 140, 140), // 未选中项的颜色
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // 底部导航栏的背景色
        type: BottomNavigationBarType.fixed, // 确保所有项都可见
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: '直播',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radar),
            label: '雷达',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: '玩乐',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

// class LivePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('直播内容'));
//   }
// }

// class RadarPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('雷达内容'));
//   }
// }

// class GamesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('玩乐内容'));
//   }
// }

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('我的内容'));
//   }
// }
