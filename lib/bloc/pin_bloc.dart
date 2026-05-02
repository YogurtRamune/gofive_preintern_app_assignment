import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PinEvent {}

class PinDigitAdded extends PinEvent {
  final int digit;
  PinDigitAdded(this.digit);
}

class PinDigitDeleted extends PinEvent {}

class PinState {
  final List<int> digits;

  const PinState(this.digits);

  double get alpha => digits.length / 6.0;
  int get filledCount => digits.length;
  int get emptyCount => 6 - digits.length;
}

class PinBloc extends Bloc<PinEvent, PinState> {
  PinBloc() : super(PinState(const [])) {
    on<PinDigitAdded>((event, emit) {
      if (state.digits.length < 6) {
        emit(PinState([...state.digits, event.digit]));
      }
    });

    on<PinDigitDeleted>((event, emit) {
      if (state.digits.isNotEmpty) {
        emit(PinState(state.digits.sublist(0, state.digits.length - 1)));
      }
    });
  }
}
