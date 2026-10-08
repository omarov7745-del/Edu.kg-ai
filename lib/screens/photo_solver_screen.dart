import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class PhotoSolverScreen extends StatefulWidget {
  final bool isKg;
  const PhotoSolverScreen({super.key, required this.isKg});

  @override
  State<PhotoSolverScreen> createState() => _PhotoSolverScreenState();
}

class _PhotoSolverScreenState extends State<PhotoSolverScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String _solution = '';
  bool _isLoading = false;

  final String _apiKey =
      'AQ.Ab8RN6LGeGRgqWWaDdwDANdmiN4zA3e_3DtEjButKSIEAeNNIg';

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Сжимаем фото до 1024px и 70% качества: вес падает с 3 МБ до 150 КБ
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70,
      );

      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _solution = '';
      });

      _solveTask(bytes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isKg
                ? 'Сүрөттү жүктөөдө ката кетти: $e'
                : 'Ошибка загрузки фото: $e',
          ),
        ),
      );
    }
  }

  Future<void> _solveTask(Uint8List bytes) async {
    setState(() {
      _isLoading = true;
      _solution = '';
    });

    final promptText = widget.isKg
        ? 'Сен — Кыргызстандагы ЖРТ (ОРТ) боюнча тьюторсуң. Сүрөттөгү маселени кыска жана так чыгар: '
              '1. Шартты кыска жаз. 2. Кадамдап чыгарылышын көрсөт. 3. Туура жооптун вариантын (A, B, C же D) белгиле.'
        : 'Ты — эксперт по ОРТ в Кыргызстане. Быстро и четко реши задачу с фото: '
              '1. Кратко условие. 2. Пошаговое решение. 3. Правильный вариант ответа (A, B, C или D).';

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        ],
      );

      final content = [
        Content.multi([TextPart(promptText), DataPart('image/jpeg', bytes)]),
      ];

      // Потоковый ответ: текст печатается на экране сразу по мере генерации
      final responseStream = model.generateContentStream(content);

      await for (final chunk in responseStream) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _solution += chunk.text ?? '';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _solution = widget.isKg
            ? 'Сервер убактылуу бош эмес. Интернетти текшерип, кайра басыңыз.'
            : 'Сервер временно перегружен. Проверьте сеть и повторите попытку.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isKg ? 'Маселе чыгаруу' : 'Решить задачу по фото'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flash_on_rounded, color: Colors.deepOrange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.isKg
                          ? 'Сүрөттү тартсаңыз, AI маселени дароо экранга чыгарып берет.'
                          : 'Сфотографируйте задачу — ответ начнёт печататься прямо на экране.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.brown.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: Text(
                      widget.isKg ? 'Камера' : 'Камера',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(
                      Icons.photo_library_rounded,
                      color: Colors.teal,
                    ),
                    label: Text(
                      widget.isKg ? 'Галерея' : 'Галерея',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_imageBytes != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Image.memory(
                    _imageBytes!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_isLoading && _solution.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: Color(0xFFD32F2F)),
                    const SizedBox(height: 14),
                    Text(
                      widget.isKg
                          ? 'EduKG AI маселени талдап жатат...'
                          : 'EduKG AI анализирует задачу...',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            if (_solution.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.green.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.isKg ? 'Чыгарылышы:' : 'Пошаговый разбор:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    SelectableText(
                      _solution,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
