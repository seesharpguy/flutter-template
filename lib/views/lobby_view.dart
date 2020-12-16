import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/viewmodels/lobby_viewmodel.dart';
import 'package:jibe/models/jibe_models.dart';

class Lobby extends StatefulWidget {
  final String gameId;
  const Lobby({Key key, this.gameId}) : super(key: key);
  @override
  _LobbyState createState() {
    return _LobbyState();
  }
}

class _LobbyState extends State<Lobby> {
  @override
  Widget build(BuildContext context) {
    return BaseView<LobbyViewModel>(onModelReady: (model) {
      model.listenToPosts();
    }, builder: (context, model, build) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text('Game Lobby')),
          body: _buildBody(context, model),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context, LobbyViewModel viewModel) {
    // return _buildList(context, viewModel);

    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: List.generate(viewModel.players.length, (index) {
        return getStructuredGridCell(viewModel.players[index]);
      }),
    );
  }

  Column getStructuredGridCell(Player player) {
    return new Column(children: [
      Card(
          elevation: 2,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(player.avatar),
                radius: 50,
              ),
              new Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: new Text(player.displayName))
                  ],
                ),
              )
            ],
          ))
    ]);
  }

  Widget _buildList(BuildContext context, LobbyViewModel viewModel) {
    return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: viewModel.players != null
            ? viewModel.players
                .map((data) => _buildListItem(context, data))
                .toList()
            : [
                Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  ),
                )
              ]);
  }

  Widget _buildListItem(BuildContext context, Player data) {
    return Padding(
      key: ValueKey(data.documentId),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(data.displayName),
            trailing: Text(data.avatar),
            onTap: () => {}
            //     FirebaseFirestore.instance.runTransaction((transaction) async {
            //   final freshSnapshot = await transaction.get(record.reference);
            //   final fresh = Record.fromSnapshot(freshSnapshot);

            //   transaction.update(record.reference, {'votes': fresh.avatar});
            // }),
            ),
      ),
    );
  }
}

class Record {
  final String displayName;
  final String avatar;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['displayName'] != null),
        assert(map['avatar'] != null),
        displayName = map['displayName'],
        avatar = map['avatar'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$displayName:$avatar>";
}
