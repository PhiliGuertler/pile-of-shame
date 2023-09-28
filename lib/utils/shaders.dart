import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show rootBundle;

class ShaderUtils {
  final Future<ui.FragmentProgram> fragmentProgram;

  ShaderUtils()
      : fragmentProgram =
            ui.FragmentProgram.fromAsset('shaders/game_controller_shader.frag');

  Future<ui.Image> loadImage(String imageUrl) async {
    final ByteData data = await rootBundle.load(imageUrl);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  Future<ui.FragmentShader> loadShader(Size size) async {
    final program = await fragmentProgram;

    final ui.Image normalImage =
        await loadImage('assets/platforms/shader/sony/ps1_normals.webp');
    final ui.Image diffuseImage =
        await loadImage('assets/platforms/shader/sony/ps1_flat.webp');

    final shader = program.fragmentShader();
    shader.setImageSampler(
      0,
      normalImage,
    );
    shader.setImageSampler(
      1,
      diffuseImage,
    );

    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, 0.0);
    shader.setFloat(3, 0.0);
    shader.setFloat(4, 10.0);

    return shader;
  }
}
