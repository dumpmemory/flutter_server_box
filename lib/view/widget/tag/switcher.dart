import 'package:flutter/material.dart';
import 'package:toolbox/data/res/ui.dart';
import 'package:toolbox/view/widget/fade_in.dart';
import 'package:toolbox/view/widget/tag/view.dart';

class TagSwitcher extends StatelessWidget {
  final List<String> tags;
  final double width;
  final void Function(String?) onTagChanged;
  final String? initTag;
  final String all;

  const TagSwitcher({
    Key? key,
    required this.tags,
    required this.width,
    required this.onTagChanged,
    required this.all,
    this.initTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return placeholder;
    final items = <String?>[null, ...tags];
    return Container(
      height: 37,
      width: width,
      alignment: Alignment.center,
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = items[index];
          return FadeIn(
            key: ValueKey(initTag),
            child: TagView(
              tag: item,
              initTag: initTag,
              all: all,
              onTap: onTagChanged,
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
