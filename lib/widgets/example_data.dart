import 'package:flutter/material.dart';
import 'package:shopperxm_flutter/widgets/reaction_widget/reaction.dart';



final defaultInitialReaction = Reaction<String>(
  value: null,
  icon: const Text('No reaction'),
);

final reactions = [
  Reaction<String>(
    value: 'heart_emoji_count',
    title: _buildTitle(''),
    previewIcon: _buildReactionsPreviewIcon('assets/heart.png'),
    icon: _buildReactionsIcon(
      'assets/heart.png',
      const Text(
        '',
        style: TextStyle(
          color: Color(0XFF3b5998),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'thumb_emoji_count',
    title: _buildTitle(''),
    previewIcon: _buildReactionsPreviewIcon('assets/thumbs_up.png'),
    icon: _buildReactionsIcon(
      'assets/thumbs_up.png',
      const Text(
        '',
        style: TextStyle(
          color: Color(0XFFed5168),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'wow_emoji_count',
    title: _buildTitle(''),
    previewIcon: _buildReactionsPreviewIcon('assets/wow.png'),
    icon: _buildReactionsIcon(
      'assets/wow.png',
      const Text(
        '',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'sad_emoji_count',
    title: _buildTitle(''),
    previewIcon: _buildReactionsPreviewIcon('assets/sad.png'),
    icon: _buildReactionsIcon(
      'assets/sad.png',
      const Text(
        '',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'laugh_emoji_count',
    title: _buildTitle(''),
    previewIcon: _buildReactionsPreviewIcon('assets/laughing.png'),
    icon: _buildReactionsIcon(
      'assets/laughing.png',
      const Text(
        '',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
 /* Reaction<String>(
    value: 'namaste_emoji_count',
    title: _buildTitle(''),
    previewIcon: _buildReactionsPreviewIcon('assets/namaste.png'),
    icon: _buildReactionsIcon(
      'assets/namaste.png',
      const Text(
        '',
        style: TextStyle(
          color: Color(0XFFf05766),
        ),
      ),
    ),
  ),*/
];


Container _buildTitle(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
    child: Image.asset(path, height: 40),
  );
}

Image _buildIcon(String path) {
  return Image.asset(
    path,
    height: 30,
    width: 30,
  );
}

Container _buildReactionsIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}