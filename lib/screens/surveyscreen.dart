import 'package:mobi_div/screens/dashboard.dart';
import 'package:mobi_div/models/tracker.dart';
import 'package:mobi_div/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart';
import 'package:survey_kit/survey_kit.dart';
import '../models/surveymodel.dart';
import 'googleMapScreen.dart';

class Survey extends StatefulWidget {
  const Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  bool isFirstTime = false;
  bool? isChecked = false;
  SurveyModel surveyModel = SurveyModel();

  void checkFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedSurvey = prefs.getString('survey_state');

    if (savedSurvey != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('survey_state');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SurveyScreen()));
    }
  }


  @override
  void initState() {
    checkFirstTime();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Text(surveyModel.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),)
                      ),
                      GFAccordion(
                        title: 'Policy Notice',
                        content: surveyModel.policy_notice.trimLeft(),
                        collapsedIcon: Icon(Icons.keyboard_arrow_down_outlined),
                        expandedIcon: Icon(Icons.minimize)
                      ),
                      GFAccordion(
                          title: 'Benefits',
                          content: surveyModel.benefits.trim(),
                          collapsedIcon: Icon(Icons.keyboard_arrow_down_outlined),
                          expandedIcon: Icon(Icons.minimize)
                      ),
                      GFAccordion(
                        title: 'Confidentiality',
                        content: surveyModel.confidentiality.toString().trim(),
                        collapsedIcon: Icon(Icons.keyboard_arrow_down_outlined),
                        expandedIcon: Icon(Icons.minimize)
                      ),
                      SafeArea(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CheckboxListTile(
                                    title: Text(
                                      'I accept the terms and conditions.',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    value: isChecked,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isChecked = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: GFButton(
                                      type: GFButtonType.outline,
                                      onPressed: isChecked == true ? (){
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SurveyScreens()));
                                      } : null,
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width * 0.98,
                                          decoration: BoxDecoration(
                                              boxShadow:[]
                                          ),
                                          child: Text(
                                            "Accept",
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                          )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
          )
        ),
      ],
    );
  }
}

class SurveyScreens extends StatefulWidget {
  const SurveyScreens({super.key});

  @override
  State<SurveyScreens> createState() => _SurveyScreensState();
}

class _SurveyScreensState extends State<SurveyScreens> {
  SurveyModel model = SurveyModel();
  SurveyController surveyController = SurveyController();
  late Future<Task> _task;

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _saveSurveyState(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> steps = task.steps.map((step) => step.toJson()).toList();
    await prefs.setString('survey_state', jsonEncode(steps));
  }

  @override
  void initState() {
    _task = getSampleTask();
    super.initState();
  }

  Future<Task> getSampleTask() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedSurvey = prefs.getString('survey_state');

    if (savedSurvey != null) {
      final List<dynamic> surveySteps = jsonDecode(savedSurvey);
      final List<Step> steps = surveySteps.map((step) => _deserializeStep(step)).toList();
      print("Steps: ${steps}");
      return NavigableTask(id: TaskIdentifier(), steps: steps);
    }

    final NavigableTask task = NavigableTask(
      id: TaskIdentifier(),
      steps: <Step>[
        InstructionStep(
          title: 'Travel Behaviour Survey',
          text: 'Get ready for an experiential learning experience!',
          buttonText: 'Let\'s start.!',
        ),
        QuestionStep(
          title: "Age",
          text: 'How old are you?',
          answerFormat: const IntegerAnswerFormat(
            hint: 'Please enter your age',
          ),
        ),
        QuestionStep(
            title: "Gender",
            text: 'What is your gender?',
            answerFormat: const SingleChoiceAnswerFormat(
                textChoices: <TextChoice>[
                  TextChoice(text: 'Male', value: 'Male'),
                  TextChoice(text: 'Female', value: 'Female'),
                  TextChoice(text: 'Prefer not to say', value: 'Prefer not to say'),
                  TextChoice(text: 'None of the above', value: 'None of the above'),
                  TextChoice(text: 'Self-described gender', value: 'Self-described gender'),
                ]
            )
        ),
        QuestionStep(
          title: "Marital Status",
          text:
          'What is your marital status?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: <TextChoice>[
              TextChoice(text: 'Single', value: 'Single'),
              TextChoice(text: 'Married', value: 'Married'),
            ],
          ),
        ),
        QuestionStep(
          title: "Employment Status",
          text:
          'What is your current employment status?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: <TextChoice>[
              TextChoice(text: 'Full-time worker', value: 'Full-time worker'),
              TextChoice(text: 'Part-time worker', value: 'Part-time worker'),
              TextChoice(text: 'Student', value: 'Student'),
              TextChoice(text: 'Unemployed – seeking work', value: 'Unemployed – seeking work'),
              TextChoice(text: 'Unemployed – Not in the labour force and not seeking employment', value: 'Unemployed – Not in the labour force and not seeking employment'),
            ],
          ),
        ),
        QuestionStep(
          title: "Work/School Postal code",
          text: 'What is the postal code of your workplace/school?',
          answerFormat: const TextAnswerFormat(
            hint: 'Enter your postal code here',
            maxLines: 1,
          ),
        ),
        QuestionStep(
          title: "Level of education",
          text: 'What is your highest level of education?',
          isOptional: false,
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: <TextChoice>[
              TextChoice(text: 'No certificate, diploma, or degree', value: 'No certificate, diploma, or degree'),
              TextChoice(text: 'Secondary (high) school diploma or equivalency certificate', value: 'Secondary (high) school diploma or equivalency certificate'),
              TextChoice(text: 'Some post-secondary education', value: 'Some post-secondary education'),
              TextChoice(text: 'Post-secondary certificate, diploma or degree', value: 'Post-secondary certificate, diploma or degree'),
            ],
          ),
        ),
        QuestionStep(
            title: "Drivers license",
            text: 'Do you have a driver’s license?',
            answerFormat: const BooleanAnswerFormat(
                positiveAnswer: 'Yes',
                negativeAnswer: 'No'
            )
        ),
        QuestionStep(
          title: "Drivers license",
          text: 'How old were you when you first started driving?',
          answerFormat: const IntegerAnswerFormat(
            hint: 'Please enter your age',
          ),
        ),
        QuestionStep(
            title: "Vehicle ownership",
            text: 'Do you own or have regular access to a personal vehicle?',
            answerFormat: const BooleanAnswerFormat(
                positiveAnswer: 'Yes',
                negativeAnswer: 'No'
            )
        ),
        QuestionStep(
            title: "Transit Pass",
            text: 'Do you have a transit pass?',
            answerFormat: const BooleanAnswerFormat(
                positiveAnswer: 'Yes',
                negativeAnswer: 'No'
            )
        ),
        QuestionStep(
            title: "Access to bicycle",
            text: 'Do you own or have access to a bicycle?',
            answerFormat: const BooleanAnswerFormat(
                positiveAnswer: 'Yes',
                negativeAnswer: 'No'
            )
        ),
        QuestionStep(
            title: "Access to E-scooter",
            text: 'Do you own or have access to an e-scooter?',
            answerFormat: const BooleanAnswerFormat(
                positiveAnswer: 'Yes',
                negativeAnswer: 'No'
            )
        ),
        QuestionStep(
            title: "Residence Postal Code",
            text: 'What is the postal code of the primary dwelling where you reside?',
            answerFormat: const TextAnswerFormat(
                hint: 'Please enter your here'
            )
        ),
        QuestionStep(
            title: "Residential Area",
            text: 'How would you characterize your residential area?',
            answerFormat: const SingleChoiceAnswerFormat(
                textChoices: <TextChoice>[
                  TextChoice(text: 'Safe', value: 'Safe'),
                  TextChoice(text: 'Walking friendly', value: 'Walking friendly'),
                  TextChoice(text: 'Cycling friendly', value: 'Cycling friendly'),
                  TextChoice(text: 'Scooter friendly', value: 'Scooter friendly'),
                  TextChoice(text: 'Well serviced by public transit', value: 'Well serviced by public transit'),
                ]
            )
        ),
        QuestionStep(
            title: "Dwelling type",
            text: 'Do you own or rent your dwelling?',
            answerFormat: const BooleanAnswerFormat(
                positiveAnswer: 'Rent',
                negativeAnswer: 'Own')
        ),
        QuestionStep(
            title: "Dwelling type",
            text: 'What type of dwelling do you live in?',
            answerFormat: const SingleChoiceAnswerFormat(
                textChoices: <TextChoice>[
                  TextChoice(text: 'Apartment', value: 'Apartment'),
                  TextChoice(text: 'Condominium', value: 'Condominium'),
                  TextChoice(text: 'Townhouse', value: 'Townhouse'),
                  TextChoice(text: 'Semidetached', value: 'Semidetached'),
                  TextChoice(text: 'Detached', value: 'Detached'),
                  TextChoice(text: 'Others', value: 'Others'),
                ]
            )
        ),
        QuestionStep(
            title: "Household Income",
            text: 'What is your household’s gross annual income range?',
            answerFormat: const SingleChoiceAnswerFormat(
                textChoices: <TextChoice>[
                  TextChoice(text: 'Less than \$55,000', value: 'Less than \$55,000'),
                  TextChoice(text: 'Between  \$55,000 and  \$85,000', value: 'Between  \$55,000 and  \$85,000'),
                  TextChoice(text: 'Between  \$85,000 and  \$125,000', value: 'Between  \$85,000 and  \$125,000'),
                  TextChoice(text: 'Between  \$125,000 and  \$200,000', value: 'Between  \$125,000 and  \$200,000'),
                  TextChoice(text: 'Between  \$200,000 and  \$300,000', value: 'Between  \$200,000 and  \$300,000'),
                  TextChoice(text: 'More than  \$300,000', value: 'More than  \$300,000'),
                ]
            )
        ),
        QuestionStep(
            title: "Number of children in household",
            text: 'How many children do you have in each of the following age categories?',
            answerFormat: const MultipleChoiceAnswerFormat(
                textChoices: <TextChoice>[
                  TextChoice(text: 'Ages from 0 to 3', value: 'Ages from 0 to 3'),
                  TextChoice(text: 'Ages from 4 to 5', value: 'Ages from 4 to 5'),
                  TextChoice(text: 'Ages from 6 to 10', value: 'Ages from 6 to 10'),
                  TextChoice(text: 'Ages from 11 to 14', value: 'Ages from 11 to 14'),
                  TextChoice(text: 'Ages from 15 to 18', value: 'Ages from 15 to 18'),
                  TextChoice(text: 'Ages 18+', value: 'Ages 18+'),
                ]
            )
        ),
        QuestionStep(
            title: "Work from home",
            text: 'In the past 7 days, how frequently were you working from home?',
            answerFormat: const MultipleChoiceAnswerFormat(
                textChoices: <TextChoice>[
                  TextChoice(text: '5 or more days', value: '5 or more days'),
                  TextChoice(text: '4 days', value: '4 days'),
                  TextChoice(text: '3 days', value: '3 days'),
                  TextChoice(text: '2 days', value: '2 days'),
                  TextChoice(text: '1 day', value: '1 day'),
                  TextChoice(text: 'Did not work from home', value: 'Did not work from home'),
                ]
            )
        ),
        QuestionStep(
            title: "Work from home",
            text: 'How would you compare your productivity working from home to working at your workplace?',
            answerFormat: const MultipleChoiceAnswerFormat(
                textChoices: <TextChoice>[
                  TextChoice(text: 'Extremely productive', value: 'Extremely productive'),
                  TextChoice(text: 'Somewhat productive', value: 'Somewhat productive'),
                  TextChoice(text: 'Neither productive nor unproductive', value: 'Neither productive nor unproductive'),
                  TextChoice(text: 'Somewhat unproductive', value: 'Somewhat unproductive'),
                  TextChoice(text: 'Extremely unproductive', value: 'Extremely unproductive'),
                ]
            )
        ),
        QuestionStep(
            title: "Travelling to work",
            text: 'In the past 7 days, how frequently were you traveling to work?',
            answerFormat: const MultipleChoiceAnswerFormat(
                textChoices: <TextChoice>[
                  TextChoice(text: '5 or more days', value: '5 or more days'),
                  TextChoice(text: '4 days', value: '4 days'),
                  TextChoice(text: '3 days', value: '3 days'),
                  TextChoice(text: '2 days', value: '2 days'),
                  TextChoice(text: '1 day', value: '1 day'),
                  TextChoice(text: 'Did not travel to work', value: 'Did not travel to work'),
                ]
            )
        ),

        CompletionStep(
          stepIdentifier: StepIdentifier(id: '321'),
          text: 'Thanks for taking the survey, we will contact you soon!',
          title: 'Done!',
          buttonText: 'Submit survey',
        ),
      ],
    );
    task.addNavigationRule(
      forTriggerStepIdentifier: task.steps[6].stepIdentifier,
      navigationRule: ConditionalNavigationRule(
        resultToStepIdentifierMapper: (String? input) {
          switch (input) {
            case 'Yes':
              return task.steps[0].stepIdentifier;
            case 'No':
              return task.steps[7].stepIdentifier;
            default:
              return null;
          }
        },
      ),
    );
    return Future<Task>.value(task);
  }

  Future<Task> getJsonTask() async {
    final String taskJson =
    await rootBundle.loadString(model.trial.toString());
    final Map<String, dynamic> taskMap = json.decode(taskJson);

    return Task.fromJson(taskMap);
  }

  Step _deserializeStep(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'instruction':
        return InstructionStep.fromJson(json);
      case 'question':
        return QuestionStep.fromJson(json);
      case 'completion':
        return CompletionStep.fromJson(json);
      default:
        throw StepNotDefinedException();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: FutureBuilder<Task>(
              future: _task,
              builder: (BuildContext context, AsyncSnapshot<Task> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  final Task task = snapshot.data!;
                  return SurveyKit(
                      task: task,
                      showProgress: true,
                      onResult: (SurveyResult result){
                        final jsonResult = result.toJson();
                        _saveSurveyState(task);
                        print (result.finishReason);
                        showSnackbar(context, 'Survey completed and saved!');
                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context)=> HomeScreen()));
                      },
                      localizations: const <String, String>{
                        'cancel':'Close',
                        'next':'Next',
                        'previous': 'Back',
                       },
                      surveyProgressbarConfiguration: SurveyProgressConfiguration(
                        backgroundColor: Colors.white,
                        ),
                      );
                }else {
                  print(snapshot);
                  return const CircularProgressIndicator.adaptive();
                }
              },
            ),
          ),
        ) ,
      );
  }


}


class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  late Future<Task> _task;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    prefs = await SharedPreferences.getInstance();
    _task = getSampleTask();
    setState(() {});
  }

  Future<Task> getSampleTask() async {
    final String? savedSurvey = prefs.getString('savedSurvey');
    final String? savedResult = prefs.getString('savedResult');
    final int? savedStepIndex = prefs.getInt('savedStepIndex');

    if (savedSurvey != null) {
      final List<dynamic> surveySteps = jsonDecode(savedSurvey);
      final List<Step> steps = surveySteps.map((step) => _deserializeStep(step)).toList();

      // If we have a saved step index and result, start from that step
      if (savedStepIndex != null && savedResult != null) {
        return NavigableTask(
          id: TaskIdentifier(),
          steps: steps,
        );
      } else {
        return NavigableTask(id: TaskIdentifier(), steps: steps);
      }
    }

    final NavigableTask task = NavigableTask(
      id: TaskIdentifier(),
      steps: <Step>[
        InstructionStep(
          title: 'Travel Behaviour Survey',
          text: 'Get ready for an experiential learning experience!',
          buttonText: 'Let\'s start!',
        ),
        QuestionStep(
          title: "Age",
          text: 'How old are you?',
          answerFormat: const IntegerAnswerFormat(
            hint: 'Please enter your age',
          ),
        ),
        QuestionStep(
          title: "Gender",
          text: 'What is your gender?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: <TextChoice>[
              TextChoice(text: 'Male', value: 'Male'),
              TextChoice(text: 'Female', value: 'Female'),
              TextChoice(text: 'Prefer not to say', value: 'Prefer not to say'),
              TextChoice(text: 'None of the above', value: 'None of the above'),
              TextChoice(text: 'Self-described gender', value: 'Self-described gender'),
            ],
          ),
        ),
        QuestionStep(
          title: "Marital Status",
          text: 'What is your marital status?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: <TextChoice>[
              TextChoice(text: 'Single', value: 'Single'),
              TextChoice(text: 'Married', value: 'Married'),
            ],
          ),
        ),
        // Add more steps as needed
        CompletionStep(
          stepIdentifier: StepIdentifier(id: '321'),
          text: 'Thanks for taking the survey, we will contact you soon!',
          title: 'Done!',
          buttonText: 'Submit survey',
        ),
      ],
    );

    return task;
  }

  Step _deserializeStep(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'instruction':
        return InstructionStep.fromJson(json);
      case 'question':
        return QuestionStep.fromJson(json);
      case 'completion':
        return CompletionStep.fromJson(json);
      default:
        throw StepNotDefinedException();
    }
  }

  void saveSurvey(Task task, int currentStepIndex, SurveyResult result) async {
    final List<Map<String, dynamic>> steps = task.steps.map((step) => step.toJson()).toList();
    prefs.setString('savedSurvey', jsonEncode(steps));
    prefs.setInt('savedStepIndex', currentStepIndex);
    prefs.setString('savedResult', jsonEncode(result.results));
  }

  void clearSavedSurvey() async {
    await prefs.remove('savedSurvey');
    await prefs.remove('savedStepIndex');
    await prefs.remove('savedResult');
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey'),
      ),
      body: FutureBuilder<Task>(
        future: _task,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SurveyKit(
                task: snapshot.data!,
                onResult: (SurveyResult result) {
                  saveSurvey(
                    snapshot.data!,
                    result.finishReason.index,
                    result,
                  );
                  showSnackbar(context, 'Survey saved!');
                  print(result.finishReason);
                },
                showProgress: true,
                localizations: {
                  'cancel': 'Cancel',
                  'next': 'Next',
                  'previous': 'Back',
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class StepNotDefinedException implements Exception {
  @override
  String toString() {
    return 'StepNotDefinedException: The step type is not defined.';
  }
}



