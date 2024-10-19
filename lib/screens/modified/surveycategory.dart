import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobi_div/models/surveymodel.dart';
import 'package:mobi_div/screens/modified/faq.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_kit/survey_kit.dart';

import '../../constants/survey_notice.dart';

class SurveyCategory extends StatefulWidget {
  const SurveyCategory({super.key});

  @override
  State<SurveyCategory> createState() => _SurveyCategoryState();
}

class _SurveyCategoryState extends State<SurveyCategory> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SurveyModel surveyModel = new SurveyModel();
  String privacy_notice = SurveyModel().policy_notice;
  List<Panel> panels = [
    Panel("Policy Notice", policy_notice, false),
    Panel("Benefits", benefits, false),
    Panel("Confidentiality", confidentiality, false),
  ];

  Future<void> setBool(bool response) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("survey_states", response);
  }

  void checkFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? savedSurvey = await prefs.getBool('survey_states') ?? true;
    
    if (savedSurvey! == true) {
      _showDialog(context, panels);
    }
    setState(() {});
  }

  void _showDialog(BuildContext context,List<Panel> items) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Policy Agreement', textAlign: TextAlign.center,style: TextStyle(fontSize: 17,color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSans',),),
          content: SafeArea(
            bottom: true,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.65,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:12.0,right:12.0,bottom: 8.0),
                    child: Text(
                      'Welcome again kindly read this carefully',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'NotoSans',
                          fontSize: 14.0),
                    ),
                  ),... items.map((panel)=>ExpansionTile(
                      title: Text(
                        panel.title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      children: [Container(
                          padding: EdgeInsets.all(16.0),
                          color: Color(0xffFAF1E2),
                          child: Text(
                              panel.content,
                              style:
                              TextStyle(color: Colors.black, fontSize: 12)))])).toList(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setBool(false);
                Navigator.of(context).pop();
              },
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                setBool(true);
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget surveyCard(String title, String description){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          width: 1.5,
          style: BorderStyle.solid,
          color: Colors.black54
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontFamily: 'NotoSans', fontWeight: FontWeight.w700),),
                Text(description, style: TextStyle(fontSize: 16, fontFamily: 'NotoSans',))
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        title: Center(child: Text('Survey Categories')),
      ),
      body: ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
              child: Text("Select from the categories below", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200, fontFamily: 'NotoSans'),)),
          GestureDetector(
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => SurveyView(surveyKey: "Socio-Demographics", task: task_Socio)));
            },
              child: surveyCard("Socio-Demographics", "Presents questions on personal information")),
          GestureDetector(
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => SurveyView(surveyKey: "Migration Integration Indicators", task: task_Migration)));
            },
              child: surveyCard("Migration Integration Indicators", "Presents questions on migration integration")),
          GestureDetector(
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context) => SurveyView(surveyKey: "Travel Preferences", task: task_travel)));
              },
              child: surveyCard("Travel Preferences", "Presents questions on travel preferences")),
        ],
      ),
    );
  }
}

class SurveyView extends StatefulWidget {
  final NavigableTask task;
  final String surveyKey;
  const SurveyView({super.key, required this.surveyKey, required this.task});

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late NavigableTask task;
  int _lastQuestionIndex = 0;
  bool workFilled = false;
  String uuid = "";

  @override
  void initState() {
    super.initState();
    task = widget.task;
    
    if(widget.surveyKey == "Socio-Demographics"){
      task.addNavigationRule(
        forTriggerStepIdentifier: task_Socio.steps[8].stepIdentifier,
        navigationRule: ConditionalNavigationRule(
          resultToStepIdentifierMapper: (String? input) {
            switch (input) {
              case 'Yes':
                return task_Socio.steps[9].stepIdentifier;
              case 'No':
                return task_Socio.steps[10].stepIdentifier;
              default:
                return null;
            }
          },
        ),
      );
      task.addNavigationRule(forTriggerStepIdentifier: task_Socio.steps[2].stepIdentifier,
          navigationRule: ConditionalNavigationRule(
              resultToStepIdentifierMapper: (String? input) {
                switch (input) {
                  case 'None of the above':
                    return task_Socio.steps[3].stepIdentifier;
                  default:
                    return task_Socio.steps[4].stepIdentifier;
                }
              },
          ));

      task.addNavigationRule(forTriggerStepIdentifier: task_Socio.steps[5].stepIdentifier,
          navigationRule: ConditionalNavigationRule(
            resultToStepIdentifierMapper: (String? input) {
              switch (input) {
                case 'Unemployed – seeking work':
                  setState(() {
                    workFilled = true;
                  });
                  return task_Socio.steps[7].stepIdentifier;
                case 'Unemployed – Not in the labour force and not seeking employment':
                  setState(() {
                    workFilled = true;
                  });
                  return task_Socio.steps[7].stepIdentifier;
                default:
                  setState(() {
                    workFilled = true;
                  });
                  return task_Socio.steps[6].stepIdentifier;
              }
            },
          ));

    }

    _loadSurveyProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _lastQuestionIndex == 0
            ? SurveyKit(
          task: widget.task,
          onResult: (SurveyResult result) {
            final Map<dynamic, dynamic> surveyResults = {};
            for (var stepResult in result.results) {
              for (QuestionResult<dynamic> questionResult in stepResult.results) {
                surveyResults[questionResult.id] = questionResult.result;
              }
            }
            _submitSurvey(surveyResults);
            _saveSurveyProgress(0); // Reset progress after completion
            Navigator.pop(context); // Go back to home after submission
          },
          showProgress: true, // Display progress
          surveyProgressbarConfiguration: SurveyProgressConfiguration(
            backgroundColor: Colors.amber,
            progressbarColor: Colors.lightBlue ,
            valueProgressbarColor: Colors.white,
          ),
        )
            : CircularProgressIndicator(), // Show loading while fetching user progress
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _loadSurveyProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uuid = prefs.getString("uuid").toString();
    });

    DocumentSnapshot snapshot =
    await _firestore.collection('survey_progress').doc(uuid).get();

    if (snapshot.exists) {
      setState(() {
        _lastQuestionIndex = snapshot['last_question_index'];
      });
    }

    _buildSurvey(widget.task);
  }

  // Save the user's progress to Firestore
  Future<void> _saveSurveyProgress(int questionIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uuid = prefs.getString("uuid").toString();
    });

    await _firestore.collection('survey_progress').doc(uuid).set({
      'last_question_index': questionIndex,
    }, SetOptions(merge: true));
  }

  // Submit the final results to Firestore
  Future<void> _submitSurvey(Map<dynamic, dynamic> results) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uuid = prefs.getString("uuid").toString();
    });

    await _firestore.collection('survey_results').doc(uuid).set({
      'type': widget.surveyKey,
      'results': results,
      'submitted_at': FieldValue.serverTimestamp(),
    });
  }

  // Build the survey
  Task _buildSurvey(NavigableTask nav_task) {
    return task = nav_task;
  }

  }
