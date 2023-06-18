import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({super.key});

  Widget cornerWidget(Alignment alignment) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.transparent,
        alignment: alignment,
        child: Container(
          height: 68,
          width: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: alignment == Alignment.bottomLeft
                  ? const Radius.circular(15)
                  : Radius.zero,
              topLeft: alignment == Alignment.bottomRight
                  ? const Radius.circular(15)
                  : Radius.zero,
              bottomRight: alignment == Alignment.topLeft
                  ? const Radius.circular(15)
                  : Radius.zero,
              bottomLeft: alignment == Alignment.topRight
                  ? const Radius.circular(15)
                  : Radius.zero,
            ),
            color: const Color(0xFF0C8EC7),
          ),
        ),
      );

  Widget rotatedClipBox(int rotate) => RotatedBox(
        quarterTurns: rotate,
        child: Align(
          alignment: Alignment.topCenter,
          child: ClipPath(
            clipper: MultipleRoundedCurveClipper(),
            child: Container(
              height: 50,
              color: const Color(0xFF0C8EC7),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff195b94),
                      offset: Offset(5, 20),
                    ),
                    BoxShadow(
                      color: Color(0xff195b94),
                      offset: Offset(15, 5),
                    ),
                    BoxShadow(
                      color: Color(0xff195b94),
                      offset: Offset(15, 20),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // minimumSize: MaterialStateProperty.all(
                            //   const Size(120, 150),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F719C),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                //bottom shadow
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 7,
                                  spreadRadius: 7,
                                  offset: Offset(0, 7),
                                ),
                              ],
                            ),
                            width: 200,
                            height: 120,
                            child: const Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'start',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 80,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            height: constraints.maxHeight / 2,
                            // width: double.infinity,
                            color: Colors.transparent,
                            child: Image.asset(
                              "assets/start_screen.png",
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            rotatedClipBox(0),
            rotatedClipBox(1),
            rotatedClipBox(2),
            rotatedClipBox(3),
            cornerWidget(Alignment.topRight),
            cornerWidget(Alignment.bottomRight),
            cornerWidget(Alignment.topLeft),
            cornerWidget(Alignment.bottomLeft),
          ],
        ),
      );
    });
  }
}
