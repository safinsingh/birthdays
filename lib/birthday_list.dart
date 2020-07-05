import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// import 'package:jiffy/jiffy.dart';
// import 'package:jiffy/src/enums/units.dart';
// Jiffy("2020 $month $day", "yyyy MMMM dd").fromNow()

class BirthdayList extends StatefulWidget {
  @override
  BirthdayListState createState() => BirthdayListState();
}

class BirthdayListState extends State<BirthdayList> {
  var _birthdays = <String, String>{};

  var _favorites = [];

  final monthMap = <String, String>{
    "01": "January",
    "02": "February",
    "03": "March",
    "04": "April",
    "05": "May",
    "06": "June",
    "07": "July",
    "08": "August",
    "09": "September",
    "10": "October",
    "11": "November",
    "12": "December",
  };

  var newDate = "";
  var newName = "";

  @override
  void initState() {
    getBirthdaysPref().then(updateBirthdays);
    super.initState();
  }

  void updateBirthdays(String birthdays) {
    setState(() {
      this._birthdays = json.decode(birthdays);
    });
  }

  void updateFavorites(String favorites) {
    setState(() {
      this._favorites = json.decode(favorites);
    });
  }

  Widget _buildList() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.black54,
              thickness: 1,
            ),
        itemCount: _birthdays.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRow(_birthdays.keys.toList()[index]);
        });
  }

  Widget _buildRow(birthday) {
    final alrSaved = _favorites.contains(birthday);
    return ListTile(
      title: Text(birthday + ": " + _birthdays[birthday]),
      trailing: Wrap(
        children: <Widget>[
          IconButton(
            icon: new Icon(alrSaved ? Icons.favorite : Icons.favorite_border,
                color: alrSaved ? Colors.red : null),
            onPressed: () {
              setState(() {
                if (alrSaved) {
                  _favorites.remove(birthday);
                } else {
                  _favorites.add(birthday);
                }
              });
              saveFavorites(_favorites);
            },
          ), // icon-1
          IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () => _pushEdit(context, birthday)),
          IconButton(
              icon: new Icon(Icons.backspace),
              onPressed: () {
                setState(() {
                  _birthdays.remove(birthday);
                });
                saveBirthdays(_birthdays);
              }), // icon-2
        ],
      ),
    );
  }

  final title = Text("Birthdays");
  final favoriteTitle = Text("Favorites");
  final addTitle = Text("Add a Birthday");

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _favorites.map((birthday) {
        return ListTile(
          title: Text(birthday + ": " + _birthdays[birthday]),
        );
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();
      return Scaffold(
          appBar: AppBar(title: favoriteTitle),
          body: ListView(children: divided));
    }));
  }

  void _pushEdit(BuildContext context, String birthday) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(),
        title: Text("Select New Birthday"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          final date = (picker.adapter as DateTimePickerAdapter)
              .value
              .toString()
              .substring(5, 11);
          final month = monthMap[date.substring(0, 2)];
          final day = date.substring(3, 5);

          setState(() {
            _birthdays[birthday] = month + " " + day;
          });
          saveBirthdays(_birthdays);
        }).showDialog(context);
  }

  void _pushAddDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(),
        title: Text("Select New Birthday"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          final date = (picker.adapter as DateTimePickerAdapter)
              .value
              .toString()
              .substring(5, 11);
          final month = monthMap[date.substring(0, 2)];
          final day = date.substring(3, 5);
          setState(() {
            newDate = "$month $day";
          });
        }).showDialog(context);
  }

  void _pushAddSubmit(BuildContext context) {
    setState(() {
      _birthdays[newName] = newDate;
    });
    saveBirthdays(_birthdays);
    Navigator.of(context).pop();
  }

  void _pushAdd() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return addScreen(context);
    }));
  }

  Scaffold addScreen(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: addTitle),
        body: Row(
          children: <Widget>[
            Expanded(
              flex: 2, // 20%
              child: Container(),
            ),
            Expanded(
              flex: 6, // 60%
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Set Name',
                      ),
                      onChanged: (text) {
                        setState(() {
                          newName = text;
                        });
                      },
                    ),
                    FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () => _pushAddDate(context),
                      child: Text(
                        "Set Date",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () => _pushAddSubmit(context),
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ]),
            ),
            Expanded(
              flex: 2, // 20%
              child: Container(),
            )
          ],
        ));
  }

  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => _pushSaved(),
          ),
        ],
      ),
      body: _buildList(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        backgroundColor: Colors.blue[700],
        onPressed: () => _pushAdd(),
      ),
    );
  }

  void saveBirthdays(bdays) {
    saveBirthdaysPref(bdays);
  }

  void saveFavorites(favs) {
    saveFavoritesPref(favs);
  }
}

Future<bool> saveBirthdaysPref(Map birthdays) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("birthdays", json.encode(birthdays));

  return true;
}

Future<String> getBirthdaysPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String birthdays = prefs.getString("birthdays");
  return birthdays;
}

Future<bool> saveFavoritesPref(List favorites) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("favorites", json.encode(favorites));

  return true;
}

Future<String> getFavoritesPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String favorites = prefs.getString("favorites");
  return favorites;
}
