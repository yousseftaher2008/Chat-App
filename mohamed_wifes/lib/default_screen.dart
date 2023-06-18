import 'package:flutter/material.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              color: const Color(0xFF0C8EC7),
            ),
            Center(
              child: Container(
                height: constraints.maxHeight - (constraints.maxHeight / 7),
                width: constraints.maxWidth - (constraints.maxWidth / 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: const Color(0xFFFFFFFF),
                  // border: Border.all(
                  //   color: const Color(0xff0c8ec7),
                  //   width: 30,
                  // ),
                  boxShadow: const [
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
                            // alignment: Alignment.bottomCenter,
                            child: const Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'ابدأ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 80,
                                ),
                                // textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            height: constraints.maxHeight / 2,
                            // width: double.infinity,
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
          ],
        ),
      );
    });
  }
}
