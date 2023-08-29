import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  final Widget label;
  final void Function(DateTime value) onChanged;
  final DateTime? value;

  /// Defaults to 100 years ago
  final DateTime? firstDate;

  /// Defaults to 18 years ago
  final DateTime? lastDate;

  /// if [value] is null, this date will be used as the first selection in the
  /// popup. If null, [lastDate] will be used instead.
  final DateTime? suggestedDate;

  final String? Function(String? value)? validator;

  const DateInputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.suggestedDate,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  late TextEditingController _birthDateInput;

  @override
  void initState() {
    super.initState();
    _birthDateInput = TextEditingController();
  }

  @override
  void dispose() {
    _birthDateInput.dispose();
    super.dispose();
  }

  Future<void> _handleOpenDatePicker() async {
    final firstDate = widget.firstDate ??
        DateTime(DateTime.now().year - 100, DateTime.now().month,
            DateTime.now().day);
    final lastDate = widget.lastDate ??
        DateTime(
            DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);

    final result = await showDatePicker(
      context: context,
      initialDate: widget.value ?? widget.suggestedDate ?? lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (result != null) {
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat.yMd();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.value != null) {
        final formattedDate = dateFormatter.format(widget.value!);
        if (_birthDateInput.text != formattedDate) {
          setState(() {
            _birthDateInput.text = formattedDate;
          });
        }
      }
    });

    return TextFormField(
      readOnly: true,
      onTap: _handleOpenDatePicker,
      decoration: InputDecoration(
        label: widget.label,
        suffixIcon: const Icon(Icons.calendar_month),
      ),
      controller: _birthDateInput,
      validator: widget.validator,
    );
  }
}
