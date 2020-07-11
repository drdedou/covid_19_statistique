import 'dart:math' as math;

import 'package:covid_19_statistique/models/featureConst.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../providers/symptoms_data.dart';
import '../models/symptoms_model.dart';
import '../config/palette.dart';
import '../config/styles.dart';
import '../localization/demo_localizations.dart';
import '../widgets/custom_app_bar.dart';

class Quize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final lang = DemoLocalizations.of(context).getTraslat;
    final symptomsModel = SymptomsModel();
    GlobalKey<EnsureVisibleState> ensureKeyButton =
        GlobalKey<EnsureVisibleState>();
    // Future.delayed(
    //     Duration(seconds: 1),
    //     () async => WidgetsBinding.instance.addPostFrameCallback(
    //           (_) async => await ensureKeyButton.currentState.ensureVisible(
    //             duration: const Duration(
    //               milliseconds: 600,
    //             ),
    //           ),
    //         ));
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
                child: symptoms.getMsgShow.isNotEmpty
                    ? ResultMsg(
                        msg: symptoms.getMsgShow,
                        symptoms: symptoms,
                        symptomsModel: symptomsModel)
                    : !symptoms.getIsIGetIt
                        ? introTestPastor(
                            widthScreen,
                            lang,
                            symptoms,
                            ensureKeyButton,
                          )
                        : QuizStart(
                            symptomsData: listsymptomsData[symptoms.getIndex],
                            widthScreen: widthScreen,
                            index: symptoms.getIndex,
                            lengthSymptoms: listsymptomsData.length,
                            symptoms: symptoms,
                            symptomsModel: symptomsModel,
                          ),
              );
            },
          );
        },
      ),
    );
  }

  Column introTestPastor(
    double widthScreen,
    String lang(String key),
    Symptoms symptoms,
    GlobalKey<EnsureVisibleState> ensureKeyButton,
  ) {
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
        StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            Future.delayed(
                Duration(seconds: 0),
                () async => WidgetsBinding.instance.addPostFrameCallback(
                      (_) async =>
                          await ensureKeyButton.currentState.ensureVisible(
                        duration: const Duration(
                          milliseconds: 600,
                        ),
                      ),
                    ));
            return DescribedFeatureOverlay(
              barrierDismissible: false,
              overflowMode: OverflowMode.wrapBackground,
              featureId: iGetIt7,
              tapTarget: const Icon(Icons.done),
              backgroundColor: colorFeature[7],
              contentLocation: ContentLocation.below,
              title: const Text('Find the fastest route'),
              description: const Text(
                  'Get car, walking, cycling, or public transit directions to this place'),
              child: EnsureVisible(
                key: ensureKeyButton,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 100.0),
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
              ),
            );
          },
        ),
      ],
    );
  }
}

class ResultMsg extends StatelessWidget {
  final String msg;
  final Symptoms symptoms;
  final SymptomsModel symptomsModel;

  const ResultMsg({this.msg, this.symptoms, this.symptomsModel});

  @override
  Widget build(BuildContext context) {
    final lang = DemoLocalizations.of(context).getTraslat;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                lang('msg_header'),
                style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            Card(
              elevation: 3,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      lang(msg),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(10.0),
                    elevation: 3,
                    color: Colors.blueGrey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        lang("msg_global"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 50),
              child: FlatButton.icon(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                onPressed: () async {
                  symptomsModel.restart();
                  await symptoms.newStart();
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
        ),
      ),
    );
  }
}

class QuizStart extends StatelessWidget {
  final SymptomsData symptomsData;
  final double widthScreen;
  final int index;
  final int lengthSymptoms;
  final Symptoms symptoms;
  final SymptomsModel symptomsModel;

  const QuizStart({
    this.symptomsData,
    this.widthScreen,
    this.index,
    this.lengthSymptoms,
    this.symptoms,
    this.symptomsModel,
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
                onPressed: () => nextstep(
                    btn: btn, symptoms: symptoms, symptomsModel: symptomsModel),
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

void nextstep(
    {ListButton btn, Symptoms symptoms, SymptomsModel symptomsModel}) {
  if (symptoms.getIndex <= 20) {
    if (btn.counterMinorGravityFactor) {
      symptomsModel.counterMinorGravityFactor++;
    }

    if (btn.prognosticFactors) {
      symptomsModel.prognosticFactors++;
    }

    if (btn.majorGravityFactors) {
      symptomsModel.majorGravityFactors++;
    }

    if (btn.isCough) {
      symptomsModel.isCough = true;
    }

    if (btn.isPains) {
      symptomsModel.isPains = true;
    }

    if (btn.isFever) {
      symptomsModel.isFever = true;
    }

    if (btn.isDiarrhea) {
      symptomsModel.isDiarrhea = true;
    }

    if (btn.isAnosmie) {
      symptomsModel.isAnosmie = true;
    }

    if (btn.weight != 0.0) {
      symptomsModel.weight = btn.weight;
    }

    if (btn.length != 0.0) {
      symptomsModel.length = btn.length;
    }

    if (btn.age.isNotEmpty) {
      switch (btn.age) {
        case "less_15":
          symptomsModel.age = Age.less_15;
          symptoms.setMsgShow("msg_less_15");
          break;
        case "bt_15_50":
          symptomsModel.age = Age.bt_15_50;
          break;
        case "bt_50_65":
          symptomsModel.age = Age.bt_50_65;
          break;
        case "sup_65":
          symptomsModel.age = Age.sup_65;
          break;
      }
    }

    if (btn.pass) {
      symptoms.setIndex(isPass: true);
      return;
    }
    if (symptoms.getIndex < 20) {
      symptoms.setIndex(isPass: false);
    } else if (symptoms.getIndex == 20) {
      symptomsModel.bMI =
          symptomsModel.weight / math.pow(symptomsModel.length, 2);

      getMessage(symptomsModel: symptomsModel, symptoms: symptoms);
    }
  }
}

void getMessage({SymptomsModel symptomsModel, Symptoms symptoms}) {
  if (symptomsModel.age == Age.less_15) {
    symptoms.setMsgShow("msg_less_15");
    return;
  }

  if (symptomsModel.majorGravityFactors >= 1) {
    symptoms.setMsgShow("msg_danger");
    return;
  }

  if (symptomsModel.isFever && symptomsModel.isCough) {
    if (symptomsModel.prognosticFactors == 0) {
      symptoms.setMsgShow("msg_with_0_prognosticFactors");
      return;
    } else if (symptomsModel.prognosticFactors >= 1) {
      if (symptomsModel.counterMinorGravityFactor == 1) {
        symptoms.setMsgShow("msg_with_1_counterMinorGravityFactor");
        return;
      } else if (symptomsModel.counterMinorGravityFactor >= 1) {
        symptoms.setMsgShow("1_counterMinorGravityFactor");
        return;
      }
    }

    if (symptomsModel.isFever ||
        (!symptomsModel.isFever &&
            (symptomsModel.isDiarrhea ||
                (symptomsModel.isCough && symptomsModel.isPains) ||
                (symptomsModel.isCough && symptomsModel.isAnosmie) ||
                (symptomsModel.isPains && symptomsModel.isAnosmie)))) {
      if (symptomsModel.prognosticFactors <= 0) {
        if (symptomsModel.age == Age.bt_15_50) {
          symptoms.setMsgShow("msg_age<50");
          return;
        } else if (symptomsModel.age == Age.bt_50_65 ||
            symptomsModel.age == Age.sup_65) {
          symptoms.setMsgShow("msg_age>50");
          return;
        }
      }

      if (symptomsModel.counterMinorGravityFactor >= 1) {
        symptoms.setMsgShow("msg_>1_minor");
        return;
      }

      if (symptomsModel.prognosticFactors >= 1) {
        if (symptomsModel.counterMinorGravityFactor <= 0) {
          symptoms.setMsgShow("msg_=0_minor");
          return;
        } else if (symptomsModel.counterMinorGravityFactor >= 2) {
          symptoms.setMsgShow("msg_>2_minor");
          return;
        }
      }
    }
  }

  if ((!symptomsModel.isFever) &&
      (symptomsModel.isCough ||
          symptomsModel.isPains ||
          symptomsModel.isAnosmie)) {
    if (symptomsModel.prognosticFactors >= 1) {
      symptoms.setMsgShow("msg_>1_prognosticFactors");
      return;
    } else if (symptomsModel.prognosticFactors <= 0) {
      symptoms.setMsgShow("msg_<=0_prognosticFactors");
      return;
    }
  }

  if ((!symptomsModel.isCough) &&
      (!symptomsModel.isPains) &&
      (!symptomsModel.isFever) &&
      (!symptomsModel.isDiarrhea) &&
      (!symptomsModel.isAnosmie) &&
      (symptomsModel.prognosticFactors == 0)) {
    symptoms.setMsgShow("msg_good");
    return;
  }

  symptoms.setMsgShow("msg_with_1_counterMinorGravityFactor");
  return;
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
