import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/utils/util.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:jibe/viewmodels/game_viewmodel.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:jibe/widgets/jibe_game.dart';
import 'package:jibe/widgets/score_grid_form.dart';

class JibeGame extends StatefulWidget {
  final String gameId;

  const JibeGame({Key key, this.gameId}) : super(key: key);

  @override
  _JibeGameState createState() {
    return _JibeGameState();
  }
}

class _JibeGameState extends State<JibeGame> {
  final cardKey = GlobalKey<FlipCardState>();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<GameViewModel>(onModelReady: (model) {
      model.gameId = widget.gameId;
      model.listenToGame();
      model.listenForPlayers();
      model.roundStatus().listen((event) {
        print("round status changed $event");
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
    }, builder: (context, model, build) {
      return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Center(child: Text('jibe game'))),
            body: Stack(children: <Widget>[
              _buildBody(context, model),
              model.state == ViewState.Busy ? Utils.progressBar() : Container()
            ])),
      );
    });
  }

  Widget _buildBody(BuildContext context, GameViewModel viewModel) {
    return FlipCard(
        key: cardKey,
        direction: FlipDirection.HORIZONTAL,
        flipOnTouch: false,
        front: JibeGameView(viewModel: viewModel),
        back: Column(
          children: [
            Center(
                child: AutoSizeText(
              "Round ${viewModel.game?.currentRound} word: ${viewModel.currentRound?.word}____",
              maxLines: 1,
              style: TextStyle(fontSize: 24),
            )),
            FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Expanded(
                  child: ScoreGridForm(
                      playerViewModel: viewModel,
                      gameViewModel: viewModel,
                      turnViewmodel: viewModel,
                      isGameCreator: viewModel.isGameCreator),
                )),
            viewModel.isGameCreator
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedButtonWithIcon(
                        icon: FontAwesomeIcons.calculator,
                        title: "Submit Scores".padLeft(40),
                        buttonColor: Colors.grey[900],
                        onPressed: () async {
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            await viewModel
                                .scoreTurn(_formKey.currentState.value);
                            //Navigator.pop(context);
                          }
                        }),
                  )
                : Container()
          ],
        ));
  }
}
