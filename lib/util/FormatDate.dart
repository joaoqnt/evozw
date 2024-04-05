import 'package:intl/intl.dart';

class FormatingDate{
  static String formatDDMMYYYY = 'dd/MM/yyyy';
  static String formatDDMM = 'dd/MM';
  static String formatHHMM = 'HH:mm';
  static String formatDDMMYYYYHHMM = 'dd/MM/yyyy HH:mm';
  static String formatInsert = 'yyyy-MM-dd HH:mm:ss';

  static getDate(DateTime? dateTime, String format) {
    return DateFormat(format).format(dateTime!);
  }

  static getDateToInsert(DateTime dateTime,{bool? data}) {
    if(data != null && data){
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }else {
      return DateFormat(formatInsert).format(dateTime);
    }
  }
}