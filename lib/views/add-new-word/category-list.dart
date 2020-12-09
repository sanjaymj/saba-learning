import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/views/add-new-word/add-new-word-change-notifier.dart';
import 'package:sabalearning/views/add-new-word/saba-filter-chip.dart';

class CategoryList extends StatelessWidget {
  LocalStorageService localstorage;
  final Function updateCategory;
  final Function deleteCategory;

  CategoryList(this.updateCategory, this.deleteCategory);
  @override
  Widget build(BuildContext context) {
    final newWordMenuNotifier = Provider.of<AddNewWordChangeNotifier>(context);
    final user = Provider.of<User>(context);
    localstorage = new LocalStorageService(user.uid);

    var categories = localstorage.getStoredCategoriesForCurrentuser(user.uid);
    return FutureBuilder(
      future: categories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          default:
            if (snapshot.hasError)
              return new Container(width: 0.0, height: 0.0);
            else if (snapshot.data != null)
              return SabaFilterChip(
                  snapshot.data, updateCategory, deleteCategory);
            return new Container(width: 0.0, height: 0.0);
        }
      },
    );
  }
}
