import 'package:flutter/widgets.dart';
import 'package:shop_app/model/formModel.dart';

class FormDataModel extends ChangeNotifier {
  FormData? formData;

  void saveFormData(FormData data) {
    formData = data;
    notifyListeners();
  }
}