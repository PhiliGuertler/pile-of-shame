import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Morse {
  short,
  long;
}

enum MorseCode {
  a(code: [Morse.short, Morse.long]),
  b(code: [Morse.long, Morse.short, Morse.short, Morse.short]),
  c(code: [Morse.long, Morse.short, Morse.long, Morse.short]),
  d(code: [Morse.long, Morse.short, Morse.short]),
  e(code: [Morse.short]),
  f(code: [Morse.short, Morse.short, Morse.long, Morse.short]),
  g(code: [Morse.long, Morse.long, Morse.short]),
  h(code: [Morse.short, Morse.short, Morse.short, Morse.short]),
  i(code: [Morse.short, Morse.short]),
  j(code: [Morse.short, Morse.long, Morse.long, Morse.long]),
  k(code: [Morse.long, Morse.short, Morse.long]),
  l(code: [Morse.short, Morse.long, Morse.short, Morse.short]),
  m(code: [Morse.long, Morse.long]),
  n(code: [Morse.long, Morse.short]),
  o(code: [Morse.long, Morse.long, Morse.long]),
  p(code: [Morse.short, Morse.long, Morse.long, Morse.short]),
  q(code: [Morse.long, Morse.long, Morse.short, Morse.long]),
  r(code: [Morse.short, Morse.long, Morse.short]),
  s(code: [Morse.short, Morse.short, Morse.short]),
  t(code: [Morse.long]),
  u(code: [Morse.short, Morse.short, Morse.long]),
  v(code: [Morse.short, Morse.short, Morse.short, Morse.long]),
  w(code: [Morse.short, Morse.long, Morse.long]),
  x(code: [Morse.long, Morse.short, Morse.short, Morse.long]),
  y(code: [Morse.long, Morse.short, Morse.long, Morse.long]),
  z(code: [Morse.long, Morse.long, Morse.short, Morse.short]),
  ;

  final List<Morse> code;

  const MorseCode({required this.code});
}

class DebugSecretCodeInput extends StatefulWidget {
  final bool isAreaVisible;
  final VoidCallback onSecretEnteredCorrectly;
  final Widget? child;

  const DebugSecretCodeInput({
    super.key,
    this.isAreaVisible = false,
    required this.onSecretEnteredCorrectly,
    this.child,
  });

  @override
  State<DebugSecretCodeInput> createState() => _DebugSecretCodeInputState();
}

class _DebugSecretCodeInputState extends State<DebugSecretCodeInput> {
  int secretInputProgress = 0;
  int secretInputCodeProgress = 0;
  List<MorseCode> secretInputs = [MorseCode.p, MorseCode.s];
  Timer resetSecretTimer = Timer(Duration.zero, () {});

  void handleSecretInput(Morse press) {
    setState(() {
      resetSecretTimer.cancel();
      resetSecretTimer = Timer(const Duration(seconds: 3), () {
        debugPrint('Timeout, resetting secret Input Progress');
        setState(() {
          secretInputProgress = 0;
        });
      });
    });
    if (secretInputProgress < secretInputs.length) {
      final MorseCode code = secretInputs[secretInputProgress];
      if (secretInputCodeProgress < code.code.length) {
        final Morse morse = code.code[secretInputCodeProgress];
        if (morse == press) {
          HapticFeedback.lightImpact();
          if (secretInputCodeProgress + 1 >= code.code.length) {
            if (secretInputProgress + 1 >= secretInputs.length) {
              widget.onSecretEnteredCorrectly();
              setState(() {
                secretInputCodeProgress = 0;
                secretInputProgress = 0;
              });
            } else {
              setState(() {
                secretInputCodeProgress = 0;
                secretInputProgress = secretInputProgress + 1;
              });
            }
          } else {
            setState(() {
              secretInputCodeProgress = secretInputCodeProgress + 1;
            });
          }
        } else {
          setState(() {
            secretInputProgress = 0;
            secretInputCodeProgress = 0;
          });
        }
      }
    }
    if (secretInputs.length > secretInputProgress) {
      debugPrint(
        '$secretInputProgress / ${secretInputs.length} ($secretInputCodeProgress / ${secretInputs[secretInputProgress].code.length})',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        handleSecretInput(Morse.short);
      },
      onLongPress: () {
        debugPrint('long tap detected!');
        handleSecretInput(Morse.long);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: widget.isAreaVisible ? const Color.fromRGBO(0, 0, 0, 0.1) : null,
        child: widget.child,
      ),
    );
  }
}
