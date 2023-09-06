import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/view/cost.dart';
import 'package:sidam_worker/view_model/cost_view_model.dart';

class CostPage extends StatelessWidget {
  const CostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CostViewModel>(
        create: (_) => CostViewModel(),
        child: const CostScreen());
  }
}