import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view_model/cost_view_model.dart';

class CostScreen extends StatefulWidget{
  const CostScreen({super.key});

  @override
  _CostScreenState createState() => _CostScreenState();
}

class _CostScreenState extends State<CostScreen> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    //viewmodel을 이 위치에서 init할 시 viewmodel에 의존성이 생기는 문제가 있음 => 이를 해결하기 위해 cost_page(ChangeNotifierProvider)를 사용
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    super.initState();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cost Screen'),
        ),
        body: Consumer<CostViewModel>(
          builder:(context, viewModel,child){
            return SingleChildScrollView(
              child : Column(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      child: Row(
                        children: const [
                          Expanded(
                              child: Icon(Icons.arrow_circle_left)
                          ),
                          Expanded(
                            child: Center(
                              child: Text("2023년 3월"),
                            ),
                          ),
                          Expanded(
                              child: Icon(Icons.arrow_circle_right)
                          )
                        ],
                      )
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Row(
                        children: const [
                          Expanded(
                              child:
                              Text("이번 달 총 인건비")
                          ),
                          Expanded(
                            child: Text(""),
                          ),
                          Expanded(
                            child: Text(""),
                          ),
                        ],
                      )
                  ),
                  Container(
                      child: Row(
                        children: const [
                          Expanded(
                            child: Center(
                              child: Text('10,000,000원', style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                      child: Row(
                        children: const [
                          Expanded(
                            child: Center(
                                child: Text("")
                            ),
                          ),
                          Expanded(
                            child: Text("2월 달 보다 20,000원 증가"),
                          )
                        ],
                      )
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text("급여계산방식확인"),
                                IconButton(
                                  icon:Icon(Icons.arrow_drop_down),
                                  onPressed: _toggleExpansion,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(""),
                          ),
                        ]
                    ),
                  ),
                  Container(
                      child : Row(
                        children: const [
                          Expanded(
                              child: Center(
                                child: Text("총 근무 57시간", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                              )
                          ),
                          Expanded(
                              child: Center(
                                child: Text("시급 11,000원", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                              )
                          ),
                        ],
                      )
                  ),
                  AnimatedContainer(
                    margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    duration: Duration(milliseconds: 500),
                    height: _isExpanded ? (viewModel.schedule.length)*75.0 : 0.0,
                    curve: Curves.easeInOut,
                    child: Column(
                      children: viewModel.schedule
                          .map((schedule) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                        child: Column(
                            children : [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                                child: Row(
                                  children : [
                                    Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(width: 1, color: Colors.grey),
                                              color: Colors.grey
                                          ),
                                          child: Center(
                                            child: Text(schedule.date),
                                          ),
                                        )
                                    ),
                                    const Expanded(
                                        child:Text("")
                                    ),
                                    const Expanded(
                                        child:Text("")
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text("일반 근무 ${schedule.day}시간"),
                                      )
                                    ),
                                    Expanded(
                                        child: Center(
                                          child: Text("야간 근무 ${schedule.night}시간"),
                                        )
                                    ),
                                    Expanded(
                                        child: Center(
                                          child: Text("급여 ${schedule.cost}원"),
                                        )
                                    ),
                                  ],
                                ),
                              ),

                            ]
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              )
            );

          }
        )
    );
  }

}