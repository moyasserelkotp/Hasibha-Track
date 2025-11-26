import 'package:flutter/material.dart';

import '../../const/app_dimensions.dart';

extension WidgetExtensions on Widget {
  // Add padding
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  // Add margin using Container
  Widget marginAll(double value) {
    return Container(
      margin: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  // Make widget visible/invisible
  Widget visible(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: this,
    );
  }

  // Add gesture detector
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }

  // Center widget
  Widget get center {
    return Center(child: this);
  }

  // Expand widget
  Widget get expand {
    return Expanded(child: this);
  }

  // Flexible widget
  Widget flexible({int flex = 1}) {
    return Flexible(flex: flex, child: this);
  }

  // Add card
  Widget card({
    double? elevation,
    Color? color,
    ShapeBorder? shape,
  }) {
    return Card(
      elevation: elevation ?? AppDimensions.cardElevation,
      color: color,
      shape: shape,
      child: this,
    );
  }

  // Add SizedBox with constraints
  Widget sizedBox({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  // Add opacity
  Widget opacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }

  // Add hero animation
  Widget hero(String tag) {
    return Hero(
      tag: tag,
      child: this,
    );
  }

  // Add SafeArea
  Widget get safeArea {
    return SafeArea(child: this);
  }
}
