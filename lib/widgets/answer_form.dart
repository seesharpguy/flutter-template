import 'package:flutter/material.dart';
import 'package:jibe/viewmodels/game_viewmodel.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnswerForm extends StatelessWidget {
  AnswerForm({this.gameViewModel});
  final GameViewModel gameViewModel;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
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
                await gameViewModel
                    .takeTurn(_formKey.currentState.value['answer']);
                Navigator.pop(context);
              }
            },
          ),
        ]);
  }
}
