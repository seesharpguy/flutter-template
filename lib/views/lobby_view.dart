import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/viewmodels/lobby_viewmodel.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:badges/badges.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      model.gameId = widget.gameId;
      model.loadGame();
      model.listenForPlayers();
    }, builder: (context, model, build) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Center(child: Text('Game Lobby'))),
          body: _buildBody(context, model),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context, LobbyViewModel viewModel) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: _gridView(context, viewModel)),
            RoundedButtonWithIcon(
              icon: FontAwesomeIcons.thumbsUp,
              title: "Begin Game".padLeft(45),
              buttonColor: Colors.grey[900],
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Lobby();
                }));
              },
            ),
          ],
        ));
  }

  Widget _gridView(BuildContext context, LobbyViewModel viewModel) {
    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      children: viewModel.players != null && viewModel.players.length > 0
          ? List.generate(viewModel.players.length, (index) {
              return getStructuredGridCell(
                  viewModel.players[index], viewModel.game);
            })
          : [LinearProgressIndicator()],
    );
  }

  Column getStructuredGridCell(Player player, Game game) {
    return new Column(children: [
      Card(
          elevation: 6,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              _header(player, game),
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

  Widget _header(Player player, Game game) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Badge(
        padding: EdgeInsets.all(2),
        badgeColor: Colors.white,
        showBadge: player != null && game != null
            ? player.userId == game.createdBy
            : false,
        badgeContent: Text(
          '🥇',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        child: Text('Player ${player.playerNumber}'),
        position: BadgePosition.bottomEnd(bottom: -2, end: -5),
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
