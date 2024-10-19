class SurveyModel{
    var title = "Travel Behaviour Survey";

    var policy_notice = "Dear Survey Respondents, You are invited to participate in this survey lead by Professor Bilal Farooq—Associate Professor of Civil Engineering at Toronto Metropolitan University."
    "\nThis study includes two objectives. First, it investigates how individuals' daily travel have evolved due to the COVID-19. Second, it explores the mobility preferences of future Brightwater residents.""\nThe pandemic has significantly impacted our behaviour, from working-from-home to remote learning. \nWe will collect information regarding respondents' daily behaviour including work-from-home, remote learning, online shopping, transit usage, and socio-demographic characteristics."
    "Respondents will be asked questions regarding their travel behaviour before COVID-19, immediately after the lockdown, and post-pandemic.\nThis study will provide important insights towards how individuals' behaviour have evolved at various stages of the pandemic.";

    var benefits = "The findings will be useful to develop critical travel demand management policies such as work-from-home and remote learning strategies in a post-pandemic world."
    "Various mobility options are being considered for the Brightwater development."
    "There are key mobility goals defined for this project to enable sustainable and convenient travel options. Active mobility, on-demand ride sharing (e.g. Uber) and shuttle buses are a few to mention."
    "\nThe results of this survey will provide insights for the developers to identify the preferences of the future residents and better plan for them."
    "This survey takes about 20 minutes to complete."
    "\n\n\u2713 This online questionnaire is administered by the Toronto Metropolitan University account of Google Forms. Data will be coded and stored in a password-protected server in Canada."
    "\n\u2713 Data will be stored for 5 years to keep historical records, and assess the evolution of behaviour over time."
    "\n\u2713 Data is not linked to the participants' email addresses. This survey does not pose any risk to you other than that is encountered in your everyday life."
    "\n\u2713 All coded data will be securely shared and integrated.";
    
    var confidentiality= "The confidentiality of the data will be strictly maintained. The survey data will be utilized for research purposes only."
    "\nYour response is very important, as the quality of the survey depends highly on the response rate and diversity of respondents."
    "However, your participation is voluntary. \nYou can withdraw anytime from the study; except, following the commencement of the data analysis which is expected to start by the Fall of 2022."
    "Some questions in this survey are related to the impact of COVID-19 on respondents' travel behaviour."
    "\n\u2713 If you are not comfortable in answering COVID-19 related questions, you can decide not to participate by closing the survey window or quitting your browser."
    "\n\u2713 If you have any questions, or need further details please contact Professor Bilal Farooq, bilal.farooq@ryerson.ca"
    "\n\u2713 If you have any concerns or complaints about your rights as a research participant, please contact rebchair@ryerson.ca"
    "\n\u2713 Please reference the study number when contacting us so we can better assist you"
    
    "\nTo download a copy of the consent form, please click on the following link."
    "https://drive.google.com/file/d/14ctw7KUfw3k28QpYDS8F0HrPtU9dcuku/view?usp=sharing";

    List trial = [
        {
            "id": "123",
            "type": "navigable",
            "rules": [{
                "type": "conditional",
                "triggerStepIdentifier": {
                    "id": "7"
                },
                "values": {
                    "Yes": "2",
                    "No": "8"
                }
            },
                {
                    "type": "direct",
                    "triggerStepIdentifier": {
                        "id": "1"
                    },
                    "destinationStepIdentifier": {
                        "id": "14"
                    }
                },
                {
                    "type": "conditional",
                    "triggerStepIdentifier": {
                        "id": "6"
                    },
                    "values": {
                        "Penicillin": "7",
                        "Penicillin,Latex": "7",
                        "Penicillin,Latex,Pet": "11",
                        "Penicillin,Latex,Pet,Pollen": "11",
                        "Penicillin,Pet": "11",
                        "Penicillin,Pet,Pollen": "11",
                        "Penicillin,Pollen": "7",
                        "Latex": "7",
                        "Latex,Pet": "11",
                        "Latex,Pet,Pollen": "11",
                        "Latex,Pollen": "7",
                        "Pet": "11",
                        "Pet,Pollen": "11",
                        "Pollen": "7"
                    }
                },
                {
                    "type": "direct",
                    "triggerStepIdentifier": {
                        "id": "11"
                    },
                    "destinationStepIdentifier": {
                        "id": "7"
                    }
                }
            ],
            "steps": [{
                "stepIdentifier": {
                    "id": "1"
                },
                "type": "intro",
                "title": "Welcome to the\nQuickBird Studios\nHealth Survey",
                "text": "Get ready for a bunch of super random questions!",
                "buttonText": "Let's go!"
            },
                {
                    "stepIdentifier": {
                        "id": "14"
                    },
                    "type": "question",
                    "isOptional": true,
                    "title": "Before we begin",
                    "text": "In order to provide our services, this app will collect and use your sensitive health data based on your consent.",
                    "answerFormat": {
                        "type": "agreement",
                        "defaultValue": "NEGATIVE",
                        "markdownDescription": "Please read our [Privacy Notice](https://www.healthylongevity.cafe/privacy) carefully to ensure that you understand it fully.",
                        "markdownAgreementText": "By clicking this option you consent to the collection and processing of your personal data according to our [Privacy Notice](https://www.healthylongevity.cafe/privacy)"
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "2"
                    },
                    "type": "question",
                    "title": "How old are you?",
                    "answerFormat": {
                        "type": "integer",
                        "defaultValue": 25,
                        "hint": "Please enter your age"
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "3"
                    },
                    "type": "question",
                    "title": "Medication?",
                    "text": "Are you using any medication",
                    "answerFormat": {
                        "type": "bool",
                        "positiveAnswer": "Yes",
                        "negativeAnswer": "No",
                        "result": "POSITIVE"
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "4"
                    },
                    "type": "question",
                    "title": "Tell us about you",
                    "text": "Tell us about yourself and why you want to improve your health.",
                    "answerFormat": {
                        "type": "text",
                        "maxLines": 5,
                        "validationRegEx": "^(?!\\s*\$).+"
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "5"
                    },
                    "type": "question",
                    "title": "Select your body type",
                    "answerFormat": {
                        "type": "scale",
                        "step": 1,
                        "minimumValue": 1,
                        "maximumValue": 5,
                        "defaultValue": 3,
                        "minimumValueDescription": "1",
                        "maximumValueDescription": "5"
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "6"
                    },
                    "type": "question",
                    "title": "Known allergies",
                    "answerFormat": {
                        "type": "multiple",
                        "textChoices": [{
                            "text": "Penicillin",
                            "value": "Penicillin"
                        },
                            {
                                "text": "Latex",
                                "value": "Latex"
                            },
                            {
                                "text": "Pet",
                                "value": "Pet"
                            },
                            {
                                "text": "Pollen",
                                "value": "Pollen"
                            }
                        ]
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "7"
                    },
                    "type": "question",
                    "title": "Done?",
                    "text": "We are done, do you mind to tell us more about yourself?",
                    "answerFormat": {
                        "type": "single",
                        "textChoices": [{
                            "text": "Yes",
                            "value": "Yes"
                        },
                            {
                                "text": "No",
                                "value": "No"
                            }
                        ]
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "8"
                    },
                    "type": "question",
                    "title": "When did you wake up?",
                    "answerFormat": {
                        "type": "time",
                        "defaultValue": {
                            "hour": 12,
                            "minute": 0
                        }
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "9"
                    },
                    "type": "question",
                    "title": "When was your last holiday?",
                    "answerFormat": {
                        "type": "date",
                        "minDate": "2015-06-25T04:08:16Z",
                        "maxDate": "2025-06-25T04:08:16Z",
                        "defaultDate": "2021-06-25T04:08:16Z"
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "12"
                    },
                    "type": "question",
                    "title": "Known allergies",
                    "answerFormat": {
                        "type": "multiple",
                        "otherField": true,
                        "textChoices": [{
                            "text": "Penicillin",
                            "value": "Penicillin"
                        },
                            {
                                "text": "Latex",
                                "value": "Latex"
                            },
                            {
                                "text": "Pet",
                                "value": "Pet"
                            },
                            {
                                "text": "Pollen",
                                "value": "Pollen"
                            }
                        ]
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "13"
                    },
                    "type": "question",
                    "title": "Medicines",
                    "answerFormat": {
                        "type": "multiple_auto_complete",
                        "otherField": true,
                        "textChoices": [{
                            "text": "Penicillin",
                            "value": "Penicillin"
                        },
                            {
                                "text": "Latex",
                                "value": "Latex"
                            }
                        ],
                        "suggestions": [{
                            "text": "Pet",
                            "value": "Pet"
                        },
                            {
                                "text": "Pollen",
                                "value": "Pollen"
                            }
                        ]
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "10"
                    },
                    "type": "completion",
                    "text": "Thanks for taking the survey, we will contact you soon!",
                    "title": "Done!",
                    "buttonText": "Restart"
                },
                {
                    "stepIdentifier": {
                        "id": "11"
                    },
                    "type": "question",
                    "title": "Pets",
                    "text": "What type of pet(s) do you have?",
                    "answerFormat": {
                        "type": "multiple",
                        "textChoices": [{
                            "text": "Dog",
                            "value": "Dog"
                        },
                            {
                                "text": "Cat",
                                "value": "Cat"
                            },
                            {
                                "text": "Fish",
                                "value": "Fish"
                            },
                            {
                                "text": "Small Animal",
                                "value": "Small Animal"
                            }
                        ]
                    }
                },
                {
                    "stepIdentifier": {
                        "id": "12"
                    },
                    "type": "question",
                    "title": "Upload a selfie",
                    "answerFormat": {
                        "type": "file",
                        "defaultValue": "https://www.maxicolor.com.br/wp-content/uploads/2019/11/placeholder-3x4-450x600.jpg",
                        "buttonText": "Selfie",
                        "useGallery": true,
                        "hintImage": "https://www.maxicolor.com.br/wp-content/uploads/2019/11/placeholder-3x4-450x600.jpg",
                        "hintTitle": "How the image should look"
                    }
                }
            ]
        }
    ];
}

