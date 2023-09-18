class UnscheduledDate{
  List<DateTime> dates = [];
  late DateTime now = utcToKSt(DateTime.now());

  UnscheduledDate() {
    now = utcToKSt(DateTime.now());
  }

  UnscheduledDate.getRecentWeekOnUnscheduled(int scheduleStartDay, int daysBeforeLimited){
    DateTime unscheduledDate = getNextUnscheduledDate(scheduleStartDay);
    if(isWeekValid(unscheduledDate, daysBeforeLimited)){
      weekAfterSelectedDate(unscheduledDate, 0, 7);
    }else{
      weekAfterSelectedDate(unscheduledDate, 7, 14);
    }
  }

  DateTime utcToKSt(DateTime date){
    return date.toUtc().add(Duration(hours : 9));
  }

  DateTime getNextUnscheduledDate(int startDay) {
    int daysUntilNextDay = startDay - now.weekday + 7;
    DateTime nextDate = now.add(Duration(days: daysUntilNextDay));
    return nextDate;
  }

  isWeekValid(DateTime nextUnscheduledDate, int daysBeforeEnd){
    DateTime nextWeekDate = now.add(Duration(days:7));
    DateTime deadLine = nextUnscheduledDate.add(Duration(days: 7-daysBeforeEnd));
    if(nextWeekDate.isBefore(deadLine)){
      return true;
    } else{
      return false;
    }
  }

  void weekAfterSelectedDate(DateTime nextUnscheduledDate, int start, int end) {
    for (int i = start; i < end; i++) {
      DateTime date = nextUnscheduledDate.add(Duration(days:i));
      dates.add(date);
    }
  }


  koreanWeekday(int index) {
    int weekday = this.dates[index].weekday;
    if (weekday == 1) {
      return '월';
    } else if (weekday == 2) {
      return '화';
    } else if (weekday == 3) {
      return '수';
    } else if (weekday == 4) {
      return '목';
    } else if (weekday == 5) {
      return '금';
    } else if (weekday == 6) {
      return '토';
    } else if (weekday == 7) {
      return '일';
    }
  }
}





