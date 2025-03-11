// lib/blocs/bloc_observer.dart
import 'package:bloc/bloc.dart';
import '../utils/logger.dart';

// This class extends BlocObserver to monitor all BLoC activity
class AppBlocObserver extends BlocObserver {
  
  // Called when any event is added to any BLoC
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // Log the event type and which BLoC it belongs to
    AppLogger.debug('Bloc Event: ${bloc.runtimeType} -> ${event.runtimeType}');
  }

  // Called when any BLoC's state changes
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Log current and next states
    AppLogger.debug('State Change: ${bloc.runtimeType}\n'
        'Current: ${change.currentState}\n'
        'Next: ${change.nextState}');
  }

  // Called during state transitions (between events and states)
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // Log detailed transition information
    AppLogger.debug('Transition: ${bloc.runtimeType}\n'
        'Event: ${transition.event}\n'
        'From: ${transition.currentState}\n'
        'To: ${transition.nextState}');
  }

  // Called when any error occurs in a BLoC
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // Log errors with stack traces for debugging
    AppLogger.error('Bloc Error: ${bloc.runtimeType}', error);
    super.onError(bloc, error, stackTrace);
  }
}