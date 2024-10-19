import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 844,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFF5F5F5), Color(0xFFA5D0F3)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 114,
            top: 154,
            child: Container(
              width: 163,
              height: 162,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 123,
                    child: SizedBox(
                      width: 163,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'BDMobility',
                              style: TextStyle(
                                color: Color(0xFF0557F9),
                                fontSize: 32,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: Color(0xFF0557F9),
                                fontSize: 5,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 87.42,
                    top: 0,
                    child: Container(
                      width: 35.33,
                      height: 20.01,
                      child: Stack(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 53,
            top: 348,
            child: Text(
              'Efficient travel survey app to best meet \nyour needs ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.w400,
                height: 0.09,
              ),
            ),
          ),
          Positioned(
            left: 220,
            top: 682,
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Take me to sign in ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0557F9),
                      fontSize: 14,
                      fontFamily: 'Helvetica Neue',
                      fontWeight: FontWeight.w400,
                      height: 0.12,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            ),
          ),
          Positioned(
            left: 43,
            top: 505,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: ShapeDecoration(
                      color: Color(0xFF0557F9),
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const SizedBox(width: 5),
                  Text(
                    'Gather insights on your travel habits ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Helvetica Neue',
                      fontWeight: FontWeight.w400,
                      height: 0.17,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 43,
            top: 589,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: ShapeDecoration(
                      color: Color(0xFF0557F9),
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const SizedBox(width: 5),
                  Text(
                    'Review your trips and make necessary edits ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Helvetica Neue',
                      fontWeight: FontWeight.w400,
                      height: 0.17,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 43,
            top: 561,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: ShapeDecoration(
                      color: Color(0xFF0557F9),
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const SizedBox(width: 5),
                  Text(
                    'Receive real-time updates  ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Helvetica Neue',
                      fontWeight: FontWeight.w400,
                      height: 0.17,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 43,
            top: 533,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: ShapeDecoration(
                      color: Color(0xFF0557F9),
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const SizedBox(width: 5),
                  Text(
                    'Quickly share your experiences  ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Helvetica Neue',
                      fontWeight: FontWeight.w400,
                      height: 0.17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
