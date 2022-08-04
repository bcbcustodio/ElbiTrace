import 'package:flutter/material.dart';

//widget for information on Quarantine Guidelines
class QuarantineGuidelinesData extends StatelessWidget {
  const QuarantineGuidelinesData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;
    final screenHeight = _mediaQueryData.size.height;

    TextStyle title_header =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "What is a Close Contact?",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "Close Contact",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: " means being within "),
                  TextSpan(
                      text: "6 feet",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: " of a person who has COVID-19 for a total of"),
                  TextSpan(
                      text: " 15 minutes ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "or more over a 24-hour period, or having direct exposure to respiratory secretions (e.g., being coughed or sneezed on, sharing a drinking glass or utensils, kissing)")
                ],
              ),
            )),
        SizedBox(height: screenHeight / 16),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "If you are EXPOSED, follow these steps:",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "Step 1:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: " Get Tested",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " - Get tested if you are a close contact. Tell your Barangay Health Emergency Response Team (BHERT) that you are a close contact."),
                  TextSpan(
                      text:
                          "\nYou will be referred to the Temporary Treatment and Monitoring Facility (TTMF) or hospital (if needed)"),
                ],
              ),
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "Step 2:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: " QUARANTINE",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " - Monitor yourself if you show signs of COVID-19. If symptoms appear, as should go into "),
                  TextSpan(
                      text: "ISOLATION",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "Step 3:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: " ISOLATION",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " - separate youself from other people to prevent further spread of COVID. to do this you must:"),
                ],
              ),
            )),
        SizedBox(height: screenHeight / 100),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 25),
              child: RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    wordSpacing: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "A.",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " Continue wearing your face mask to prevent the spread of any virus/disease\n"),
                    TextSpan(
                        text: "B.",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " Disinfect all objects and surfaces that are frequently touched\n"),
                    TextSpan(
                        text: "C.",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " Practice physical distance and stay in your room"),
                  ],
                ),
              ),
            )),
        SizedBox(height: screenHeight / 20),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Isolation Details based on Symptoms:",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "ASYMPTOMATIC",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 100),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 25),
              child: RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    wordSpacing: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "- Isolation Period: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "At least ten (10) days, from the day you received your positive result\n"),
                    TextSpan(
                        text: "- Where to Isolate: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "Home or in a Temporary Treatment and Monitoring Facility (TTMF)\n"),
                    TextSpan(
                        text: "- Clearance: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "If you remain not having any symptoms within ten (10) days from the day you got tested\n"),
                    TextSpan(
                      text: "- Do you need to get re-tested? ",
                    ),
                    TextSpan(
                        text: "No",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "MILD",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 100),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 25),
              child: RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    wordSpacing: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "- Isolation Period: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "At least ten (10) days, from the day you received your positive result\n"),
                    TextSpan(
                        text: "- Where to Isolate: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "Home or in a Temporary Treatment and Monitoring Facility (TTMF)\n"),
                    TextSpan(
                        text: "- Clearance: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "If you remain not having any symptoms and are clinically recovered in the past three (3) days\n"),
                    TextSpan(
                      text: "- Do you need to get re-tested? ",
                    ),
                    TextSpan(
                        text: "No",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "MODERATE, SEVERE, OR CRITICAL",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 100),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 25),
              child: RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    wordSpacing: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "- Isolation Period: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "At least twenty one (21) days, from the first day you experience any symptoms\n"),
                    TextSpan(
                        text: "- Where to Isolate: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "Hospital\n"),
                    TextSpan(
                        text: "- Clearance: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "If you remain not having any symptoms and are clinically recovered in the past three (3) days\n"),
                    TextSpan(
                      text: "- Do you need to get re-tested? ",
                    ),
                    TextSpan(
                        text: "No",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
        SizedBox(height: screenHeight / 20),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "How is Home Quarantine being done?",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 25),
              child: RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    wordSpacing: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "-",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " If you have severe or critical symptoms, you will be referred to a hospital\n"),
                    TextSpan(
                        text: "-",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " If you are "),
                    TextSpan(
                        text: "asymptomatic or with mild/moderate symptoms",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          ", you may isolate yourself at your home or you may go to a Temporary Treatment and Monitoring Facility (TTMF)",
                    ),
                  ],
                ),
              ),
            )),
        SizedBox(height: screenHeight / 20),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "You may only isolate yourself at home if:",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 25),
              child: RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    wordSpacing: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "-",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " You have a separate room with other members of the family\n"),
                    TextSpan(
                        text: "-",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " You have a separate bathroom/comfort room in your room\n"),
                    TextSpan(
                        text: "-",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " You are not living with people who belong to the vulnerable population\n"),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
