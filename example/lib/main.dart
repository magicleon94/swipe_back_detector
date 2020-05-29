import 'package:flutter/material.dart';
import 'package:swipe_back_detector/swipe_back_detector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swipe back detector example"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Push route"),
          onPressed: () {
            Navigator.of(context).push(
              MyCustomRoute(
                widget: SecondScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second screen"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              5,
              (_) => Icon(Icons.chevron_left),
            ),
          ),
          Text("Swipe here to go back")
        ],
      )),
    );
  }
}

class MyCustomRoute extends PageRouteBuilder {
  final RouteSettings routeSettings;

  MyCustomRoute({
    @required Widget widget,
    this.routeSettings,
  }) : super(
          settings: routeSettings,
          pageBuilder: (context, animation1, animation2) {
            return widget;
          },
          transitionsBuilder: (context, animation1, animation2, child) {
            return SwipeBackDetector(
              child: SlideTransition(
                position: Tween<Offset>(begin: Offset(1, 1), end: Offset.zero)
                    .animate(animation1),
                child: FadeTransition(
                  opacity: animation1,
                  child: widget,
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 250),
          opaque: false,
          barrierDismissible: true,
        );
}
