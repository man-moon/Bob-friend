import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  @override
  State<Content> createState() => _ContentState();
}

_getPosition(GlobalKey key) {
  if (key.currentContext != null) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return position;
  }
}

class _ContentState extends State<Content> {
  FocusNode textFocusNode = FocusNode();
  GlobalKey _barKey = GlobalKey();
  double y = 0.0;
  double x = 230;
  bool _visibility = false;
  bool _widgetUse = false;
  void _show() {
    setState(() {
      _visibility = true;
    });
  }

  void _hide() {
    setState(() {
      _visibility = false;
    });
  }

  void _fix(double y1) {
    setState(() {
      y = y1;
    });
  }
  void showKeyboard(){
    if(_widgetUse==true){
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: y),
        alignment: Alignment(0.0, 1.0),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  if(_widgetUse==false){
                  final barPosition = _getPosition(_barKey);
                  _fix(x);
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  currentFocus.unfocus();
                  _show();
                  _widgetUse=true;
                  }
                  else{
                    _fix(0);
                    _hide();
                    _widgetUse=false;
                  }
                },
                icon: Icon(Icons.add_box)),
            Expanded(
              key: _barKey,

              child: TextField(
                onTap:(){
                  showKeyboard();
                },
                focusNode: textFocusNode,
                maxLines: null,
                decoration: InputDecoration(labelText: '메시지 전송'),
              ),
              ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.send_rounded),
              color: Colors.orangeAccent,
            ),
          ],
        ),
      ),
      bottomSheet: Visibility(
          visible: _visibility,
          child: Container(
            height: x,
            width: double.infinity,
            color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child:
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                          onPressed: () {}, icon: Icon(Icons.abc_rounded)),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shop_2_rounded),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shop_2_rounded),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                        },
                        icon: Icon(Icons.shop_2_rounded),
                      ),
                    ),
                  ],
                ),),
                Expanded(child:
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shop_2_rounded),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shop_2_rounded),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shop_2_rounded),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shop_2_rounded),
                      ),
                    ),
                  ],
                ),
                      ),
                ],
            ),
          )),
    );
  }
}

/*
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child:
            IconButton(
                onPressed: (){},
                icon: Icon(Icons.abc_rounded)
            ),
          ),
          Expanded(
            child:
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.shop_2_rounded),
            ),
          ),
        ],
      ),
    );*/
