import 'package:flutter/material.dart';
import 'package:view_share/core/theme/app_color.dart';
import 'package:view_share/utils/helpfull_functions.dart';

class TopWidget extends StatelessWidget {
  final double size;
  const TopWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'View',
        style: TextStyle(
            color: Colors.white,
            fontSize: getFontSize(size, getDeviceWidth(context))),
        children: <TextSpan>[
          TextSpan(
              text: 'Share',
              style: TextStyle(
                  color: AppColor.gradient2,
                  fontSize: getFontSize(size, getDeviceWidth(context)),
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
