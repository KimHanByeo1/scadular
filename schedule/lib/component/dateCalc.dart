import 'package:intl/intl.dart';
import 'package:scadule/model/model.dart';

class DateCalc {
  // 선택한 날짜와 현재 날짜의 '년,월,일'을 String Type으로 가져옴 그 후
  // DateTime으로 타입 변환 한 후 difference 매서드를 이용해 두 날짜 사이의 간격 차이를 계산함
  List<String> subTitle(date) {
    final DateFormat formatter = DateFormat('M월 d일 (E)', 'ko');
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime result;
    int index;

    if (date == null) {
      result = StaticModel.selectedDay;
    } else {
      result = format.parse(date);
    }

    DateTime ymdString = DateTime.parse(
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}");
    DateTime ymdString2 = DateTime.parse(
        "${result.year}-${result.month.toString().padLeft(2, '0')}-${result.day.toString().padLeft(2, '0')}");

    index = ymdString2.difference(ymdString).inDays;

    String text = '';
    String text2 = '';

    if (index == 0) {
      text = '오늘';
      text2 = '오늘';
    } else if (index == 1) {
      text = '내일';
      text2 = '내일';
    } else if (index < 1) {
      text = 'D + ${index.toString().replaceAll('-', '')}';
      text2 = formatter.format(ymdString2);
    } else if (index > 0) {
      text = 'D - ${index.toString()}';
      text2 = formatter.format(ymdString2);
    }
    return [text, text2];
  }
}
