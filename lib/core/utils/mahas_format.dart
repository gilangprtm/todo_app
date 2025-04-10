import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MahasFormat {
  static String displayDate(DateTime? date) {
    if (date == null) return "-";
    var dateFormat = DateFormat("dd MMMM yyyy");
    return dateFormat.format(date);
  }

  static String? dateToString(DateTime? date) {
    if (date == null) return null;
    var dateFormat = DateFormat("yyyy-MM-dd");
    return dateFormat.format(date);
  }

  static String? timeToString(
    TimeOfDay? time, {
    bool twentyFour = true,
    bool millisecond = true,
  }) {
    if (time == null) return null;
    var hour =
        twentyFour ? time.hour : (time.hour > 12 ? time.hour - 12 : time.hour);
    if (hour == 0) {
      hour = 12;
    }
    var minute = time.minute;
    var strHour = hour > 9 ? '$hour' : '0$hour';
    var strMinute = minute > 9 ? '$minute' : '0$minute';
    var r = "$strHour:$strMinute";
    if (millisecond) {
      r += ":00";
    }
    return twentyFour ? r : '$r ${time.hour > 12 ? 'PM' : 'AM'}';
  }

  static String? dateTimeOfDayToString(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return "${dateToString(date)}T${timeToString(time)}";
  }

  static String displayTime(
    TimeOfDay? time, {
    bool twentyFour = true,
  }) {
    if (time == null) return "-";
    var hour =
        twentyFour ? time.hour : (time.hour > 12 ? time.hour - 12 : time.hour);
    if (hour == 0) {
      hour = 12;
    }
    var minute = time.minute;
    var strHour = hour > 9 ? '$hour' : '0$hour';
    var strMinute = minute > 9 ? '$minute' : '0$minute';
    var r = "$strHour:$strMinute";
    return twentyFour ? r : '$r ${time.hour > 12 ? 'PM' : 'AM'}';
  }

  static DateTime? stringToDateTime(String? stringDate) {
    if (stringDate == null) return null;
    try {
      return DateTime.parse(stringDate);
    } catch (ex) {
      return null;
    }
  }

  static TimeOfDay? stringToTime(String? time) {
    if (time == null) return null;
    final add = time.indexOf("PM") > 0 ? 12 : 0;
    final r = TimeOfDay(
        hour: int.parse(time.split(":")[0]) + add,
        minute: int.parse(time.split(":")[1].split(' ')[0]));
    return r;
  }

  static String toCurrency(double? value) {
    if (value == null) return "";
    var numberFormat = NumberFormat('#,###');
    return numberFormat.format(value);
  }

  static double currencyToDouble(String? value) {
    if (value == null) return 0;
    value = value.replaceAll(',', '');
    return double.parse(value);
  }

  static double? dynamicToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value);
  }

  static DateTime? dynamicToDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return stringToDateTime(value);
    return DateTime.tryParse(value);
  }

  static int? dynamicToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value);
  }

  static bool? dynamicToBool(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      return value == 1
          ? true
          : value == 0
              ? false
              : null;
    }
    if (value is String) {
      return (value.toUpperCase() == "TRUE" || value.toUpperCase() == "1")
          ? true
          : (value.toUpperCase() == "FALSE" || value.toUpperCase() == "0")
              ? false
              : null;
    }
    return value;
  }
}
