import 'package:flutter/material.dart';

class LogBtn extends StatelessWidget {
  final String btnText;
  final double btnWidth;
  final double btnHeight;
  final double btnFontSize;
  const LogBtn({
    Key? key,
    required this.btnText,
    required this.btnWidth,
    required this.btnHeight,
    required this.btnFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return Container(
      width: btnWidth,
      height: btnHeight,
      // width: width * .5,
      // height: height * .08,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: const DecorationImage(
              image: AssetImage('img/loginbtn.png'), fit: BoxFit.cover)),
      child: Center(
        child: Text(btnText,
            style: TextStyle(
                // fontSize: 36,
                fontSize: btnFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}
