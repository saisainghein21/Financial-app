// import 'package:flutter/material.dart';
//
// class PlusButton extends StatelessWidget {
//   final function;
//
//   PlusButton({this.function});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: function,
//       child: Container(
//         height: 75,
//         width: 75,
//         decoration: BoxDecoration(
//           color: Colors.deepPurpleAccent,
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: Text(
//             '+',
//             style: TextStyle(color: Color(0xFF0FF8FF), fontSize: 40),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final function;

  PlusButton({this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(


        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: Color(0xFFeaddff),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }
}
