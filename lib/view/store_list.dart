import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view/store_list_search_page.dart';

import '../main.dart';
import '../util/appColor.dart';
import '../view_model/store_view_model.dart';

class StoreListScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
        builder:(context, viewModel,child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Store List'),
            ),
            body: SafeArea(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                  child:               Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Flexible(flex: 7, child: Container()),
                          Flexible(flex: 2,
                              child: TextButton(onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder:
                                        (context) => StoreListSearchPage()
                                    ) // (context) => WebViewWidget(controller: _webViewController,))
                                );
                              }, child: Text("매장 찾기"),)),
                        ],
                      ),
                      Flexible(
                        flex: 0,
                        child: Container(
                          child: Row(
                            children: [
                              Flexible(flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Text("등록매장목록"), IconButton(onPressed: (){
                                      viewModel.renew();
                                    }, icon: Icon(Icons.cached))]
                                  )),
                              // Flexible(flex: 7, child: Container()),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 4,
                          child: Container(
                            child: ListView.builder(
                              itemCount: viewModel.stores?.length ?? 0,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      viewModel.setSelectedIndex(index);
                                    },
                                    child: Container(
                                        height: 75,
                                        alignment: Alignment.centerLeft,
                                        decoration:  BoxDecoration(
                                          border: index == viewModel.selectedIndex
                                              ? Border.all(
                                                  width: 3,
                                                  color: AppColor().mainColor
                                          )
                                          : Border(bottom: BorderSide(color: Colors.grey,width: 1,),)
                                          // border: Border.all(width: 1, color: Colors.black)
                                        ),
                                        child: ListTile(
                                          title: Text("${viewModel.stores?[index].name}"),
                                          subtitle: Text("${viewModel.stores?[index].location}"),
                                        )
                                    )
                                );
                              },
                            ),
                          )
                      )
                    ],
                  ),
                )
            ),
            floatingActionButton: Container(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 50.0),
                width: double.infinity,
                child: FloatingActionButton(
                  onPressed: () {
                    viewModel.enter().then(
                            (value) =>
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder:
                                    (context) => MyHomePage(title: '',)
                                ))
                    ).catchError(
                            (error) => null);
                  },
                  child: const Text("입장",
                    style: TextStyle(fontSize: 17,color: Colors.black),
                  ),
                  backgroundColor: AppColor().mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                )
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

          );
        }
    );
  }


}