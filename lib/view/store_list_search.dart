import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/view/store_list_page.dart';
import 'package:sidam_worker/view_model/store_view_model.dart';

import '../main.dart';
import '../util/appColor.dart';
import '../util/dialog_message.dart';

class StoreListSearchScreen extends StatelessWidget{

  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
        builder:(context, viewModel,child) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Search'),
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex : 1,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 9,
                            child: TextField(
                              onChanged: (text) => viewModel.setSearchText(text),
                              onSubmitted: (_) => viewModel.getStoresWithSearch(),
                              decoration: const InputDecoration(
                                hintText: '매장명을 입력해주세요',
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                                ),
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),

                          Flexible(flex: 1,
                              child: GestureDetector(
                                  onTap: () => viewModel.getStoresWithSearch(),
                                  child: Icon(Icons.search))),
                        ],
                      ),
                    ),
                    Flexible(
                        child: ListView.builder(
                            itemCount:viewModel.stores?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      )
                                  ),
                                  child: GestureDetector(
                                      onTap:()=>{viewModel.setStore(index)},
                                      child: Container(
                                          child:Text("${viewModel.stores?[index].name ?? ''}")
                                      )
                                  )
                              );
                            }
                        )
                    ),
                    viewModel.expanded ? Text(
                      "매장명 : ${viewModel.storeInfo.name}\n 주소 :${viewModel.storeInfo.location}",
                    ) : Container(),
                    Flexible(
                      child: viewModel.storeInfo.id != null ? Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: FilledButton(onPressed: () {
                            Message().showConfirmDialog(
                                context: context,
                                title: "매장 등록",
                                message: "매장에 등록하시겠습니까?",
                              apiCall: () => viewModel.joinStore(),
                            );
                          },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColor().mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text("등록",
                              style: TextStyle(fontSize: 17,color: Colors.black),
                            ),
                          ),
                        ),
                      ) : SizedBox(height: 80, width: 10,),
                    ),
                  ],
                ),
              )
          );
        }
    );
  }
}
