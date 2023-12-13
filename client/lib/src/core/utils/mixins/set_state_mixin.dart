import 'package:flutter_bloc/flutter_bloc.dart';

/// Set state mixin that allows to set the state of the bloc.
mixin SetStateMixin<S extends Object> on Emittable<S> {
  /// Set the state of the bloc.
  void setState(S state) => emit(state);
}
