import 'package:flutter/cupertino.dart';
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
      return new Icon(Icons.check, color: currAccentColor,);
    }
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new CupertinoSliverNavigationBar(
              largeTitle: new Text("Select a Regional", style: TextStyle(color: Colors.white),),
              backgroundColor: mainColor,
            ),
          ];
        },
        body: new ListView.builder(
          itemCount: regionalList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(regionalList[index].shortName, style: TextStyle(color: currTextColor),),
                    subtitle: new Text(regionalList[index].key, style: TextStyle(color: currDividerColor),),
                    leading: getLeading(regionalList[index]),
                    onTap: () {
                      setState(() {
                        currRegional = regionalList[index];
                      });
                      router.pop(context);
                    },
                  ),
                  new Divider(
                    color: currAccentColor,
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
