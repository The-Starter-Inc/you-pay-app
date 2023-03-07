import 'package:intl/intl.dart';

class MyanNunber {
  static String convertNumber(String number) {
    String num = number;
    num = num.replaceAll("1", "၁");
    num = num.replaceAll("2", "၂");
    num = num.replaceAll("3", "၃");
    num = num.replaceAll("4", "၄");
    num = num.replaceAll("5", "၅");
    num = num.replaceAll("6", "၆");
    num = num.replaceAll("7", "၇");
    num = num.replaceAll("8", "၈");
    num = num.replaceAll("9", "၉");
    num = num.replaceAll("0", "၀");
    return num;
  }

  static String convertMoneyNumber(dynamic number) {
    var f = NumberFormat("###.0#", "en_US");
    String num = f.format(number);
    num = num.replaceAll("1", "၁");
    num = num.replaceAll("2", "၂");
    num = num.replaceAll("3", "၃");
    num = num.replaceAll("4", "၄");
    num = num.replaceAll("5", "၅");
    num = num.replaceAll("6", "၆");
    num = num.replaceAll("7", "၇");
    num = num.replaceAll("8", "၈");
    num = num.replaceAll("9", "၉");
    num = num.replaceAll("0", "၀");
    return num;
  }
}
