// ignore_for_file: use_setters_to_change_properties

import 'package:pile_of_shame/features/hardware/add_or_edit_hardware/models/editable_hardware.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_hardware_provider.g.dart';

@riverpod
class AddHardware extends _$AddHardware {
  @override
  EditableHardware build([EditableHardware? initialValue]) {
    return initialValue ?? const EditableHardware();
  }

  void updateHardware(EditableHardware update) {
    state = update;
  }
}
