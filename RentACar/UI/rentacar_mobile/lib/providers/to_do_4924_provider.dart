import '../models/to_do_4924.dart';
import 'base_provider.dart';

class ToDo4924ModelProvider extends BaseProvider<ToDo4924Model> {
  ToDo4924ModelProvider() : super("ToDo4924");
  @override
  ToDo4924Model fromJson(data) {
    //     // TODO: implement fromJson
    return ToDo4924Model.fromJson(data);
  }
}