import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    required this.onTap,
    required this.buttonText,
    this.sizeHeight,
    required this.sizeWidth,
    this.buttonColor,
    this.borderRadius,
    this.textColor,
    this.borderColor,
    this.icon,
    this.iconColor,
    this.isIcon = false,
    this.fontFamily,
    this.buttontextsize,
    this.buttontextweight,
    this.buttonborderwidth,
    super.key,
  });

  VoidCallback onTap;
  Color? buttonColor;
  double? borderRadius;
  Color? textColor;
  String buttonText;
  Color? borderColor;
  IconData? icon;
  bool? isIcon;
  Color? iconColor;
  double? sizeHeight;
  double sizeWidth;
  String? fontFamily;
  double? buttontextsize;
  FontWeight? buttontextweight;
  double? buttonborderwidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHeight ?? 55,
      width: sizeWidth,
      decoration: BoxDecoration(
        color: buttonColor ?? Colors.black,
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        border: Border.all(
            color: borderColor ?? Colors.transparent,
            //strokeAlign: borderstroke ?? 1,
            width: buttonborderwidth ?? 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            //  padding: const EdgeInsets.all(10),
            child: Center(
              child: isIcon == false
                  ? Text(
                      buttonText,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: textColor ?? Colors.white,
                          fontSize: buttontextsize ?? 14,
                          fontWeight: buttontextweight ?? FontWeight.normal),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: iconColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          buttonText,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: textColor ?? Colors.white,
                              fontSize: buttontextsize ?? 14,
                              fontWeight:
                                  buttontextweight ?? FontWeight.normal),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
