enum LanguageEnum {
  uk(iconImg: 'asset/img/icon/lang/uk.png', langName: "English (UK)"),
  th(iconImg: 'asset/img/icon/lang/th.png', langName: "Thai");

  const LanguageEnum({String? iconImg, required this.langName}) : _iconImg = iconImg;

  final String? _iconImg;
  final String langName;

  String get iconImg => _iconImg ?? LanguageEnum.uk.iconImg;
}
