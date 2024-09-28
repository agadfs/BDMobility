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
    //
    // How old are you?	What is your gender?
    // Self-described gender
    //
    //
    //
    // What is your highest level of education?
    // Do you have a driver‚Äôs license?
    // How old were you when you first started driving?
    // Do you own or have regular access to a personal vehicle?
    // Do you have a transit pass?	Do you own or have access to a bicycle?
    // Do you own or have access to an e-scooter?
    // What is the postal code of the primary dwelling where you reside?
    // How would you characterize your residential area? [Safe]
    // How would you characterize your residential area? [Walking friendly]
    // How would you characterize your residential area? [Cycling friendly]
    // How would you characterize your residential area? [Scooter friendly]
    // How would you characterize your residential area? [Well serviced by public transit]
    // Do you own or rent your dwelling?	What type of dwelling do you live in?
    // What is your household‚Äôs gross annual income range?
    // How many children do you have in each of the following age categories? [Ages from 0 to 3]
    // How many children do you have in each of the following age categories? [Ages from 4 to 5]
    // How many children do you have in each of the following age categories? [Ages from 6 to 10]
    // How many children do you have in each of the following age categories? [Ages from  11 to 14]
    // How many children do you have in each of the following age categories? [Ages from 15 to 18]
    // How many children do you have in each of the following age categories? [Ages 18+]
    // How many people regularly live in your household, including yourself?
    // How many driver‚Äôs license holders are there in the household, including yourself?
    // How many cars do you have in your household?
    // How many full-time workers are there in the household, including yourself?
    // How many part-time workers are there in the household, including yourself?
    // How many people in your household are working or studying from home, excluding yourself?
    // What has been your main activity before, during, and after COVID-19?
    // What was your employment status before COVID-19 (February 2020)? 	Before COVID-19 (February 2020),
    // how frequently did you travel to work?	Before COVID-19 (February 2020),
    // how frequently did you work from home?	In March 2020, immediately after lockdown due to COVID-19,
    // what was your employment status?	In March 2020, immediately after lockdown due to COVID-19,
    // how frequently did you travel to work?	In March 2020, immediately after lockdown due to COVID-19,
    // how frequently did you work from home?	In the past 7 days,
    // how frequently were you working from home?
    // How would you compare your productivity working from home to working at your workplace?
    // In the past 7 days, how frequently were you traveling to work?
    // How was your experience when traveling to work before the pandemic?	How was your experience when traveling to work during the pandemic?
    // After COVID-19 social distancing measures are lifted, would you prefer to work from home, at least some of the time?	After COVID-19 social distancing measures are lifted,
    // how frequently would you prefer to work from home?
    // What do you think the requirements for/obligations to in-person work should be post-pandemic?	What was your status as a student before COVID-19 (February 2020)?	Before COVID-19 (February 2020),
    // how frequently did you travel to school?	Before COVID-19 (February 2020), how frequently did you attend online classes?	In March 2020, immediately after lockdown due to COVID-19,
    // what was your status as a student?	In March 2020, immediately after lockdown due to COVID-19, how frequently did you attend online classes?	Currently, what is your status as a student?
    // In the past 7 days, how frequently were you attending online classes?
    // How would you compare your experience of attending online classes to in-person classes?
    // After COVID-19 social distancing measures are lifted, how often would you attend online classes, assuming that classes are available both in-person and online?
    // What do you think the requirements for/obligations to in-person classes should be post-pandemic?	Before COVID-19 (February 2020), how frequently did you perform the following activities?
    // [In-store purchase of grocery and medical supply]	Before COVID-19 (February 2020), how frequently did you perform the following activities? [In-store purchase of other products (e.g. clothing, household maintenance)]
    // Before COVID-19 (February 2020), how frequently did you perform the following activities?
    // [Dine-in at a restaurant]	Before COVID-19 (February 2020), how frequently did you perform the following activities?
    // [Online order of grocery and medical supply]	Before COVID-19 (February 2020), how frequently did you perform the following activities?
    // [Online order of other products (e.g. clothing, household maintenance)]	Before COVID-19 (February 2020), how frequently did you perform the following activities?
    // [Online order of food from restaurants]	In March 2020, immediately after lock-down due to COVID-19, how frequently did you perform the following activities?
    // [In-store purchase of grocery and medical supply]	In March 2020, immediately after lock-down due to COVID-19, how frequently did you perform the following activities?
    // [In-store purchase of other products (e.g. clothing, household maintenance)]	In March 2020, immediately after lock-down due to COVID-19, how frequently did you perform the following activities?
    // [Dine-in at a restaurant]	In March 2020, immediately after lock-down due to COVID-19, how frequently did you perform the following activities?
    // [Online order of grocery and medical supply]	In March 2020, immediately after lock-down due to COVID-19, how frequently did you perform the following activities?
    // [Online order of other products (e.g. clothing, household maintenance)]	In March 2020, immediately after lock-down due to COVID-19, how frequently did you perform the following activities?
    // [Online order of food from restaurants]	How frequently have you been performing the following activities since Ontario lifted most of the public health measures in March 2022?
    // [In-store purchase of grocery and medical supply]	How frequently have you been performing the following activities since Ontario lifted most of the public health measures in March 2022? [In-store purchase of other products (e.g. clothing, household maintenance)]
    // How frequently have you been performing the following activities since Ontario lifted most of the public health measures in March 2022?
    // [Dine-in at a restaurant]	How frequently have you been performing the following activities since Ontario lifted most of the public health measures in March 2022?
    // [Online order of grocery and medical supply]	How frequently have you been performing the following activities since Ontario lifted most of the public health measures in March 2022?
    // [Online order of other products (e.g. clothing, household maintenance)]	How frequently have you been performing the following activities since Ontario lifted most of the public health measures in March 2022?
    // [Online order of food from restaurants]	After COVID-19 social distancing measures are lifted, how frequently would you perform the following activities?
    // [In-store purchase of grocery and medical supply]	After COVID-19 social distancing measures are lifted, how frequently would you perform the following activities?
    // [In-store purchase of other products (e.g. clothing, household maintenance)]	After COVID-19 social distancing measures are lifted, how frequently would you perform the following activities?
    // [Dine-in at a restaurant]	After COVID-19 social distancing measures are lifted, how frequently would you perform the following activities?
    // [Online order of grocery and medical supply]	After COVID-19 social distancing measures are lifted, how frequently would you perform the following activities?
    // [Online order of other products (e.g. clothing, household maintenance)]	After COVID-19 social distancing measures are lifted, how frequently would you perform the following activities?
    // [Online order of food from restaurants]	How often do you experience the following inconveniences with online shopping?
    // [Delayed delivery]	How often do you experience the following inconveniences with online shopping?
    // [Online order cancelled]	How often do you experience the following inconveniences with online shopping?
    // [Long wait at online order pickup areas]	How often do you experience the following inconveniences with online shopping?
    // [Website difficult to navigate]	How often do you experience the following inconveniences with online shopping?
    // [Poor internet connection]	What was your preferred mode of travel before the COVID-19 lockdown (March 2020)?
    // How often did you ride public transport before the Covid-19 lockdown (March 2020)?
    // How often do you use public transport after the COVID-19 lockdown?
    // Has the COVID-19 pandemic changed your likelihood of using public transport?
    // Answer assuming you are in a time when the pandemic is over and/or there is low risk of contracting COVID-19 in the general population.
    // How do you feel about the way other people ride public transport? Please select all that apply. 	How safe do you feel using public transport after the COVID-19 lockdown?
    // Are you encouraged by your friends and family to use public transport after the COVID-19 lockdown?	Immediately after lockdown due to COVID-19 in March 2020, did the number of cars in your household change?
    // After COVID-19 social distancing measures were lifted,  did you (or do you plan to) change the number of cars in your household?	What is your current main activity?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?
    // If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?
    // If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?
    // Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank.
    // [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank.
    // [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank.
    // [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use?
    // If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?
    // If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?
    // If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?
    // If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?
    // If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?
    // Under the following conditions, would you consider switching to another mode of transportation?
    // (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 25%]
    // Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions).
    // If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation?
    // (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use?
    // If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?
    // If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?
    // If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank.
    // [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation?
    // (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use? 	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use? 	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use? 	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use? 	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use? 	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use? 	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use? 	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use? 	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is summer and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is clear?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is rainy?	If the following transportation options are available to you, which one would you prefer if it is winter and the weather is snowy?	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 25%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 50%]	Under the following conditions, would you consider switching to another mode of transportation? (if you selected Private car in any of the previous questions). If you did not select Private car in the previous questions, please leave this question blank. [If the price of gasoline increases by 100% or more]	If you selected Yes, meaning you would consider switching to another mode of transportation in the previous question, what mode will you use? 	"Would you be willing to be contacted to participate in our follow-up survey?
    // Contact information you provide and your linked survey responses will only be used to contact you for our future follow-up survey.
    // Your contact information will never be sold or shared with any other agency, or used for any other purpose other than to invite you to participate in our research in the future.
    // If you have any questions, please contact Professor Bilal Farooq at bilal.farooq@ryerson.ca."	Please enter your email address you can be contacted at:

}

