import 'package:flutter/material.dart';

class BirthdayList extends StatefulWidget {
  @override
  BirthdayListState createState() => BirthdayListState();
}

class BirthdayListState extends State<BirthdayList> {
  TextEditingController editingController = TextEditingController();

  final _birthdays = [
    {"name": "Person 1", "date": "January 1"},
    {"name": "Person 2", "date": "January 2"},
    {"name": "Person 3", "date": "January 3"},
    {"name": "Person 4", "date": "January 4"},
    {"name": "Person 5", "date": "January 5"},
  ];

  final _favorites = Set<Map>();
  Widget _buildList() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.black54,
              thickness: 1,
            ),
        itemCount: _birthdays.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRow(_birthdays[index]);
        });
  }

  Widget _buildRow(birthday) {
    final alrSaved = _favorites.contains(birthday);
    return ListTile(
      title: Text(birthday['name'] + ": " + birthday['date']),
      trailing: Icon(alrSaved ? Icons.favorite : Icons.favorite_border,
          color: alrSaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alrSaved) {
            _favorites.remove(birthday);
          } else {
            _favorites.add(birthday);
          }
        });
      },
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
          title: Text(birthday['name'] + ": " + birthday['date']),
        );
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();
      return Scaffold(
          appBar: AppBar(title: favoriteTitle),
          body: ListView(children: divided));
    }));
  }

  void _pushAdd() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(appBar: AppBar(title: addTitle), body: Text("Add"));
    }));
  }

  void _pushSearch() {}

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
