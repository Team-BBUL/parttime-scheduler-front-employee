import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view/impossible_schedule.dart';
import 'package:sidam_employee/view_model/impossible_schedule_view_model.dart';

import '../data/repository/impossible_schedule_repository.dart';

class SelectSchedulePage extends StatelessWidget{
  const SelectSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectScheduleViewModel>(
        create: (_) => SelectScheduleViewModel(ImpossibleScheduleRepository()),
        child: const SelectScheduleScreen());
  }


}