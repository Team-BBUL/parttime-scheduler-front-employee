import "../data/local_data_source.dart";

class DeleteViewModel {
  final LocalDataSource _dataSource = LocalDataSource();

  void deleteLocalDataAll() async {
    await _dataSource.deleteAll();
  }
}