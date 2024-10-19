import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

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
            left: 111,
            top: 453,
            child: Container(
              height: 80,
              width: 200,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6.40),
                    decoration: ShapeDecoration(
                      color: Color(0xFF1890FF),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFF1890FF)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 0,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Let’s get started ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 0.09,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 220,
            top: 562,
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
        ],
      ),
    );
  }
}
