import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/shared/data/app_theme.dart';
import 'package:flutter_preintern_app/shared/data/language_enum.dart';

class LangSelectorSmall extends StatelessWidget {
  final LanguageEnum? lang;
  const LangSelectorSmall({this.lang, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: ListView(
              children: [
                for (var language in LanguageEnum.values)
                  ListTile(
                    title: Text(
                      language.langName,
                    ),
                    leading: Image.asset(
                      language.iconImg,
                      height: 30,
                      width: 30,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          );
        },
        barrierColor: AppTheme.primary.withAlpha(50),
        showDragHandle: true,
      ),
      child: Row(
        crossAxisAlignment: .center,
        mainAxisAlignment: .end,
        children: [
          SizedBox.square(
            dimension: 30,
            child: CircleAvatar(
              foregroundImage: AssetImage(
                lang?.iconImg ?? LanguageEnum.uk.iconImg,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.icon),
        ],
      ),
    );
  }
}
