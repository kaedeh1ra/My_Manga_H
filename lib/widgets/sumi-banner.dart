import 'package:flutter/material.dart';
import 'package:my_manga_h/theme.dart';

class SumiStudioBanner extends StatelessWidget {
  const SumiStudioBanner({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: size.width, // Задайте желаемую ширину
        height: size.width * 0.85, // Задайте желаемую высоту
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black), // Черная рамка
          color: Colors.white, // Белый фон
        ),
        child: Stack(
          children: [
            // Основное изображение
            Image.asset(
              'assets/images/i.webp', // Замените на URL вашего основного изображения
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover, // Растягиваем изображение на весь контейнер
            ),

            // Логотип в верхнем левом углу
            Positioned(
              top: 16,
              left: 16,
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 40, // Размер логотипа
                height: 40,
              ),
            ),

            // Кнопка внизу справа
            Positioned(
              bottom: 16,
              right: 16,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ), // Задаем отступы
                child: SizedBox(
                  width: 100,
                  height: 40,
                  child: Material(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      splashColor: AppColors.secondary,
                      onTap: onTap,
                      child: Center(
                        // Используем Center для центрирования текста
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 15, // Задайте желаемый размер шрифта
                            color: AppColors
                                .accent, // Задайте желаемый цвет текста
                            fontWeight: FontWeight
                                .bold, // Задайте желаемую толщину шрифта
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
