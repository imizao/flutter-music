import 'package:flutter/material.dart';
import 'dart:math';

class MusicPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool dragging;
  final Duration dragValue;
  final Function() onPlayPause;
  final Function(int) onSeekToSecond;
  final Function(double) onSliderChanged;
  final Function(double) onSliderChangeEnd;

  const MusicPlayerControls({
    super.key,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.dragging,
    required this.dragValue,
    required this.onPlayPause,
    required this.onSeekToSecond,
    required this.onSliderChanged,
    required this.onSliderChangeEnd,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage('https://picsum.photos/200'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '当前歌曲',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '艺术家',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Slider(
          activeColor: Colors.redAccent,
          inactiveColor: Colors.grey,
          value: dragging
              ? dragValue.inSeconds.toDouble()
              : min(
                  position.inSeconds.toDouble(), duration.inSeconds.toDouble()),
          min: 0.0,
          max: duration.inSeconds.toDouble() > 0
              ? duration.inSeconds.toDouble()
              : 1.0,
          onChanged: duration.inSeconds > 0
              ? (double value) {
                  onSliderChanged(value);
                }
              : null,
          onChangeEnd: duration.inSeconds > 0
              ? (double value) {
                  onSliderChangeEnd(value);
                }
              : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(position)),
              Text(_formatDuration(duration)),
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
              iconSize: 48,
              onPressed: onPlayPause,
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
        SizedBox(height: 20),
      ],
    );
  }
}
