import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';
import 'surveyMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Questionnaire'),
      ),
      body: SurveyKit(
        onResult: (SurveyResult result) {
          // Handle the results here
          print(result.finishReason.toString());
        },
        task: NavigableTask(
          id: TaskIdentifier(),
          steps: [
            InstructionStep(
              title: 'Welcome to the survey',
              text: 'Tap on start to begin the questionnaire.',
              buttonText: 'Start',
            ),
            // ImageQuestionStep(
            //   title: 'How do you feel about this?',
            //   imagePath: 'assets/images/sample_image.png', // Local asset path
            //   answerFormat: SingleChoiceAnswerFormat(
            //     textChoices: [
            //       TextChoice(text: 'Great', value: 'great'),
            //       TextChoice(text: 'Good', value: 'good'),
            //       TextChoice(text: 'Okay', value: 'okay'),
            //       TextChoice(text: 'Bad', value: 'bad'),
            //     ],
            //   ),
            // ),
            CompletionStep(
              stepIdentifier: StepIdentifier(id: '0001'),
              text: 'Thank you for completing the survey!',
              title: 'Done',
              buttonText: 'Submit',
            ),
          ],
        ),
      ),
    );
  }
}

class ImageQuestionStep extends QuestionStep {
  final String imagePath;

  ImageQuestionStep({
    required String title,
    required this.imagePath,
    required AnswerFormat answerFormat,
  }) : super(
    title: title,
    answerFormat: answerFormat,
  );

  @override
  Widget createView({required QuestionResult? questionResult}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(imagePath), // Use Image.network for network images
        super.createView(questionResult: questionResult),
      ],
    );
  }
}


class AddressSurveyStep extends QuestionStep {
  AddressSurveyStep({
    required String title,
    required String text,
    required String buttonText,
    required AnswerFormat answerFormat
  }) : super(
    title: title,
    text: text,
    buttonText: buttonText,
    answerFormat: answerFormat
  );

  @override
  Widget createWidget(BuildContext context) {
    return AddressSurveyStepWidget(step: this);
  }
}

class AddressSurveyStepWidget extends StatefulWidget {
  final AddressSurveyStep step;

  AddressSurveyStepWidget({required this.step});

  @override
  _AddressSurveyStepWidgetState createState() =>
      _AddressSurveyStepWidgetState();
}

class _AddressSurveyStepWidgetState extends State<AddressSurveyStepWidget> {
  LatLng? _selectedLocation;

  void _selectLocation() async {
    LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen(onLocationSelected: (location) {
        _selectedLocation = location;
      })),
    );
    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.step.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.step.text),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectLocation,
            child: Text('Select Home Address'),
          ),
          if (_selectedLocation != null)
            Text('Selected location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // SurveyKit.of(context)?.answer(
              //   StepResult(
              //     id: widget.step.stepIdentifier,
              //     startDate: DateTime.now(),
              //     endDate: DateTime.now(),
              //     results: _selectedLocation,
              //   ),
              // );
            },
            child: Text(widget.step.buttonText!),
          ),
        ],
      ),
    );
  }
}
