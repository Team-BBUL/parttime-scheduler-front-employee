import "package:flutter/material.dart";
import 'package:sidam_employee/util/app_color.dart';
import 'package:sidam_employee/view/widget/weekly_schedule_viewer.dart';
import 'package:sidam_employee/view/work_swap_view.dart';
import 'package:sidam_employee/view/unworkable_schedule_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TimeTable extends StatefulWidget {
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  AppColor color = AppColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '주간 근무표',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UnworkableSchedulePage()));
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  foregroundColor: color.mainColor,
                  backgroundColor: color.moreWhiterColor,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
              ),
              child: const Text(
                '스케줄 희망 편성',
                style: TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ),

            const SizedBox(width: 10,),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    backgroundColor: color.whiterColor,
                    padding: const EdgeInsets.all(7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WorkSwap())
                  );
                },
                child: const Text(
                  '근무교환',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                )),

            const SizedBox(width: 10,),
          ],
        ),
        body: Center(
          child: Container(
            //color: Color(0xFFa0c0c0), // 0xffc1c1c1 부터 검은색
            child: WeeklyScheduleViewer()
        )));
  }

  Widget scheduleView() {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // 자바 스크립트 사용 여부
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        // 웹뷰 이벤트 처리
        NavigationDelegate(
          onProgress: (int progress) {
            // 창 로딩 중에 할 일
            debugPrint('progressing $progress');
          },
          onPageStarted: (String url) {
            // 페이지 시작 때 할 일
            debugPrint(url);
          },
          onPageFinished: (String url) {
            // 페이지 닫을 때 할 일
            debugPrint('Page Finished');
          },
          onWebResourceError: (WebResourceError error) {
            // 웹에 에러 났을 때
            debugPrint('web error');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev')); // 접속할 url 여기에 토큰 추가

    return Scaffold(
        body: WebViewWidget(
      controller: controller,
    ));
  }
}
