import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:image_picker/image_picker.dart';

/// Custom drawn triangles
class Triangle extends PaintContent {
  Triangle();

  Triangle.data({
    required this.startPoint,
    required this.A,
    required this.B,
    required this.C,
    required Paint paint,
  }) : super.paint(paint);

  factory Triangle.fromJson(Map<String, dynamic> data) {
    return Triangle.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      A: jsonToOffset(data['A'] as Map<String, dynamic>),
      B: jsonToOffset(data['B'] as Map<String, dynamic>),
      C: jsonToOffset(data['C'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;

  Offset A = Offset.zero;
  Offset B = Offset.zero;
  Offset C = Offset.zero;

  @override
  String get contentType => 'Triangle';

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) {
    A = Offset(
        startPoint.dx + (nowPoint.dx - startPoint.dx) / 2, startPoint.dy);
    B = Offset(startPoint.dx, nowPoint.dy);
    C = nowPoint;
  }

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final Path path = Path()
      ..moveTo(A.dx, A.dy)
      ..lineTo(B.dx, B.dy)
      ..lineTo(C.dx, C.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  Triangle copy() => Triangle();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }
}

class ImageContent extends PaintContent {
  ImageContent(this.image, {this.imageUrl = ''});

  ImageContent.data({
    required this.startPoint,
    required this.size,
    required this.image,
    required this.imageUrl,
    required Paint paint,
  }) : super.paint(paint);

  factory ImageContent.fromJson(Map<String, dynamic> data) {
    return ImageContent.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      size: jsonToOffset(data['size'] as Map<String, dynamic>),
      imageUrl: data['imageUrl'] as String,
      image: data['image'] as ui.Image,
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;
  Offset size = Offset.zero;
  final String imageUrl;
  final ui.Image image;

  @override
  String get contentType => 'ImageContent';

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => size = nowPoint - startPoint;

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final Rect rect = Rect.fromPoints(startPoint, startPoint + this.size);
    paintImage(canvas: canvas, rect: rect, image: image, fit: BoxFit.fill);
  }

  @override
  ImageContent copy() => ImageContent(image);

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'size': size.toJson(),
      'imageUrl': imageUrl,
      'paint': paint.toJson(),
    };
  }
}

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({
    super.key,
    required this.pagePath,
    required this.pictureIndex,
  });
  final int pictureIndex;
  final String pagePath;

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final DrawingController _drawingController = DrawingController();
  bool isReady = true;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _drawingController.dispose();
    textController.dispose();
    super.dispose();
    super.dispose();
  }

  Future<void> _saveImage(Uint8List data) async {
    try {
      final File imageFile = File(widget.pagePath);

      await imageFile.writeAsBytes(data, flush: true);

      debugPrint('Image overwritten at ${widget.pagePath}');
    } catch (e) {
      debugPrint('Error overwriting image: $e');
    }
  }

  /// 获取画板数据 `getImageData()`
  Future<void> _getImageData() async {
    Fluttertoast.showToast(
        msg: "Картинка компилируется, ожидайте...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0);
    isReady = false;
    final Uint8List? data =
        (await _drawingController.getImageData())?.buffer.asUint8List();

    if (data == null) {
      debugPrint('Failed to get image data');
      return;
    }

    if (mounted) {
      showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                isReady = true;
                await _saveImage(data);
                Navigator.pop(c);
              },
              child: Image.memory(data),
            ),
          );
        },
      );
    }
  }

  PaletteType _paletteType = PaletteType.hsl;
  bool _enableAlpha = false;
  bool _displayThumbColor = true;
  final List<ColorLabelType> _labelTypes = [
    ColorLabelType.hex,
    ColorLabelType.rgb
  ];
  bool _displayHexInputBar = true;

  // Picker 4
  final textController = TextEditingController(
      text:
          '#2F19DB'); // The initial value can be provided directly to the controller.

  void _restBoard() {
    _transformationController.value = Matrix4.identity();
  }

  Color currentColor = Colors.red;
  void changeColor(Color color) => setState(() => currentColor = color);

  void showColorPicker(BuildContext context, Color initialColor,
      Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initialColor,
              onColorChanged: onColorChanged,
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.all(
                Radius.circular(2),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

// Usage example
  void _changeColor(Color color) {
    setState(() => currentColor = color);
    _drawingController.setStyle(color: color);
  }

  Future<ui.Image> _getImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final Uint8List bytes = await file.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      return frameInfo.image;
    } else {
      throw Exception('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  titlePadding: const EdgeInsets.all(0),
                  contentPadding: const EdgeInsets.all(0),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: currentColor,
                      onColorChanged: _changeColor,
                      colorPickerWidth: 300,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: _enableAlpha,
                      labelTypes: _labelTypes,
                      displayThumbColor: _displayThumbColor,
                      paletteType: _paletteType,
                      pickerAreaBorderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                      ),
                      hexInputBar: _displayHexInputBar,
                    ),
                  ),
                );
              },
            );
          },
          icon: Icon(Icons.color_lens),
        ),
        title: Text('Picture ${widget.pictureIndex + 1}'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: <Widget>[
          isReady
              ? IconButton(icon: Icon(Icons.check), onPressed: _getImageData)
              : CircularProgressIndicator(),
          IconButton(
              icon: const Icon(Icons.restore_page_rounded),
              onPressed: _restBoard),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return DrawingBoard(
                  // boardPanEnabled: false,
                  // boardScaleEnabled: false,
                  transformationController: _transformationController,
                  controller: _drawingController,
                  background: Image.file(File(widget.pagePath)),
                  showDefaultActions: true,
                  showDefaultTools: true,
                  defaultToolsBuilder: (Type t, _) {
                    return DrawingBoard.defaultTools(t, _drawingController)
                      ..insert(
                        1,
                        DefToolItem(
                          icon: Icons.change_history_rounded,
                          isActive: t == Triangle,
                          onTap: () =>
                              _drawingController.setPaintContent(Triangle()),
                        ),
                      )
                      ..insert(
                        2,
                        DefToolItem(
                          icon: Icons.image_rounded,
                          isActive: t == ImageContent,
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext c) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                            try {
                              final ui.Image image =
                                  await _getImageFromGallery();
                              if (image != null) {
                                _drawingController.setPaintContent(ImageContent(
                                  image,
                                  imageUrl: '',
                                ));
                              }
                            } catch (e) {
                              // Handle the error
                            } finally {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                      );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
