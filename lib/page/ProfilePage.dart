import 'package:flutter/material.dart';
import 'ChartPage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('我的'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildStats(),
            _buildQuickActions(context),
            _buildPlaylists(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                'https://img2.baidu.com/it/u=1254672238,1423772385&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800'), // 替换为你的头像路径
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('theboy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('开启会员', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('关注', '216'),
          _buildStatItem('粉丝', '117'),
          _buildStatItem('金币', '51'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    // 接收 context
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem(context, Icons.bar_chart, '图表'), // 传递 context
          _buildActionItem(context, Icons.brush, '装扮'),
          _buildActionItem(context, Icons.calendar_today, '日签'),
          _buildActionItem(context, Icons.collections, '收藏'),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // 点击跳转到新页面
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChartPage()), // 跳转到 ChartPage
        );
      },
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.blue), // 图标颜色设置为蓝色
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPlaylists() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('最近播放',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _buildPlaylistItem('图表', '走势'),
          _buildPlaylistItem('耳朵新区', '深度睡眠'),
          _buildPlaylistItem('自建歌单', '20'),
          _buildPlaylistItem('收藏歌单', '300'),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem(String title, String subtitle) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4), // 增加垂直间距
      decoration: BoxDecoration(
        color: Colors.white, // 背景色
        borderRadius: BorderRadius.circular(8), // 圆角
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // 阴影颜色
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2), // 阴影偏移
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 0), // 内边距
        leading: Icon(Icons.music_note, color: Colors.blue), // 左侧图标
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // 右侧箭头
        onTap: () {
          // 点击事件
          print('$title 被点击了');
        },
      ),
    );
  }
}
