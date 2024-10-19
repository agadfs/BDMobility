import 'package:survey_kit/survey_kit.dart';

const String policy_notice = "Dear Survey Respondents, You are invited to participate in this survey lead by Professors Bilal Farooq, Associate Professor of Civil Engineering at Toronto Metropolitan University and Prof. Zachary Patterson, Professor at Concordia Institute for Information Systems Engineering (CIISE)"
    "This study includes two objectives. First, it investigates how individuals' daily travel have evolved due to the COVID-19. Second, it explores the mobility preferences of future Brightwater residents.""\nThe pandemic has significantly impacted our behaviour, from working-from-home to remote learning. \nWe will collect information regarding respondents' daily behaviour including work-from-home, remote learning, online shopping, transit usage, and socio-demographic characteristics."
    "Respondents will be asked questions regarding their travel behaviour before COVID-19, immediately after the lockdown, and post-pandemic.\nThis study will provide important insights towards how individuals' behaviour have evolved at various stages of the pandemic.";

const String benefits = "The findings will be useful to develop critical travel demand management policies such as work-from-home and remote learning strategies in a post-pandemic world."
    "Various mobility options are being considered for the Brightwater development."
    "There are key mobility goals defined for this project to enable sustainable and convenient travel options. Active mobility, on-demand ride sharing (e.g. Uber) and shuttle buses are a few to mention."
    "The results of this survey will provide insights for the developers to identify the preferences of the future residents and better plan for them."
    "This survey takes about 20 minutes to complete."
    "\n\n\u2713 This online questionnaire is administered by the Toronto Metropolitan University account of Google Forms. Data will be coded and stored in a password-protected server in Canada."
    "\n\u2713 Data will be stored for 5 years to keep historical records, and assess the evolution of behaviour over time."
    "\n\u2713 Data is not linked to the participants' email addresses. This survey does not pose any risk to you other than that is encountered in your everyday life."
    "\n\u2713 All coded data will be securely shared and integrated.";

const String confidentiality= "The confidentiality of the data will be strictly maintained. The survey data will be utilized for research purposes only."
    "Your response is very important, as the quality of the survey depends highly on the response rate and diversity of respondents."
    "However, your participation is voluntary. \nYou can withdraw anytime from the study; except, following the commencement of the data analysis which is expected to start by the Fall of 2022."
    "Some questions in this survey are related to the impact of COVID-19 on respondents' travel behaviour."
    "\n\u2713 If you are not comfortable in answering COVID-19 related questions, you can decide not to participate by closing the survey window or quitting your browser."
    "\n\u2713 If you have any questions, or need further details please contact Professor Bilal Farooq, bilal.farooq@ryerson.ca"
    "\n\u2713 If you have any concerns or complaints about your rights as a research participant, please contact rebchair@ryerson.ca"
    "\n\u2713 Please reference the study number when contacting us so we can better assist you"

    "To download a copy of the consent form, please click on the following link."
    "https://drive.google.com/file/d/14ctw7KUfw3k28QpYDS8F0HrPtU9dcuku/view?usp=sharing";


NavigableTask task_Socio = NavigableTask(
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
      answerFormat: SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '18 – 24', value: '18 – 24'),
          TextChoice(text: '25 – 29', value: '25 – 29'),
          TextChoice(text: '30 – 39', value: '30 – 39'),
          TextChoice(text: '40 – 49', value: '40 – 49'),
          TextChoice(text: '50 – 59', value: '50 – 59'),
          TextChoice(text: '60 – 64', value: '60 – 64'),
          TextChoice(text: '65 – 74', value: '65 – 74'),
          TextChoice(text: '75+', value: '75+'),
        ],
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
            ]
        )
    ),
    QuestionStep(
      title: "Gender",
        text: "Enter gender below",
        answerFormat: TextAnswerFormat(
          hint: "Self-described gender goes here..",
          maxLines: 2

    )),
    QuestionStep(
      title: "Marital Status",
      text:
      'What is your marital status?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Single', value: 'Single'),
          TextChoice(text: 'Married or domestic partnership', value: 'Married or domestic partnership'),
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
        ),

    ),

    QuestionStep(
      title: "Drivers license",
      text: 'How old were you when you first started driving?',
      answerFormat: const IntegerAnswerFormat(
        hint: 'Please enter your age',
      ),
    ),
    QuestionStep(
      title: "Transport accessibility",
      text: 'Do you own or have regular access to a personal vehicle?',
      answerFormat: const BooleanAnswerFormat(
          positiveAnswer: 'Yes',
          negativeAnswer: 'No'
      ),

    ),
    QuestionStep(
      title: "Transport accessibility",
      text: 'Do you have a transit pass?',
      answerFormat: const BooleanAnswerFormat(
          positiveAnswer: 'Yes',
          negativeAnswer: 'No'
      ),

    ),
    QuestionStep(
      title: "Transport accessibility",
      text: 'Do you own or have access to a bicycle?',
      answerFormat: const BooleanAnswerFormat(
          positiveAnswer: 'Yes',
          negativeAnswer: 'No'
      ),

    ),
    QuestionStep(
      title: "Transport accessibility",
      text: 'Do you own or have access to an e-scooter?',
      answerFormat: const BooleanAnswerFormat(
          positiveAnswer: 'Yes',
          negativeAnswer: 'No'
      ),
    ),
    QuestionStep(
      title: "Residence Transport accessibility",
      text: 'What is the postal code of the primary dwelling where you reside?',
      answerFormat: const TextAnswerFormat(
        hint: 'Enter your postal code here',
        maxLines: 1,
      ),
    ),
    InstructionStep(
      title: 'Residence Transport accessibility',
      text: 'Use the following series of questions to characterize your residential area',
      buttonText: 'Let\'s start.!',
    ),
    QuestionStep(
      title: "Safe",
      text: 'How would you characterize your residential area as \'Safe\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Strongly Disagree', value: 'Strongly Disagree'),
          TextChoice(text: 'Disagree', value: 'Disagree'),
          TextChoice(text: 'Neither Agree nor Disagree', value: 'Neither Agree nor Disagree'),
          TextChoice(text: 'Agree', value: 'Agree'),
          TextChoice(text: 'Strongly Agree', value: 'Strongly Agree'),
        ],
      ),
    ),
    QuestionStep(
      title: "Walking Friendly",
      text: 'How would you characterize your residential area as \'Walking Friendly\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Strongly Disagree', value: 'Strongly Disagree'),
          TextChoice(text: 'Disagree', value: 'Disagree'),
          TextChoice(text: 'Neither Agree nor Disagree', value: 'Neither Agree nor Disagree'),
          TextChoice(text: 'Agree', value: 'Agree'),
          TextChoice(text: 'Strongly Agree', value: 'Strongly Agree'),
        ],
      ),
    ),
    QuestionStep(
      title: "Cycling Friendly",
      text: 'How would you characterize your residential area as \'Cycling Friendly\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Strongly Disagree', value: 'Strongly Disagree'),
          TextChoice(text: 'Disagree', value: 'Disagree'),
          TextChoice(text: 'Neither Agree nor Disagree', value: 'Neither Agree nor Disagree'),
          TextChoice(text: 'Agree', value: 'Agree'),
          TextChoice(text: 'Strongly Agree', value: 'Strongly Agree'),
        ],
      ),
    ),
    QuestionStep(
      title: "Scooter Friendly",
      text: 'How would you characterize your residential area as \'Scooter Friendly\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Strongly Disagree', value: 'Strongly Disagree'),
          TextChoice(text: 'Disagree', value: 'Disagree'),
          TextChoice(text: 'Neither Agree nor Disagree', value: 'Neither Agree nor Disagree'),
          TextChoice(text: 'Agree', value: 'Agree'),
          TextChoice(text: 'Strongly Agree', value: 'Strongly Agree'),
        ],
      ),
    ),
    QuestionStep(
      title: "Well Serviced by Public Transit",
      text: 'How would you characterize your residential area as \'Well Serviced by Public Transit\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Strongly Disagree', value: 'Strongly Disagree'),
          TextChoice(text: 'Disagree', value: 'Disagree'),
          TextChoice(text: 'Neither Agree nor Disagree', value: 'Neither Agree nor Disagree'),
          TextChoice(text: 'Agree', value: 'Agree'),
          TextChoice(text: 'Strongly Agree', value: 'Strongly Agree'),
        ],
      ),
    ),
    QuestionStep(
      title: "Dwelling type",
      text: 'Do you own or rent your dwelling?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Own', value: 'Own'),
          TextChoice(text: 'Rent', value: 'Rent'),
        ]
      ),
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
            TextChoice(text: 'Detached ', value: 'Detached'),
            TextChoice(text: 'Others', value: 'Others'),
          ]
      ),
    ),
    InstructionStep(
      title: 'Dwelling occupancy',
      text: 'Use the following series of questions to the ages of children in your dwelling place',
      buttonText: 'Let\'s start.!',
    ),
    QuestionStep(
      title: "Ages from 0 to 3",
      text: 'How many children do you have of the \'Ages from 0 to 3\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3', value: '3'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Ages from 4 to 5",
      text: 'How many children do you have of the \'Ages from 4 to 5\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3', value: '3'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Ages from 6 to 10",
      text: 'How many children do you have of the \'Ages from 6 to 10\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3', value: '3'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Ages from 11 to 14",
      text: 'How many children do you have of the \'Ages from 11 to 14\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3', value: '3'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Ages from 11 to 14",
      text: 'How many children do you have of the \'Ages from 11 to 14\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3', value: '3'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Ages from 15 to 18",
      text: 'How many children do you have of the \'Ages from 15 to 18\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3', value: '3'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Ages 18+",
      text: 'How many children do you have of the \'Ages 18+\'?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3', value: '3'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Dwelling occupancy",
      text: 'How many people regularly live in your household, including yourself?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3', value: '3'),
          TextChoice(text: '4', value: '4'),
          TextChoice(text: '5+', value: '5+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Driver license",
      text: 'How many driver’s license holders are there in the household, including yourself?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Cars in household",
      text: 'How many cars do you have in your household?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Full-time workers in household",
      text: 'How many full-time workers are there in the household, including yourself?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Part-time workers in household",
      text: 'How many part-time workers are there in the household, including yourself?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    QuestionStep(
      title: "Students in household",
      text: 'How many people in your household are working or studying from home, excluding yourself?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '0', value: '0'),
          TextChoice(text: '1', value: '1'),
          TextChoice(text: '2', value: '2'),
          TextChoice(text: '3+', value: '3+'),
        ],
      ),
    ),
    CompletionStep(
      stepIdentifier: StepIdentifier(id: '321'),
      text: 'Thanks for taking the survey, we will contact you soon!',
      title: 'Done!',
      buttonText: 'Submit survey',
    ),
  ],
);

NavigableTask task_Migration = NavigableTask(
  id: TaskIdentifier(),
  steps: <Step>[
    InstructionStep(
      title: 'Migration Level Questionnaires',
      text: 'Get ready for an experiential learning experience!',
      buttonText: 'Let\'s start.!',
    ),
    QuestionStep(
      title: "Country of origin",
      text: 'Where were you born?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Canada', value: 'Canada'),
          TextChoice(text: 'Outside Canada', value: 'Outside Canada'),
        ],
      ),
    ),
    QuestionStep(
      title: "Country of origin",
        text: "State the country of your birth?",
        answerFormat: TextAnswerFormat(
          hint: "Name of country goes here..",
          maxLines: 1

    )),
    QuestionStep(
      title: "Birth country of parents",
      text: 'Are your parents born in Canada?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Yes, both', value: 'Yes, both'),
          TextChoice(text: 'Yes, one of them', value: 'Yes, one of them'),
          TextChoice(text: 'No, both born outside Canada', value: 'No, both born outside Canada'),
        ],
      ),
    ),
    QuestionStep(
        title: "Birth country of parents",
        text: "State the country of birth of your first parent?",
        answerFormat: TextAnswerFormat(
            hint: "Name of country goes here..",
            maxLines: 1

        )),
    QuestionStep(
        title: "Birth country of parents",
        text: "State the country of birth of your second parent?",
        answerFormat: TextAnswerFormat(
            hint: "Name of country goes here..",
            maxLines: 1

        )),
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
      title: "Employment Status",
      text: 'Are you looking for full-time employment?',
      answerFormat: const BooleanAnswerFormat(
          positiveAnswer: 'Yes',
          negativeAnswer: 'No'
      ),
    ),
    QuestionStep(
      title: "Employment Status",
      text: 'How long have you been looking for full-time work?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Less than one month', value: 'Less than one month'),
          TextChoice(text: 'One to three months', value: 'One to three months'),
          TextChoice(text: 'Three to six months', value: 'Three to six months'),
          TextChoice(text: 'More than six months', value: 'More than six months'),
        ],
      ),
    ),
    QuestionStep(
      title: "Income",
      text: 'What is your current income?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Less than \$55,000', value: 'Less than \$55,000'),
          TextChoice(text: 'Between \$55,000 and \$85,000', value: 'Between \$55,000 and \$85,000'),
          TextChoice(text: 'Between \$85,000 and \$125,000', value: 'Between \$85,000 and \$125,000'),
          TextChoice(text: 'Between \$125,000 and \$200,000', value: 'Between \$125,000 and \$200,000'),
          TextChoice(text: 'Between \$200,000 and \$300,000', value: 'Between \$200,000 and \$300,000'),
          TextChoice(text: 'More than \$300,000', value: 'More than \$300,000'),
        ],
      ),
    ),

    QuestionStep(
      title: "Employment status",
      text:
      'How long have you been employed?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Less than a year', value: 'Less than a year'),
          TextChoice(text: 'One year', value: 'One year'),
          TextChoice(text: 'Two years', value: 'Two years'),
          TextChoice(text: 'More than 2 years', value: 'More than 2 years'),
        ],
      ),
    ),
    QuestionStep(
      title: "Language at work",
      text: 'Do you speak any language other than English or French at work?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Yes, always', value: 'Yes, always'),
          TextChoice(text: 'Yes, sometimes', value: 'Yes, sometimes'),
          TextChoice(text: 'Two years', value: 'Two years'),
          TextChoice(text: 'No', value: 'No'),
        ],
      ),
    ),
    QuestionStep(
      title: "Employment related",
      text: 'Are you employed in your area of expertise?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Yes', value: 'Yes'),
          TextChoice(text: 'Yes, partially', value: 'Yes, partially'),
          TextChoice(text: 'No', value: 'No'),
        ],
      ),
    ),
    QuestionStep(
      title: "Employment related",
      text: 'Do you feel secure about your job?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Yes', value: 'Yes'),
          TextChoice(text: 'Yes, somewhat secure', value: 'Yes, somewhat secure'),
          TextChoice(text: 'No', value: 'No'),
        ],
      ),
    ),
    QuestionStep(
      title: "Employment related",
      text: 'Do you have job satisfaction?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Yes', value: 'Yes'),
          TextChoice(text: 'Yes, somehow satisfied', value: 'Yes, somehow satisfied'),
          TextChoice(text: 'No', value: 'No'),
        ],
      ),
    ),
  QuestionStep(
        title: "Employment related",
        text: 'Do you believe there is a wage gap for doing the same job between you and your Canadian born colleagues?',
        answerFormat: const SingleChoiceAnswerFormat(
          textChoices: <TextChoice>[
            TextChoice(text: 'Yes', value: 'Yes'),
            TextChoice(text: 'Yes, but minor gap', value: 'Yes, but minor gap'),
            TextChoice(text: 'No', value: 'No'),
          ],
        ),
      ),
    InstructionStep(title: 'Economic Integration Factors', text: 'Rank the following factors in terms of what you consider the most important factor for achieving economic integration?'),
    QuestionStep(
      title: "Economic Integration Factors",
      text: 'Wage/ Salary',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Economic Integration Factors",
      text: 'Employment status',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Economic Integration Factors",
      text: 'Full time employment in your area of expertise',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Economic Integration Factors",
      text: 'Job security',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Economic Integration Factors",
      text: 'Job satisfaction',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Economic Integration Factors",
      text: 'Wage gaps',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Economic Integration Factors",
      text: 'Working language',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Indicators",
      text: 'How many close friends do you have that you can rely on for support?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'None', value: 'None'),
          TextChoice(text: 'One to two friends', value: 'One to two friends'),
          TextChoice(text: 'Three to four friends', value: 'Three to four friends'),
          TextChoice(text: 'Five or more friends', value: 'Five or more friends'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Indicators",
      text: 'How many of your close friends live in the same city as you?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'None', value: 'None'),
          TextChoice(text: 'One to two friends', value: 'One to two friends'),
          TextChoice(text: 'Three to four friends', value: 'Three to four friends'),
          TextChoice(text: 'Five or more friends', value: 'Five or more friends'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Indicators",
      text: 'How often do you participate in social activities within your community (e.g., clubs, social gatherings, community centers)?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Frequently (weekly or more)', value: 'Frequently (weekly or more)'),
          TextChoice(text: 'Occasionally (monthly)', value: 'Occasionally (monthly)'),
          TextChoice(text: 'Rarely (less than once a month)', value: 'Rarely (less than once a month)'),
          TextChoice(text: 'Never', value: 'Never'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Indicators",
      text: 'Do you feel that you can rely on your local community for support during difficult times?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Yes, very much', value: 'Yes, very much'),
          TextChoice(text: 'Yes, somewhat', value: 'Yes, somewhat'),
          TextChoice(text: 'Not sure', value: 'Not sure'),
          TextChoice(text: 'No, not really', value: 'No, not really'),
          TextChoice(text: 'No, not at all', value: 'No, not at all'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Indicators",
      text: 'How strongly do you feel you belong to your local community?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not at all', value: 'Not at all'),
          TextChoice(text: 'Slightly', value: 'Slightly'),
          TextChoice(text: 'Moderately', value: 'Moderately'),
          TextChoice(text: 'Strongly', value: 'Strongly'),
          TextChoice(text: 'Very strongly', value: 'Very strongly'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Indicators",
      text: 'How strongly do you feel you belong to your province?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not at all', value: 'Not at all'),
          TextChoice(text: 'Slightly', value: 'Slightly'),
          TextChoice(text: 'Moderately', value: 'Moderately'),
          TextChoice(text: 'Strongly', value: 'Strongly'),
          TextChoice(text: 'Very strongly', value: 'Very strongly'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Indicators",
      text: 'How strongly do you feel you belong to Canada?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not at all', value: 'Not at all'),
          TextChoice(text: 'Slightly', value: 'Slightly'),
          TextChoice(text: 'Moderately', value: 'Moderately'),
          TextChoice(text: 'Strongly', value: 'Strongly'),
          TextChoice(text: 'Very strongly', value: 'Very strongly'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Indicators",
      text: 'Have you experienced any sort of discrimination based on your race, ethnicity, religion, or immigration status?',
      answerFormat: const BooleanAnswerFormat(
        positiveAnswer: 'Yes, ',
        negativeAnswer: 'No'
      ),
    ),
    InstructionStep(title: 'Social Integration Indicators', text: 'Rank the following in terms of what you consider the most important or not important to you?'),
    QuestionStep(
      title: "Social Integration Factors",
      text: 'Having close friends in Canada',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Factors",
      text: 'Having close friends in the same city as you?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Factors",
      text: 'Events Community support',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Factors",
      text: 'Events Community support',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Factors",
      text: 'Sense of belonging to the city, province or Canada',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Factors",
      text: 'Freedom from discrimination',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    InstructionStep(title: 'Civic and Democratic Participation Integration', text: 'These questionnaires are based on Civic and Democratic Participation'),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'Have you participated in unpaid volunteer work in the past year?',
      answerFormat: const BooleanAnswerFormat(
          positiveAnswer: 'Yes, ',
          negativeAnswer: 'No'
      ),
    ),
    QuestionStep(
      title: "Social Integration Factors",
      text: 'Are you involved in any community organizations or groups?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Regularly', value: 'Regularly'),
          TextChoice(text: 'Occasionally', value: 'Occasionally'),
          TextChoice(text: 'No', value: 'No'),
        ],
      ),
    ),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'Did you vote in the last provincial election?',
      answerFormat: const BooleanAnswerFormat(
          positiveAnswer: 'Yes, ',
          negativeAnswer: 'No'
      ),
    ),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'Did you vote in the last federal election?',
      answerFormat: const BooleanAnswerFormat(
          positiveAnswer: 'Yes, ',
          negativeAnswer: 'No'
      ),
    ),
    QuestionStep(
      title: "Social Integration Factors",
      text: 'How knowledgeable are you about Canada’s political system (e.g., voting rights, government structure)?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Very knowledgeable', value: 'Very knowledgeable'),
          TextChoice(text: 'Somewhat knowledgeable', value: 'Somewhat knowledgeable'),
          TextChoice(text: 'Neutral', value: 'Neutral'),
          TextChoice(text: 'Not very knowledgeable', value: 'Not very knowledgeable'),
          TextChoice(text: 'Not knowledgeable at all', value: 'Not knowledgeable at all'),
        ],
      ),
    ),
    QuestionStep(
      title: "Social Integration Factors",
      text: 'Apart from voting, have you participated in any other political activities (e.g., attending town hall meetings, signing petitions)?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Yes, frequently', value: 'Yes, frequently'),
          TextChoice(text: 'Yes, occasionally', value: 'Yes, occasionally'),
          TextChoice(text: 'No, never', value: 'No, never'),
        ],
      ),
    ),
    InstructionStep(title: 'Civic and Democratic Participation Integration', text: 'Rank the following in terms of what you consider the most important or not important to you?'),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'Participate in volunteer work',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'Involvement in community organizations',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'Participation in election provincial or federal',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'Awareness of the Canadian political system',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'Participation in political events',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Health Integration Indicators:",
      text: 'Do you have a regular family doctor or general practitioner?',
      answerFormat: const BooleanAnswerFormat(
        positiveAnswer: "Yes",
        negativeAnswer: "No"
      ),
    ),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'How often do you feel stressed in your daily life?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Always', value: 'Always'),
          TextChoice(text: 'Often', value: 'Often'),
          TextChoice(text: 'Sometimes', value: 'Sometimes'),
          TextChoice(text: 'Rarely', value: 'Rarely'),
          TextChoice(text: 'Never', value: 'Never'),
        ],
      ),
    ),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'Have you felt that your health care needs were unmet at any point in the past year?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Yes, frequently', value: 'Yes, frequently'),
          TextChoice(text: 'Yes, sometimes', value: 'Yes, sometimes'),
          TextChoice(text: 'No, never', value: 'No, never'),
        ],
      ),
    ),
    QuestionStep(
      title: "Civic and Democratic Participation Integration",
      text: 'On a scale of 1 to 10, how satisfied are you with your life overall?',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: '1: Not satisfied at all', value: '1: Not satisfied at all'),
          TextChoice(text: '2-3: Somewhat unsatisfied', value: '2-3: Somewhat unsatisfied'),
          TextChoice(text: '4-5: Neutral', value: '4-5: Neutral'),
          TextChoice(text: '6-7: Somewhat satisfied', value: '6-7: Somewhat satisfied'),
          TextChoice(text: '8-9: Very satisfied', value: '8-9: Very satisfied'),
          TextChoice(text: '10: Completely satisfied', value: '10: Completely satisfied'),
        ],
      ),
    ),
    InstructionStep(title: 'Health Integration Indicators', text: 'Rank the following in terms of what you consider the most important or not important to you?'),
    QuestionStep(
      title: "Health Integration Indicators",
      text: 'Registration with a family doctor',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Health Integration Indicators",
      text: 'Living stress free life',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Health Integration Indicators",
      text: 'Meeting all health care needs',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    QuestionStep(
      title: "Health Integration Indicators",
      text: 'Satisfaction with the overall quality of life',
      answerFormat: const SingleChoiceAnswerFormat(
        textChoices: <TextChoice>[
          TextChoice(text: 'Not Important', value: 'Not Important'),
          TextChoice(text: 'Slightly Important', value: 'Slightly Important'),
          TextChoice(text: 'Moderately Important', value: 'Moderately Important'),
          TextChoice(text: 'Important', value: 'Important'),
          TextChoice(text: 'Very Important', value: 'Very Important'),
        ],
      ),
    ),
    CompletionStep(
      stepIdentifier: StepIdentifier(id: '321'),
      text: 'Thanks for taking the survey, we will contact you soon!',
      title: 'Done!',
      buttonText: 'Submit survey',
    ),
  ],
);

final NavigableTask task_residential = NavigableTask(
  id: TaskIdentifier(),
  steps: <Step>[
    InstructionStep(
      title: 'Travel Behaviour Survey',
      text: 'Get ready for an experiential learning experience!',
      buttonText: 'Let\'s start.!',
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

    CompletionStep(
      stepIdentifier: StepIdentifier(id: '321'),
      text: 'Thanks for taking the survey, we will contact you soon!',
      title: 'Done!',
      buttonText: 'Submit survey',
    ),
  ],
);

final NavigableTask task_travel = NavigableTask(
  id: TaskIdentifier(),
  steps: <Step>[
    InstructionStep(
      title: 'Travel Behaviour Survey',
      text: 'Get ready for an experiential learning experience!',
      buttonText: 'Let\'s start.!',
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
