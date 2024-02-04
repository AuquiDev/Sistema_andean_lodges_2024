import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class FechaCalendar {
  List<DateTime?> _selectedDates = [];
  late TextEditingController _fechaVencimientoController;
  late Function(VoidCallback) _setStateCallback;

  FechaCalendar(TextEditingController fechaVencimientoController,
      Function(VoidCallback) setStateCallback) {
        
    _fechaVencimientoController = fechaVencimientoController;
    _setStateCallback = setStateCallback;
  }

  Future<void> pickDate(BuildContext context) async {
    final List<DateTime?>? pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(375, 400),
      value: _selectedDates,
    );

    if (pickedDates != null && pickedDates.isNotEmpty) {
      _setStateCallback(() {
        _selectedDates = pickedDates;
        _fechaVencimientoController.text = _formatDateRange(pickedDates);
      });
    }
  }

  String _formatDateRange(List<DateTime?> dates) {
    if (dates.length == 1) {
      return _formatDate(dates[0]);
    } else if (dates.length == 2) {
      return '${_formatDate(dates[0])} - ${_formatDate(dates[1])}';
    }
    return '';
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return '${date.day}/${date.month}/${date.year}';
    }
    return '';
  }
}


class DatePickerHelper {
  late List<DateTime?> _selectedDates;
  late TextEditingController _fechaVencimientoController;
  late Function(VoidCallback) _setStateCallback;

  DatePickerHelper(
    TextEditingController fechaVencimientoController,
    Function(VoidCallback) setStateCallback,
  ) {
    _selectedDates = [];
    _fechaVencimientoController = fechaVencimientoController;
    _setStateCallback = setStateCallback;
  }

  Future<void> pickDate(BuildContext context) async {
    final List<DateTime?>? pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
      ),
      dialogSize: const Size(375, 400),
      value: _selectedDates,
    );

    if (pickedDates != null && pickedDates.isNotEmpty) {
      _setStateCallback(() {
        _selectedDates = pickedDates;
        _fechaVencimientoController.text = _formatDate(pickedDates[0]);
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return '${date.day}/${date.month}/${date.year}';
    }
    return '';
  }
}

