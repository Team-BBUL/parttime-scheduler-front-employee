import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view/unworkable_schedule.dart';
import 'package:sidam_employee/view_model/unworkable_schedule_view_model.dart';

import '../data/repository/unworkable_schedule_repository.dart';

class UnworkableSchedulePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UnworkableScheduleViewModel>(
        create: (_) => UnworkableScheduleViewModel(ImpossibleScheduleRepository()),
        child: UnworkableScheduleScreen());
  }
}