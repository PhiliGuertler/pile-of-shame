import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/developer_tools/debug_game_controller_shader/painters/game_controller_painter.dart';
import 'package:pile_of_shame/utils/shaders.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

class DebugGameControllerShaderScreen extends StatefulWidget {
  final Future<ui.FragmentShader> shader;
  final Future<ui.Image> image;

  DebugGameControllerShaderScreen({super.key})
      : shader = ShaderUtils().loadShader(const Size(350, 350)),
        image = ShaderUtils()
            .loadImage('assets/platforms/shader/sony/ps1_normals.webp');

  @override
  State<DebugGameControllerShaderScreen> createState() =>
      _DebugGameControllerShaderScreenState();
}

class _DebugGameControllerShaderScreenState
    extends State<DebugGameControllerShaderScreen> {
  double x = 0.0;
  double y = 0.0;

  void updatePosition(double dx, double dy) {
    setState(() {
      x = (dx / 350.0) * 2.0 - 1.0;
      y = (dy / 350.0) * 2.0 - 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text("Debug Game Controller Shader"),
      ),
      body: Center(
        child: Listener(
          onPointerDown: (event) {
            updatePosition(event.localPosition.dx, -event.localPosition.dy);
          },
          onPointerMove: (event) {
            updatePosition(event.localPosition.dx, -event.localPosition.dy);
          },
          child: SizedBox(
            width: 350,
            height: 350,
            child: FutureBuilder(
              future: widget.shader,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomPaint(
                    size: const Size(350, 350),
                    painter: GameControllerPainter(
                      shader: snapshot.data!,
                      x: x,
                      y: y,
                    ),
                  );
                }
                return const Text("Loading...");
              },
            ),
          ),
        ),
      ),
    );
  }
}
