import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/viewmodels/game_viewmodel.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jibe/widgets/score_gridview.dart';

class JibeGame extends StatefulWidget {
  final String gameId;

  const JibeGame({Key key, this.gameId}) : super(key: key);

  @override
  _JibeGameState createState() {
    return _JibeGameState();
  }
}

class _JibeGameState extends State<JibeGame> {
  final _formKey = GlobalKey<FormBuilderState>();
  final cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<GameViewModel>(onModelReady: (model) {
      model.gameId = widget.gameId;
      model.listenToGame();
      model.listenForPlayers();
      model.roundStatus().listen((event) {
        if (event == RoundStatus.Started) {
          if (!cardKey.currentState.isFront) {
            cardKey.currentState.toggleCard();
          }
        } else {
          if (cardKey.currentState.isFront) {
            cardKey.currentState.toggleCard();
          }
        }
      });
    }, onModelDone: (model) {
      model.unlisten();
    }, builder: (context, model, build) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(
                  child: Text(
                      'jibe [${widget.gameId}] ${model.currentRound?.status}'))),
          body: _buildBody(context, model),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context, GameViewModel viewModel) {
    return FlipCard(
        key: cardKey,
        direction: FlipDirection.HORIZONTAL,
        flipOnTouch: false,
        front: _cardFront(context, viewModel),
        back: ScoreGridView(
            playerViewModel: viewModel, gameViewModel: viewModel));
  }

  Widget _cardFront(BuildContext context, GameViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 20),
              height: 70,
              child: _playerListView(context, viewModel)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Center(
                      child: AutoSizeText(
                "Round ${viewModel.game?.currentRound ?? 1} word",
                maxLines: 1,
                style: TextStyle(fontSize: 24),
              ))),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.black26],
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/chalkboard3.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Center(
                          child: AutoSizeText(
                        "${viewModel.currentRound?.word}____" ?? "",
                        maxLines: 1,
                        style: GoogleFonts.gochiHand(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 64),
                      )),
                    )),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: RoundedButtonWithIcon(
                icon: FontAwesomeIcons.chalkboardTeacher,
                title: viewModel.canSubmit
                    ? "Submit My Answer".padLeft(40)
                    : "Submitted".padLeft(40),
                buttonColor:
                    viewModel.canSubmit ? Colors.grey[900] : Colors.grey[500],
                onPressed: () {
                  viewModel.canSubmit
                      ? showDialog(
                          useSafeArea: true,
                          child: new Dialog(
                              clipBehavior: Clip.hardEdge,
                              child: _gameIdForm(context, viewModel)),
                          context: context)
                      : {};
                },
              ))
        ],
      ),
    );
  }

  Widget _playerListView(BuildContext context, GameViewModel viewModel) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: viewModel.players != null && viewModel.players.length > 0
            ? List.generate(viewModel.players.length, (index) {
                return getPlayerListItem(
                    viewModel.players[index], viewModel.turns, index);
              })
            : [Container(width: 45, child: CircularProgressIndicator())]);
  }

  Container getPlayerListItem(Player player, List<Turn> turns, int index) {
    Color statusColor(Player player, List<Turn> turns) {
      if (turns != null && player != null) {
        var turn = turns.firstWhere((t) => t.playerId == player.userId,
            orElse: () => null);

        return turn == null ? Colors.white : Colors.purple[900];
      } else {
        return Colors.grey[100];
      }
    }

    return Container(
      width: 45.0,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          AvatarGlow(
            glowColor: statusColor(player, turns),
            endRadius: 25,
            duration: Duration(milliseconds: 1000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            child: Material(
              elevation: 8.0,
              shape: CircleBorder(side: BorderSide.none),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: player.avatar != null
                    ? NetworkImage(
                        player.avatar,
                      )
                    : null,
                radius: 15.0,
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.all(1),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: new Text(player.score.toString()))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _gameIdForm(BuildContext context, GameViewModel viewModel) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: FormBuilderTextField(
                  name: 'answer',
                  decoration: InputDecoration(
                    labelText: 'Enter you jibe answer',
                  ),
                  // valueTransformer: (text) => num.tryParse(text),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.minLength(context, 1),
                    FormBuilderValidators.maxLength(context, 20)
                  ]),
                  keyboardType: TextInputType.text,
                ),
              )),
          SizedBox(height: 10),
          FloatingIconButton(
            icon: FontAwesomeIcons.handPointRight,
            buttonColor: Colors.grey[900],
            onPressed: () async {
              _formKey.currentState.save();
              if (_formKey.currentState.validate()) {
                await viewModel.takeTurn(_formKey.currentState.value['answer']);
                Navigator.pop(context);
              }
            },
          ),
        ]);
  }
}
