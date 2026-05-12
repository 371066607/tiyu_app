import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat dayFormat = DateFormat('M月d日');
  static final DateFormat shortWeekdayFormat = DateFormat('E', 'zh_CN');
  static final DateFormat kickoffFormat = DateFormat('yyyy-MM-dd HH:mm');
}
