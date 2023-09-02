import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:sidam_worker/view/widget/loading.dart";
import "package:sidam_worker/view/widget/pass_fail_viewer.dart";
import "package:sidam_worker/view/widget/swap_schedule_viewer.dart";

import "package:sidam_worker/viewModel/work_swap_view_model.dart";
import 'package:sidam_worker/utility/shared_preference_provider.dart';

class WorkSwap extends StatefulWidget {
  @override
  _WorkSwapState createState() => _WorkSwapState();
}

class _WorkSwapState extends State<WorkSwap> {
  // design constant
  final _designWidth = 411;
  final _designHeight = 683;

  // model

  void loadSPProvider() async {
    final provider = Provider.of<SharedPreferencesProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    //context.read<WorkSwapViewModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    var titleStyle = const TextStyle(
      fontSize: 18,
    );

    loadSPProvider();

    var timeFormat = DateFormat('M월 dd일');

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double indent = 15;

    return Consumer<WorkSwapViewModel>(builder: (context, prov, child) {
      return Stack(children: <Widget>[
        Scaffold(
          appBar: AppBar(
              title: Text(
                '근무 교환 신청하기',
                style: titleStyle,
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      prov.init();
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset('assets/icons/x_black.svg')),
              ]),
          body: Center(
              child: prov.deon ? ResultViewer() :
                  Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          SizedBox(
                              width: deviceWidth,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            prov.changeDate(prov.week.subtract(
                                                const Duration(days: 7)));
                                          });
                                        },
                                        icon: SvgPicture.asset('assets/icons/chevron-left.svg')),
                                    Text('${timeFormat.format(prov.week)} - '
                                        '${timeFormat.format(prov.week.add(const Duration(days: 6)))}'),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            prov.changeDate(prov.week
                                                .add(const Duration(days: 7)));
                                          });
                                        },
                                        icon: SvgPicture.asset('assets/icons/chevron-right.svg')),
                                  ])),
                          const SizedBox(
                            height: 5,
                          ),
                          Divider(
                            indent: indent,
                            endIndent: indent,
                            color: Colors.grey,
                          ),
                          SwapViewer(),
                        ],
                      ),
                    )),
        ),
        // 로딩화면 보여주기
        if (prov.loading) Loading(),
      ]);
    });
  }
}
