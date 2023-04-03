import 'package:flutter/cupertino.dart';
import 'package:localstore/localstore.dart';

import '../models/theme_entity.dart';

class ThemeChanger extends ChangeNotifier {

  String currentTheme;
  ThemeChanger(this.currentTheme){
    loadTheme();
  }

  get getTheme => currentTheme;
  void setTheme(String theme) {
    currentTheme = theme;
    Localstore.instance.collection('theme').doc('123').set(
        ThemeEntity(currentTheme: theme, id: "123").toMap()
    );
    notifyListeners();
  }

  loadTheme() async {
    var localTheme = await Localstore.instance.collection('theme').doc('123').get();
    if(localTheme != null){
      currentTheme = ThemeEntity.fromJson(localTheme).currentTheme;
      notifyListeners();
    }else{
      currentTheme = "light";
      notifyListeners();
    }
  }
}