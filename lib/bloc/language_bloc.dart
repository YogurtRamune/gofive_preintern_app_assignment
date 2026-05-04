import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preintern_app/core/enum/language_enum.dart';

sealed class LanguageEvent {
  const LanguageEvent();
}
class LanguageChange extends LanguageEvent {
  final LanguageEnum language;
  const LanguageChange(this.language);
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageEnum> {
  LanguageBloc(super.initialState) {
    on<LanguageChange>((event, emit) => emit(event.language));
  }
}