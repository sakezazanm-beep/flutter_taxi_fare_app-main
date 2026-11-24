import 'package:flutter/material.dart';

import 'taxi_illustration.dart';

class TaxiFareUI extends StatefulWidget {
  const TaxiFareUI({super.key});

  @override
  State<TaxiFareUI> createState() => _TaxiFareUIState();
}

class _TaxiFareUIState extends State<TaxiFareUI> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _waitingController = TextEditingController();
  double? _fare;
  String? _validationBannerMessage;

  @override
  void dispose() {
    _distanceController.dispose();
    _waitingController.dispose();
    super.dispose();
  }

  String? _validateNumber(String? value, {required String label}) {
    final parsed = double.tryParse(value?.trim() ?? '');
    if (parsed == null || !parsed.isFinite) return 'กรุณากรอก$labelเป็นตัวเลข';
    if (parsed < 0) return '$labelต้องไม่น้อยกว่า 0';
    return null;
  }

  double _distanceFare(double distance) {
    if (distance <= 0) return 0;
    var fare = 35.0; // ค่าโดยสารเริ่มต้นรวมกิโลเมตรแรก
    var remaining = distance - 1;
    const bands = <(double, double)>[
      (9, 6.5),
      (10, 7),
      (20, 8),
      (20, 8.5),
      (20, 9),
    ];
    for (final (bandDistance, rate) in bands) {
      final chargedDistance = remaining.clamp(0.0, bandDistance).toDouble();
      fare += chargedDistance * rate;
      remaining -= chargedDistance;
      if (remaining <= 0) return fare;
    }
    fare += remaining * 10.5;
    return fare;
  }

  String _validationMessageForCurrentInput() {
    final missingFields = <String>[];
    if (_distanceController.text.trim().isEmpty) missingFields.add('ระยะทาง');
    if (_waitingController.text.trim().isEmpty) missingFields.add('เวลารถติด');
    if (missingFields.isNotEmpty) {
      return 'กรุณากรอก${missingFields.join('และ')}';
    }

    final invalidFields = <String>[];
    if (_validateNumber(_distanceController.text, label: 'ระยะทาง') != null) {
      invalidFields.add('ระยะทาง');
    }
    if (_validateNumber(_waitingController.text, label: 'เวลารถติด') != null) {
      invalidFields.add('เวลารถติด');
    }
    return 'กรุณาตรวจสอบข้อมูลในช่อง${invalidFields.join('และ')}';
  }

  void _calculateFare() {
    if (!_formKey.currentState!.validate()) {
      setState(
        () => _validationBannerMessage = _validationMessageForCurrentInput(),
      );
      return;
    }

    final distance = double.parse(_distanceController.text.trim());
    final waitingMinutes = double.parse(_waitingController.text.trim());
    setState(() {
      _fare = _distanceFare(distance) + waitingMinutes * 3;
      _validationBannerMessage = null;
    });
  }

  void _handleFieldChanged(String _) {
    if (_validationBannerMessage == null) return;
    setState(() {
      final distanceValid =
          _validateNumber(_distanceController.text, label: 'ระยะทาง') == null;
      final waitingValid =
          _validateNumber(_waitingController.text, label: 'เวลารถติด') == null;
      _validationBannerMessage = distanceValid && waitingValid
          ? null
          : _validationMessageForCurrentInput();
    });
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _distanceController.clear();
    _waitingController.clear();
    setState(() {
      _fare = null;
      _validationBannerMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale = (MediaQuery.sizeOf(context).width / 311)
        .clamp(1.0, 1.25)
        .toDouble();
    return Scaffold(
      bottomNavigationBar: _validationBannerMessage == null
          ? null
          : Container(
              color: const Color(0xFFF44336),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18 * scale,
                    vertical: 9 * scale,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: const Color(0xFFFFD54F),
                        size: 18 * scale,
                      ),
                      SizedBox(width: 7 * scale),
                      Expanded(
                        child: Text(
                          _validationBannerMessage!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12 * scale,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Container(
                  height: 42 * scale,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: const Color(0xFFFFB900),
                  child: Text(
                    'Taxi Fare',
                    style: TextStyle(color: Colors.white, fontSize: 15 * scale),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      31 * scale,
                      24 * scale,
                      31 * scale,
                      24 * scale,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TaxiIllustration(size: 150 * scale),
                          SizedBox(height: 10 * scale),
                          Text(
                            'คำนวณค่าโดยสารแท็กซี่',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19 * scale,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 20 * scale),
                          _NumberField(
                            controller: _distanceController,
                            label: 'ระยะทาง (กิโลเมตร)',
                            icon: Icons.route_rounded,
                            scale: scale,
                            hint: 'กรุณากรอกระยะทาง',
                            validator: (value) =>
                                _validateNumber(value, label: 'ระยะทาง'),
                            onChanged: _handleFieldChanged,
                          ),
                          SizedBox(height: 16 * scale),
                          _NumberField(
                            controller: _waitingController,
                            label: 'เวลารถติด (นาที)',
                            icon: Icons.access_time_filled,
                            scale: scale,
                            hint: 'กรุณากรอกเวลารถติด',
                            validator: (value) =>
                                _validateNumber(value, label: 'เวลารถติด'),
                            onChanged: _handleFieldChanged,
                          ),
                          SizedBox(height: 18 * scale),
                          SizedBox(
                            height: 46 * scale,
                            child: FilledButton(
                              onPressed: _calculateFare,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFFFB900),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    9 * scale,
                                  ),
                                ),
                              ),
                              child: Text(
                                'คำนวณค่าโดยสาร',
                                style: TextStyle(
                                  fontSize: 14 * scale,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 9 * scale),
                          SizedBox(
                            height: 42 * scale,
                            child: FilledButton(
                              onPressed: _clearForm,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.grey.shade500,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    9 * scale,
                                  ),
                                ),
                              ),
                              child: Text(
                                'ยกเลิก',
                                style: TextStyle(fontSize: 14 * scale),
                              ),
                            ),
                          ),
                          SizedBox(height: 12 * scale),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 13 * scale,
                              horizontal: 12 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEDB1),
                              borderRadius: BorderRadius.circular(10 * scale),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'ค่าโดยสารแท็กซี่',
                                  style: TextStyle(fontSize: 13 * scale),
                                ),
                                Text(
                                  _fare == null
                                      ? '0.00'
                                      : _fare!.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 25 * scale,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'บาท',
                                  style: TextStyle(fontSize: 12 * scale),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    required this.validator,
    required this.onChanged,
    required this.scale,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hint;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 25 * scale,
              height: 25 * scale,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0BE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 17 * scale,
                color: const Color(0xFFC58A00),
              ),
            ),
            SizedBox(width: 6 * scale),
            Text(
              label,
              style: TextStyle(
                fontSize: 13 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 6 * scale),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: onChanged,
          style: TextStyle(fontSize: 13 * scale),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFFFFAFF),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12 * scale,
              vertical: 13 * scale,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4 * scale),
            ),
          ),
        ),
      ],
    );
  }
}
