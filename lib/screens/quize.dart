import 'package:covid_19_statistique/providers/symptoms_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../config/palette.dart';
import '../config/styles.dart';
import '../localization/demo_localizations.dart';
import '../widgets/custom_app_bar.dart';

class Quize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final lang = DemoLocalizations.of(context).getTraslat;
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: FutureBuilder(
        future:
            Provider.of<Symptoms>(context, listen: false).loadSymptomsData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Consumer<Symptoms>(
            builder: (ctx, symptoms, child) {
              final listsymptomsData = symptoms.getSymptomsData;
              return SingleChildScrollView(
                child: !symptoms.getIsIGetIt
                    ? introTestPastor(widthScreen, lang, symptoms)
                    : QuizStart(
                        symptomsData: listsymptomsData[symptoms.getIndex],
                        widthScreen: widthScreen,
                        index: symptoms.getIndex,
                        lengthSymptoms: listsymptomsData.length,
                        symptoms: symptoms,
                      ),
              );
            },
          );
        },
      ),
    );
  }

  Column introTestPastor(
      double widthScreen, String lang(String key), Symptoms symptoms) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          overflow: Overflow.visible,
          children: [
            Container(
              height: widthScreen / 2,
              width: widthScreen,
              color: Palette.primaryColor,
              child: ClipImage(widthScreen: widthScreen),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              child: Text(
                lang('pastor_title'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          width: widthScreen * 0.9,
          child: Text(
            lang('pastor_discription'),
            style: const TextStyle(
              fontSize: 17.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 50),
          child: FlatButton.icon(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            onPressed: () {
              symptoms.setIsGetIt = true;
            },
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            icon: const Icon(
              Icons.done,
              color: Colors.white,
            ),
            label: Text(
              lang('i_get_it'),
              style: Styles.buttonTextStyle,
            ),
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class QuizStart extends StatelessWidget {
  final SymptomsData symptomsData;
  final double widthScreen;
  final int index;
  final int lengthSymptoms;
  final Symptoms symptoms;

  const QuizStart({
    this.symptomsData,
    this.widthScreen,
    this.index,
    this.lengthSymptoms,
    this.symptoms,
  });
  @override
  Widget build(BuildContext context) {
    final lang = DemoLocalizations.of(context).getTraslat;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: StepProgressIndicator(
            totalSteps: lengthSymptoms,
            currentStep: index + 1,
            padding: 3.0,
            size: 12,
            selectedColor: Colors.green,
            unselectedColor: Colors.black12,
          ),
        ),
        Container(
          width: widthScreen - 20,
          margin: const EdgeInsets.all(10),
          child: Card(
            elevation: 3,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    lang(symptomsData.questionCode),
                  ),
                ),
                if (symptomsData.subMsg.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.all(10.0),
                    elevation: 3,
                    color: Colors.blueGrey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        lang(symptomsData.subMsg),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Wrap(
          children: symptomsData.listButton.map((btn) {
            return Container(
              margin: EdgeInsets.all(5),
              child: FlatButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () => nextstep(btn: btn, symptoms: symptoms),
                child: Container(
                  constraints: BoxConstraints(minWidth: 50, maxWidth: 130),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  child: Text(
                    lang(btn.buttonText),
                    maxLines: 3,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

void nextstep({ListButton btn, Symptoms symptoms}) {
  if (symptoms.getIndex < 20) {
    symptoms.setIndex(isPass: false);
  }
}

class ClipImage extends StatelessWidget {
  const ClipImage({
    Key key,
    @required this.widthScreen,
  }) : super(key: key);

  final double widthScreen;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
      child: Container(
        height: (widthScreen / 2),
        width: widthScreen,
        child: Image(
          image: AssetImage('assets/images/pasteur.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
