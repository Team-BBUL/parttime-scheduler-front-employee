import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/viewModel/cost_view_model.dart';

class MonthlyCost extends StatefulWidget{
  const MonthlyCost({super.key});

  @override
  State<StatefulWidget> createState() => _MonthlyCostState();
}

class _MonthlyCostState extends State<MonthlyCost> {
  // design constant
  final _designWidth = 411;
  final _designHeight = 683;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    var moneyFormat = NumberFormat('###,###,###,###');

    return SizedBox(
      width: deviceWidth,
      child: Consumer<CostViewModel>(
             builder: (context, prov, child) {
               return Column(
                 children: [
                   Text('${DateTime.now().month}월 예상 급여'),
                   Text('${moneyFormat.format(prov.monthlyPay)}원',
                     style: TextStyle(fontSize: 30 * deviceHeight / _designHeight),
                   ),
                 ],
               );
             }),
    );
  }
}