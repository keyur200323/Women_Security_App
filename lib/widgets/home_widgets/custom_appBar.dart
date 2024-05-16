import 'package:flutter/material.dart';
import 'package:security/utils/quotes.dart';


class CustomAppBar extends StatelessWidget {
 // const CustomAppBar({super.key});
  Function? onTap;
  int? quoteIndex;
  CustomAppBar({this.onTap,this.quoteIndex});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
         onTap!();
    },
      child: Text(
          sweetSayings[quoteIndex!],
          style:TextStyle(
          fontSize: 22,
    ),
      ),
    );
  }
}
//inkwell make widgets clickable
//onTap is function
