import 'package:flutter/material.dart';
import '../theme.dart';

class Buttondef extends StatelessWidget {
  const Buttondef({
    super.key,
    this.icon = Icons.image_search_outlined,
    required this.onTap,
    this.width = 200,
    this.height = 60,
    this.isTextInside = false,
    this.text = '',
    this.rounded = 12,
    this.textSize = 15,
  });
  final int textSize;
  final bool isTextInside;
  final int rounded;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 10), // Задаем отступы
      child: SizedBox(
        width: size.width,
        height: height,
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(rounded.toDouble()),
          child: InkWell(
            borderRadius: BorderRadius.circular(rounded.toDouble()),
            splashColor: AppColors.secondary,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: isTextInside
                  ? Text(
                      text,
                      textAlign: TextAlign.center,

                      /// Поменяй размер текста если необходимо.
                      /// Если надо изменить шрифт TextStyle меняешь на GoogleFonts.'название шрифта'(все аргументы)
                      style: TextStyle(
                        fontSize: textSize.toDouble(),
                        color: AppColors.accent,
                      ),
                    )
                  : Icon(
                      icon,
                      size: 50,
                      color: AppColors.accent,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
