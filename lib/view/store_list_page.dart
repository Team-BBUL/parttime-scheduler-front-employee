import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/data/repository/store_repository.dart';
import 'package:sidam_employee/view/store_list.dart';

import '../view_model/store_view_model.dart';


class StoreListPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreViewModel>(
        create: (_) => StoreViewModel(StoreRepositoryImpl()),
        child: StoreListScreen());
  }
}