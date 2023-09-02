import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/view/store_list.dart';
import 'package:sidam_worker/view/store_list_search.dart';
import 'package:sidam_worker/view_model/store_view_model.dart';

import '../data/repository/store_repository.dart';
import '../data/repository/store_repository_mock.dart';

class StoreListSearchPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreViewModel>(
        create: (_) => StoreViewModel(StoreRepositoryImpl()),
        child: StoreListSearchScreen());
  }
}