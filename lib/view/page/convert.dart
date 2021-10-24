import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({Key? key}) : super(key: key);

  @override
  _ConvertPageState createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _textEditingController;
  late TextEditingController _textEditingControllerResult;
  late MediaQueryData _media;
  late ThemeData _theme;

  static const List<String> _typeOption = [
    'base64 decode',
    'base64 encode',
    'URL encode',
    'URL decode'
  ];
  int _typeOptionIndex = 0;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingControllerResult = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _theme = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GestureDetector(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: AnimationLimiter(
              child: Column(
                  children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 377),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              const SizedBox(height: 13),
              _buildInputTop(),
              _buildTypeOption(),
              _buildResult(),
            ],
          ))),
        ),
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _textEditingControllerResult.text = doConvert();
        },
        tooltip: 'convert',
        child: const Icon(Icons.send),
      ),
    );
  }

  String doConvert() {
    final text = _textEditingController.text;
    switch (_typeOptionIndex) {
      case 0:
        return utf8.decode(base64.decode(text));
      case 1:
        return base64.encode(utf8.encode(text));
      case 2:
        return Uri.encodeFull(text);
      case 3:
        return Uri.decodeFull(text);
      default:
        return 'Unknown';
    }
  }

  Widget _buildInputTop() {
    return SizedBox(
      height: _media.size.height * 0.33,
      child: _buildInput(_textEditingController),
    );
  }

  Widget _buildTypeOption() {
    return Card(
      child: ExpansionTile(
        leading: TextButton(
          child: SizedBox(
            width: _media.size.width * 0.2,
            child: Row(
              children: const [Icon(Icons.change_circle), Text('上下交换')],
            ),
          ),
          onPressed: () {
            final temp = _textEditingController.text;
            _textEditingController.text = _textEditingControllerResult.text;
            _textEditingControllerResult.text = temp;
          },
        ),
        title: SizedBox(
          width: _media.size.width * 0.4,
          child: Text(
            _typeOption[_typeOptionIndex],
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        ),
        children: _typeOption
            .map((e) => ListTile(
                  title: Text(
                    e,
                    style: TextStyle(
                        color:
                            _theme.textTheme.bodyText2!.color!.withAlpha(177)),
                  ),
                  trailing: _buildRadio(_typeOption.indexOf(e)),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildResult() {
    return SizedBox(
      height: _media.size.height * 0.33,
      child: _buildInput(_textEditingControllerResult),
    );
  }

  Widget _buildInput(TextEditingController controller) {
    return Card(
      child: TextField(
        maxLines: 20,
        decoration: InputDecoration(
            fillColor: Theme.of(context).cardColor,
            filled: true,
            border: InputBorder.none),
        controller: controller,
      ),
    );
  }

  Radio _buildRadio(int index) {
    return Radio<int>(
      value: index,
      groupValue: _typeOptionIndex,
      onChanged: (int? value) {
        setState(() {
          _typeOptionIndex = value!;
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
