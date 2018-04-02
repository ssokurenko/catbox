import 'package:catbox/cat_repo.dart';
import 'package:flutter/material.dart';

import 'package:catbox/ui/cat_info/cat_info_page.dart';
import 'package:catbox/ui/cats/cat.dart';

class CatsPage extends StatefulWidget {
  @override
  _CatsPageState createState() => new _CatsPageState();
}

class _CatsPageState extends State<CatsPage> {
  List<Cat> _cats = [];

  @override
  void initState() {
    super.initState();
    _loadFirebaseCats();
  }

  _loadFirebaseCats() async {
    // TODO: Separate login. Alternatively, use singleton for simplicity?
    final repo = await CatRepo.fromEMailAuth("rico.beti@gmail.com", "1a2b3c4d5e");
    final cats = await repo.getAllCats();
    setState(() {
      _cats = cats;
    });
  }

  _buildCatItem(BuildContext context, int index) {
    Cat cat = _cats[index];

    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () => _navigateToCatDetails(cat, index),
              leading: new Hero(
                tag: index,
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(cat.avatar),
                ),
              ),
              title: new Text(cat.name),
              subtitle: new Text(cat.description),
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }

  _navigateToCatDetails(Cat cat, Object avatarTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new CatDetailsPage(cat, avatarTag: avatarTag);
        },
      ),
    );
  }

  Widget _getAppTitleWidget() {
    return new Text(
      'Cats',
      style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
    );
  }

  Widget _buildBody() {
    return new Container(
      // A top margin of 56.0. A left and right margin of 8.0. And a bottom margin of 0.0.
      margin: const EdgeInsets.fromLTRB(8.0, 56.0, 8.0, 0.0),
      child: new Column(
        // A column widget can have several widgets that are placed in a top down fashion
        children: <Widget>[_getAppTitleWidget(), _getListViewWidget()],
      ),
    );
  }

  Widget _getListViewWidget() {
    return new Flexible(
        child: new ListView.builder(itemCount: _cats.length, itemBuilder: _buildCatItem));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue,
      body: _buildBody(),
    );
  }
}
