import 'package:flutter/material.dart';
import 'package:to_do/global_widgets/curved_btn.dart';
import 'package:to_do/util/constants/color_constants.dart';
import 'package:to_do/view/home/home.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "To do App",
              style: TextStyle(
                fontSize: 26,
                fontFamily: "Lato",
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primary,
                // fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 60),
            CurvedBtn(
              btnText: "Get Started",
              bg: ColorConstants.primary,
              txtolor: ColorConstants.white,
              horizontal: 10,
              vertical: 10,
              onClick:
                  () => 
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
