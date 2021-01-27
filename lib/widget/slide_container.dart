

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum SlideDirection {
  left,top,right,bottom,
}

class SlideStack extends StatefulWidget {

  final SlideContainer child;
  final Widget drawer;

  SlideStack(this.child,this.drawer) : super();

  @override
  State<StatefulWidget> createState() {
    return StackSlideState();
  }
}

class StackSlideState extends State<SlideStack> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.drawer,
        widget.child
      ],
    );
  }
}

class SlideContainer extends StatefulWidget {

  final Widget child;

  final double shadowBlurRadius;
  final double shadowSpreadRadius;

  final SlideDirection slideDirection;

  final double drawerSize;

  final double minAutoSlideDistance;

  final Duration autoSlideDuration;

  final double minAutoSlideDragVelocity;

  final double dragDampening;

  final VoidCallback onSlideStarted;
  final VoidCallback onSlideCompleted;
  final VoidCallback onSlideCanceled;
  final ValueChanged<double> onSlide;

  final Matrix4 transform;

  SlideContainer(this.child,{
    Key key,
    this.shadowBlurRadius = 15.0,
    this.shadowSpreadRadius = 10.0,
    this.minAutoSlideDragVelocity = 600.0,
    this.dragDampening = 8.0,
    this.slideDirection = SlideDirection.left,
    this.drawerSize,
    this.minAutoSlideDistance,
    this.autoSlideDuration = const Duration(microseconds: 250),
    this.onSlideStarted,
    this.onSlideCompleted,
    this.onSlideCanceled,
    this.onSlide,
    this.transform
  }
    ) : assert(child != null),
  assert(slideDirection != null),
  assert(minAutoSlideDragVelocity != null),
  assert(autoSlideDuration != null),
  assert(dragDampening != null && dragDampening >= 1.0),super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ContainerState();
  }
}

class ContainerState extends State<SlideContainer> with TickerProviderStateMixin {

  final Map<Type,GestureRecognizerFactory> gestures = {};

  double dragValue = 0.0;  // 手指拖动距离
  double dragTarget = 0.0;  // view 移动距离

  bool isFirstDragFrame;

  AnimationController animationController;
  Ticker fingerTicker;

  bool get isSlideVertical => widget.slideDirection == SlideDirection.top || widget.slideDirection == SlideDirection.bottom;

  double get maxDragDistance => widget.drawerSize ?? (isSlideVertical ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width );

  double get minAutoSlideDistance => widget.minAutoSlideDistance ?? maxDragDistance * 0.5;

  double get containerOffset => animationController.value * maxDragDistance * dragTarget.sign;  // sign target 得符号 -1 或 +1

  double get height => MediaQuery.of(context).size.height;

  double get heightOffset => height * animationController.value / 10;

  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: widget.autoSlideDuration)
    ..addListener(() {
        if(widget.onSlide != null) {
          widget.onSlide(animationController.value);
        } else {
          setState(() {

          });
        }
    });
    fingerTicker = createTicker((elapsed) {
      if ((dragValue - dragTarget).abs() < 1.0) {
        dragTarget = dragValue;
      } else {
        dragTarget += (dragValue - dragTarget) / widget.dragDampening;
      }
      animationController.value = dragTarget.abs() / maxDragDistance;
    });
    registerGestureRecognizer();
    super.initState();

  }

  @override
  void dispose() {
    animationController?.dispose();
    fingerTicker?.dispose();
    super.dispose();
  }

  GestureRecognizerFactoryWithHandlers<T> createGestureRecognizer<T extends DragGestureRecognizer>(GestureRecognizerFactoryConstructor<T> constructor) =>
      GestureRecognizerFactoryWithHandlers<T>(constructor,
          (T instance) {
            instance
            ..onStart = handleDragStart
            ..onUpdate = handleDragUpdate
            ..onEnd = handleDragEnd;
          }
      );

  void registerGestureRecognizer() {
    if (isSlideVertical) {
      gestures[VerticalDragGestureRecognizer] = createGestureRecognizer<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer());
    } else {
      gestures[HorizontalDragGestureRecognizer] = createGestureRecognizer<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer());
    }
  }

  double getVelocity(DragEndDetails details) => isSlideVertical ? details.velocity.pixelsPerSecond.dy : details.velocity.pixelsPerSecond.dx;

  double getDelta(DragUpdateDetails details) => isSlideVertical ? details.delta.dy : details.delta.dx;

  void openOrClose() {
    final AnimationStatus status = animationController.status;
    final bool isOpen = status == AnimationStatus.completed || status == AnimationStatus.forward;
    dragTarget = isOpen ? dragTarget : 1.0;
    animationController.fling(velocity: isOpen ? -2.0 : 2.0).then((value) => {
      print("${animationController.value} ,,, $dragTarget")
    });
  }

  void completeSlide() => animationController.forward().then((value) => {
    // 回调完成
    if(widget.onSlideCompleted != null) widget.onSlideCompleted()
  });

  void cancelSlide() => animationController.reverse().then((value) => {
    // 取消
    if(widget.onSlideCanceled != null) widget.onSlideCanceled()
  });

  void handleDragStart(DragStartDetails details) {
    isFirstDragFrame = true;
    dragValue = animationController.value * maxDragDistance * dragTarget.sign;
    dragTarget = dragValue;
    fingerTicker.start();
    // 开始
    if (widget.onSlideStarted != null) {
      widget.onSlideStarted();
    }
  }

  void handleDragUpdate(DragUpdateDetails details) {
    if(isFirstDragFrame) {
      isFirstDragFrame = false;
      return;
    }
    dragValue = (dragValue + getDelta(details)).clamp(-maxDragDistance, maxDragDistance);
    if(widget.slideDirection == SlideDirection.top || widget.slideDirection == SlideDirection.left) {
      dragValue = dragValue.clamp(0.0, maxDragDistance);
    } else {
      dragValue = dragValue.clamp(-maxDragDistance, 0.0);
    }
  }

  void handleDragEnd(DragEndDetails details) {
    if (getVelocity(details) * dragTarget.sign > widget.minAutoSlideDragVelocity) {
      completeSlide();
    }else if(getVelocity(details) * dragTarget.sign < - widget.minAutoSlideDragVelocity){
      cancelSlide();
    } else {
      dragTarget.abs() > minAutoSlideDistance ? completeSlide() : cancelSlide();
    }
    fingerTicker.stop();
  }

  Widget getContainer() {
    if (hasShadow) {
      return Container(
        height: height * (1 - animationController.value / 5),
        child: widget.child,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black45,
            offset: Offset(10.0, 0.0),
            blurRadius: widget.shadowBlurRadius,
            spreadRadius: widget.shadowSpreadRadius)
          ]
        ),
        transform: widget.transform,
      );
    } else {
      return Container(
        child: widget.child,
        transform: widget.transform,
      );
    }
  }

  bool get hasShadow => widget.shadowBlurRadius != null && widget.shadowSpreadRadius != null;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: gestures,
      child: Transform.translate(offset:
          isSlideVertical ? Offset(0.0, containerOffset) : Offset(containerOffset, heightOffset),
        child: getContainer(),
      ),
    );
  }
}