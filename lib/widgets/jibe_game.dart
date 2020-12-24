import 'package:flutter/material.dart';
import 'package:jibe/viewmodels/game_viewmodel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jibe/widgets/answer_form.dart';
import 'package:jibe/widgets/player_listview.dart';

class JibeGameView extends StatelessWidget {
  JibeGameView({
    this.viewModel,
  });
  final GameViewModel viewModel;
  final chalkboard = const AssetImage('assets/chalkboard2.png');
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/chalkboard2.png"), context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 20),
              height: 75,
              child: PlayerListView(viewModel: viewModel)),
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
                      image: DecorationImage(
                        image: chalkboard,
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Center(
                          child: AutoSizeText(
                        "${viewModel.currentRound?.word}____" ?? "",
                        maxLines: 1,
                        style: GoogleFonts.ptSansNarrow(
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
                              child: AnswerForm(gameViewModel: viewModel)),
                          context: context)
                      : {};
                },
              ))
        ],
      ),
    );
  }
}
