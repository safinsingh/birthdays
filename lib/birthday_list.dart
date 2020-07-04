import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class BirthdayList extends StatefulWidget {
  @override
  BirthdayListState createState() => BirthdayListState();
}

class BirthdayListState extends State<BirthdayList> {
  final _birthdays = <String, String>{
    "Person 1": "January 01",
    "Person 2": "January 02",
    "Person 3": "January 03",
    "Person 4": "January 04",
  };

  final _favorites = [];

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
            },
          ), // icon-1
          IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () => _pushEdit(context)), // icon-2
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

  void _pushEdit(BuildContext context) {
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
          print(month);
          print(day);
        }).showDialog(context);
  }

  void _pushSearch() {}
  void _pushAdd() {}

  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => _pushSaved(),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _pushSearch(),
          )
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
}
