import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jan Tchamitchian Garrido',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF39618C)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  int _step = 0; // 0: Personal, 1: Contact, 2: Upload
  Map<String, dynamic> _savedValues = {};

  void _next() {
    // El primer paso no tiene campos, como en el vídeo.
    if (_step == 0) {
      setState(() => _step = 1);
      return;
    }
    if (_step == 1) {
      if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;
      _savedValues = Map<String, dynamic>.from(_formKey.currentState!.value);
      // En el vídeo, Continue envía el formulario y muestra el resumen.
      setState(() => _step = 2);
      _showSubmissionDialog();
    }
  }

  void _cancel() {
    if (_step == 0) return;
    setState(() => _step--);
  }

  Future<void> _showSubmissionDialog() async {
    final email = (_savedValues['email'] ?? '').toString();
    final address = (_savedValues['address'] ?? '').toString();
    final mobile = (_savedValues['mobile'] ?? '').toString();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Color(0xFF39618C)),
        title: const Text('Submission Completed', textAlign: TextAlign.center),
        content: Text('{Email: $email, Address: $address, Mobile: $mobile}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _stepsBar() {
    const names = ['Pers.', 'Contact', 'Upload'];
    const icons = [Icons.looks_one, Icons.edit, Icons.check_circle];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFD8DFEB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          final active = index <= _step;
          return InkWell(
            onTap: () {
              if (index == 0) setState(() => _step = 0);
              if (index == 1 && _step >= 1) setState(() => _step = 1);
              if (index == 2 && _step == 2) _showSubmissionDialog();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icons[index], size: 21,
                    color: active ? const Color(0xFF39618C) : Colors.grey),
                const SizedBox(width: 5),
                Text(names[index],
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          );
        }),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint, IconData icon,
      {bool tall = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9EBDE6)),
      prefixIcon: Icon(icon, color: const Color(0xFF94BDE9), size: 19),
      filled: true,
      fillColor: const Color(0xFFF7F9FF),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: tall ? 17 : 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC0D8FA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF39618C), width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget _contactForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _savedValues,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'email',
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: _fieldDecoration('Email', Icons.email),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Introdueix un email';
              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())) {
                return 'Introdueix un email vàlid';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          FormBuilderTextField(
            name: 'address',
            minLines: 3,
            maxLines: 3,
            textAlignVertical: TextAlignVertical.top,
            decoration: _fieldDecoration('Address', Icons.home, tall: true),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Introdueix una adreça' : null,
          ),
          const SizedBox(height: 8),
          FormBuilderTextField(
            name: 'mobile',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _fieldDecoration('Mobile No', Icons.phone),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Introdueix el mòbil';
              if (value.trim().length < 9) return 'El mòbil ha de tenir almenys 9 dígits';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _actionButtons({required bool enabled}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        children: [
          FilledButton(
            onPressed: enabled ? _next : null,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF39618C),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('CONTINUE'),
          ),
          TextButton(
            onPressed: _cancel,
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jan Tchamitchian Garrido',
            style: TextStyle(fontSize: 19)),
        backgroundColor: const Color(0xFFA5CCFA),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _stepsBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: _step == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(child: Text('Personal',
                            style: TextStyle(fontSize: 28))),
                        const SizedBox(height: 4),
                        const Text('Pulsi "Contact" o pulsi el botó de "Continue".'),
                        _actionButtons(enabled: true),
                      ],
                    )
                  : _step == 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(child: Text('Contact',
                                style: TextStyle(fontSize: 28))),
                            const SizedBox(height: 4),
                            const Text('Pulsi "Upload" o pulsi el botó de "Continue".'),
                            const SizedBox(height: 12),
                            _contactForm(),
                            _actionButtons(enabled: true),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(child: Text('Upload',
                                style: TextStyle(fontSize: 28))),
                            const SizedBox(height: 12),
                            const Text('Submission Completed',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Text('Email: ${_savedValues['email'] ?? ''}'),
                            Text('Address: ${_savedValues['address'] ?? ''}'),
                            Text('Mobile: ${_savedValues['mobile'] ?? ''}'),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: _showSubmissionDialog,
                              child: const Text('SHOW RESULT'),
                            ),
                            TextButton(
                              onPressed: () => setState(() => _step = 1),
                              child: const Text('BACK'),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
