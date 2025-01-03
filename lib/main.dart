import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentSong = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  Duration _duration = Duration();
  Duration _position = Duration();
  Duration _dragValue = Duration();
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    
    // 预先加载音频
    _audioPlayer.setUrl(currentSong).then((_) {
      // 此时会触发 onDurationChanged 事件
    });

    // 使用 onPlayerStateChanged 监听播放状态
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.COMPLETED) {
        setState(() {
          isPlaying = false;
          _position = Duration.zero;  // 重置播放位置到开始
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
          _dragValue = p;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      // 如果是从头开始播放
      if (_position.inSeconds == 0) {
        await _audioPlayer.play(currentSong);
      } else {
        // 从暂停位置继续播放
        await _audioPlayer.resume();
      }
    }
    
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
    // 立即更新位置，避免跳动
    setState(() {
      _position = newDuration;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音乐播放器'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/300'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            '当前歌曲',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Slider(
            activeColor: Colors.redAccent,
            inactiveColor: Colors.grey,
            value: _dragging ? _dragValue.inSeconds.toDouble() : _position.inSeconds.toDouble(),
            min: 0.0,
            max: _duration.inSeconds.toDouble(),
            onChanged: (double value) {
              setState(() {
                _dragging = true;
                _dragValue = Duration(seconds: value.toInt());
              });
            },
            onChangeEnd: (double value) {
              _dragging = false;  // 先更新拖动状态
              _seekToSecond(value.toInt());  // 然后更新位置
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position)),
                Text(_formatDuration(_duration)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                iconSize: 36,
                onPressed: () {
                  // 上一首
                },
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 36,
                onPressed: _playPause,
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                iconSize: 36,
                onPressed: () {
                  // 下一首
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
