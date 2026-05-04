
enum LanguageEnum {

  // Changing the app language won't change language's name (if the app is currently in english then th.langName stills says "ภาษาไทย")
  uk(iconImg: 'asset/img/icon/lang/uk.png', langName: "English (UK)"),
  th(iconImg: 'asset/img/icon/lang/th.png', langName: "ภาษาไทย");

  const LanguageEnum({String? iconImg, required this.langName}) : _iconImg = iconImg;

  final String? _iconImg;
  final String langName;

  String get iconImg => _iconImg ?? LanguageEnum.uk.iconImg;
}
