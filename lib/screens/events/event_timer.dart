import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';

class EventTimer {
  CountdownTimer getTimer(int time) {
    return CountdownTimer(
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
      endTime: time,
      defaultDays: "==",
      defaultHours: "--",
      defaultMin: "**",
      defaultSec: "++",
      daysSymbol: " d ",
      hoursSymbol: " h ",
      minSymbol: " m ",
      secSymbol: " s",
    );
  }
}
