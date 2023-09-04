import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/view_model/monthly_cost_view_model.dart';

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
      child: Consumer<MonthlyCostViewModel>(
             builder: (context, prov, child) {
               return TextButton(
                     onPressed: () {
                       prov.renew();
                     },
                     style: TextButton.styleFrom(
                       textStyle: TextStyle(fontSize: (27 * deviceHeight / _designHeight)),
                       padding: const EdgeInsets.all(0),
                       primary: Colors.white,
                     ),
                     child: Column(children: [
                       Text('${DateTime.now().month}월 누적 급여',
                           style: TextStyle(color: Colors.black,
                               fontSize: (14 * deviceHeight / _designHeight)),
                       ),
                       Text('${moneyFormat.format(prov.monthlyPay)}원',
                         style: const TextStyle(color: Colors.black),),
                     ])
                   );
             }),
    );
  }
}