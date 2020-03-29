part of '../field/field_bloc.dart';

/// A `FieldBloc` used for any type, for example `DateTime` or `File`.
class InputFieldBloc<Value, ExtraData> extends SingleFieldBloc<Value, Value,
    InputFieldBlocState<Value, ExtraData>, ExtraData> {
  /// ## InputFieldBloc<Value, ExtraData>
  ///
  /// ### Properties:
  ///
  /// * [name] : It is the string that identifies the fieldBloc,
  /// it is available in [FieldBlocState.name].
  /// * [isRequired] : It is `true`, when the value is `null` it will add
  /// [FieldBlocValidatorsErrors.required].
  /// * [initialValue] : The initial value of the field,
  /// by default is `null`.
  /// * [validators] : List of [Validator]s.
  /// Each time the `value` will change,
  /// if the [FormBloc] that use this [InputFieldBloc] has set
  /// in the `super` constructor `autoValidate = true`,
  /// the `value` is passed to each `validator`,
  /// and if any `validator` returns a `String error`,
  /// it will be added to [InputFieldBlocState.error].
  /// Else if `autoValidate = false`, the value will be checked only
  /// when you call [validate] which is called automatically when call [FormBloc.submit].
  /// * [asyncValidators] : List of [AsyncValidator]s.
  /// it is the same as [validators] but asynchronous.
  /// Very useful for server validation.
  /// * [asyncValidatorDebounceTime] : The debounce time when any `asyncValidator`
  /// must be called, by default is 500 milliseconds.
  /// Very useful for reduce the number of invocations of each `asyncValidator.
  /// For example, used for prevent limit in API calls.
  /// * [suggestions] : This need be a [Suggestions] and will be
  /// added to [InputFieldBlocState.suggestions].
  /// It is used to suggest values, usually from an API,
  /// and any of those suggestions can be used to update
  /// the value using [updateValue].
  /// * [toJson] Transform [value] in a JSON value.
  /// By default returns [value].
  /// This method is called when you use [FormBlocState.toJson]
  /// * [extraData] : It is an object that you can use to add extra data, it will be available in the state [FieldBlocState.extraData].
  InputFieldBloc({
    String name,
    @Deprecated('If you want a field to be required, please use the validator [FieldBlocValidators.required]')
        bool isRequired = false,
    Value initialValue,
    List<Validator<Value>> validators,
    List<AsyncValidator<Value>> asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<Value> suggestions,
    dynamic Function(Value value) toJson,
    ExtraData extraData,
  })  : assert(asyncValidatorDebounceTime != null),
        super(
          initialValue,
          validators,
          asyncValidators,
          asyncValidatorDebounceTime,
          suggestions,
          name,
          toJson,
          extraData,
          isRequired,
          _requiredInputFieldBloc,
        );

  /// Check if the [value] is not null.
  ///
  /// Returns [FieldBlocValidatorsErrors.requiredInputFieldBloc].
  static String _requiredInputFieldBloc(dynamic value) {
    if (value != null) {
      return null;
    }
    return FieldBlocValidatorsErrors.required;
  }

  @override
  InputFieldBlocState<Value, ExtraData> get initialState => InputFieldBlocState(
        value: _initialValue,
        error: _getInitialStateError,
        isInitial: true,
        suggestions: _suggestions,
        isValidated: _isValidated(_getInitialStateIsValidating),
        isValidating: _getInitialStateIsValidating,
        name: _name,
        toJson: _toJson,
        extraData: _extraData,
      );
}
