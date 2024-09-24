import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get title => 'Welcome';

  @override
  String get add_a_task => '新增任务';

  @override
  String get completed => '已完成';

  @override
  String get todos => '任务';

  @override
  String get skills => '技能';

  @override
  String get profile => '使用者';

  @override
  String get sign_out => '登出';

  @override
  String get new_skill => '新技能';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant(): super('zh_Hant');

  @override
  String get title => 'Welcome';

  @override
  String get add_a_task => '新增任務';

  @override
  String get completed => '已完成';

  @override
  String get todos => '任務';

  @override
  String get skills => '技能';

  @override
  String get profile => '使用者';

  @override
  String get sign_out => '登出';

  @override
  String get new_skill => '新技能';
}
