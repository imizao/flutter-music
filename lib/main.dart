import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'MusicPlayerControls.dart';

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
  Duration _duration = Duration();
  Duration _position = Duration();
  Duration _dragValue = Duration();
  bool _dragging = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _audioPlayer.setUrl(currentSong).then((_) {});

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.COMPLETED) {
        setState(() {
          isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });

    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (!_dragging) {
        setState(() {
          _position = p;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_position.inSeconds == 0) {
        await _audioPlayer.play(currentSong);
      } else {
        await _audioPlayer.resume();
      }
    }
    setState(() => isPlaying = !isPlaying);
  }

  void _seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
    setState(() => _position = newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音乐播放器'),
        backgroundColor: Colors.redAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '推荐'),
            Tab(text: '乐馆'),
            Tab(text: '听书'),
            Tab(text: '故事'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 搜索功能
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // 更多选项
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 推荐页面内容
          MusicPlayerControls(
            isPlaying: isPlaying,
            position: _position,
            duration: _duration,
            dragging: _dragging,
            dragValue: _dragValue,
            onPlayPause: _playPause,
            onSeekToSecond: _seekToSecond,
            onSliderChanged: (double value) {
              setState(() {
                _dragging = true;
                _dragValue = Duration(seconds: value.toInt());
              });
            },
            onSliderChangeEnd: (double value) {
              setState(() {
                _dragging = false;
                _position = Duration(seconds: value.toInt());
              });
              _seekToSecond(value.toInt());
            },
          ),
          // 乐馆页面内容
          Center(child: Text('乐馆内容')),
          // 听书页面内容
          Center(child: Text('听书内容')),
          // 故事页面内容
          Center(child: Text('故事内容')),
        ],
      ),
    );
  }
}
