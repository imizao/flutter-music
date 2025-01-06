import 'package:flutter/material.dart';
import 'MusicPlayerControls.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentSong =
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  Duration _duration = Duration();
  Duration _position = Duration();
  Duration _dragValue = Duration();
  bool _dragging = false;

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
    return Column(
      children: [
        // TabBar 放在顶部
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent, // 选中项的下划线颜色
          labelColor: const Color(0xFF333333), // 选中项的文字颜色
          unselectedLabelColor: const Color(0xFF999999), // 未选中项的文字颜色
          labelStyle:
              TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 选中项的字体样式
          unselectedLabelStyle: TextStyle(fontSize: 14), // 未选中项的字体样式
          tabs: [
            Tab(text: '推荐'),
            Tab(text: '乐馆'),
            Tab(text: '听书'),
            Tab(text: '故事'),
          ],
        ),
        // TabBarView 放在主体部分
        Expanded(
          child: TabBarView(
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
        ),
      ],
    );
  }
}
