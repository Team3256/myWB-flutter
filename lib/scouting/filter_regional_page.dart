import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';

class FilterRegionalPage extends StatefulWidget {
  @override
  _FilterRegionalPageState createState() => _FilterRegionalPageState();
}

class _FilterRegionalPageState extends State<FilterRegionalPage> {

  Widget getLeading(Regional regional) {
    if (currRegional == regional) {
      return new Icon(Icons.check, color: mainColor,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Select a Regional"),
      ),
      body: new Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.white,
        child: new ListView.builder(
          itemCount: regionalList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(regionalList[index].shortName),
                    subtitle: new Text(regionalList[index].key),
                    leading: getLeading(regionalList[index]),
                    onTap: () {
                      setState(() {
                        currRegional = regionalList[index];
                      });
                      router.pop(context);
                    },
                  ),
                  new Divider(
                    color: mainColor,
                    height: 0.0,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
