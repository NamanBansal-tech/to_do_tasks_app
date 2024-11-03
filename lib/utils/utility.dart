import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_tasks/models/task_model/task_model.dart';

class Utility {
  static Future<bool> checkInternetConnection() async {
    bool hasInternet = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternet = true;
        if (kDebugMode) {
          print('connected');
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('not connected');
      }
    }
    return hasInternet;
  }

  static Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.yellow.shade900;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  static String formatDisplayDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatServerDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
