
class UpcomingWeek{
  //현재부터 앞으로 일주일의 DateTime을 저장하는 리스트
  List<DateTime> dates = [];
  //현재부터 앞으로 일주일의 한국어 요일을 저장하는 리스트
  List<String> days = [];

  UpcomingWeek(){
    getWeekFromSelectedDate(DateTime.now());
  }

  UpcomingWeek.deadLine(int deadLine) {
    DateTime nextDeadLine = getNextDeadLine(deadLine);
    getWeekFromSelectedDate(nextDeadLine);
  }

  DateTime getNextDeadLine(int deadLine) {
    DateTime now = DateTime.now();
    int daysUntilNextDeadLine = deadLine - now.weekday + 7;
    DateTime nextDeadLine = now.add(Duration(days: daysUntilNextDeadLine));
    return nextDeadLine;
  }

  void getWeekFromSelectedDate(DateTime selectedDate) {
    //UTC + 9 => KST
    Duration duration = const Duration(hours:9);
    for (int i = 0; i < 7; i++) {
      //date 형식 2023-05-27 00:11:15.380787Z
      DateTime date = selectedDate.toUtc().add(Duration(days: i)).add(duration);
      // String yearMonthDay = date.year.toString() + date.month.toString() + date.day.toString();

      dates.add(date);
      days.add(convertWeekdayToKorean(date.weekday));
    }
  }
}

  convertWeekdayToKorean(int weekday) {
    if(weekday == 1) {
      return '월';
    }else if(weekday == 2) {
      return '화';
    }else if(weekday == 3) {
      return '수';
    }else if(weekday == 4) {
      return '목';
    }else if(weekday == 5) {
      return '금';
    }else if(weekday == 6) {
      return '토';
    }else if(weekday == 7) {
      return '일';
    }
  }


