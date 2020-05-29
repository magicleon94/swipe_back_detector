library swipe_back_detector;

import 'package:flutter/widgets.dart';

///Detect an iOS style swipe gesture on the border of the screen to pop
///[child] is the child to wrap with the pop gesture detector
///[cutoffVelocity] is the minimum velocity needed for the gesture to trigger
///[swipeAreaWidth] is the width of the detection area
///[verticalPadding] allows to restrict the detection area remaining vertically centered
///[popValue] is the value you want to pop out when performing a gesture
class SwipeBackDetector<T> extends StatefulWidget {
  final Widget child;
  final double cutoffVelocity;
  final double swipeAreaWidth;
  final double verticalPadding;
  final T popValue;

  const SwipeBackDetector({
    Key key,
    this.child,
    this.cutoffVelocity = 600,
    this.swipeAreaWidth = 5,
    this.verticalPadding = 0,
    this.popValue,
  }) : super(key: key);

  @override
  _SwipeBackDetectorState createState() => _SwipeBackDetectorState();
}

class _SwipeBackDetectorState extends State<SwipeBackDetector> {
  Offset dragStart;
  Rect swipeArea;
  final cutoffVelocity = 600;

  @override
  void didChangeDependencies() {
    swipeArea ??= Rect.fromPoints(
      Offset(0, widget.verticalPadding),
      Offset(
        widget.swipeAreaWidth,
        MediaQuery.of(context).size.height - widget.verticalPadding,
      ),
    );
    super.didChangeDependencies();
  }

  bool _popGesturePerformed(DragEndDetails dragEnd) {
    return dragStart != null && dragEnd.primaryVelocity >= cutoffVelocity;
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (swipeArea.contains(details.localPosition)) {
      dragStart = details.localPosition;
    } else {
      dragStart = null;
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta < 0) {
      dragStart = null; //cancel the gesture if we're going back
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_popGesturePerformed(details)) {
      Navigator.of(context).pop(widget.popValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: widget.child,
    );
  }
}
