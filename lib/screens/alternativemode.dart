import 'package:flutter/material.dart';

class AlternativeMode extends StatefulWidget {
  const AlternativeMode({super.key});

  @override
  State<AlternativeMode> createState() => _AlternativeModeState();
}

class _AlternativeModeState extends State<AlternativeMode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Recorded Trips"),
                  Text("Reviewed Reviewed"),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 18,
                  height: MediaQuery.of(context).size.height * 0.25 ,
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0,),
                          child: Text("Detected Details"),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text("Price"),
                              ),
                            ),
                            Column(
                              children: [
                                Text('Detected trip Details'),
                                Text('Travel Mode: '),
                                Text('Travel Distance: '),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ),
                ),
              ),
            ],
          ),
        ),),
    );
  }
}
