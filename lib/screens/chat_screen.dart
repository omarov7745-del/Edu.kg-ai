import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final bool isKg;
  const ChatScreen({super.key, required this.isKg});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  // Список сообщений: role, text, imagePath
  final List<Map<String, String?>> _messages = [];

  bool _isLoading = false;

  // Настройки шлюза DarkAPI
  final String _apiKey =
      'tc_live_a3c37f6ed16189438aec6fd836acbbff8165daead4375786';
  final String _apiUrl = 'https://darkapi.shop/v1/chat/completions';

  // Модели: для текста быстрая Luna, для фото — видящая Sonnet 5.5
  final String _textModel = 'gpt-6-luna';
  final String _visionModel = 'claude-sonnet-5.5';

  // База мгновенных локальных ответов (0.001 сек)
  final Map<String, Map<String, String>> _instantAnswers = {
    'score': {
      'kg':
          '🎯 **ЖРТ босого баллдары:**\n'
          '• Негизги тест — 110 балл.\n'
          '• Предметтик тесттер — 60 балл.\n'
          '• Мамлекеттик грант — 120-130+ балл.',
      'ru':
          '🎯 **Пороговые баллы ОРТ:**\n'
          '• Основной тест — 110 баллов.\n'
          '• Предметные тесты — 60 баллов.\n'
          '• Бюджет (грант) — от 120-130+ баллов.',
    },
    'it': {
      'kg':
          '💻 **IT боюнча негизги ЖОЖдор:**\n'
          '1. КМТУ (Политех) — Программалык инженерия.\n'
          '2. КУУ — Маалыматтык системалар.\n'
          '3. ОшМУ жана ЖАМУ — Колдонмо информатика.\n'
          '4. Манас жана Ала-Тоо — Компьютердик инженерия.\n'
          '⚠️ Математика предмети милдеттүү (≥60 балл).',
      'ru':
          '💻 **Ведущие IT-вузы Кыргызстана:**\n'
          '1. КГТУ (Политех) — Программная инженерия.\n'
          '2. КНУ им. Баласагына — Информационные системы.\n'
          '3. ОшГУ и ЖАГУ — Прикладная информатика.\n'
          '4. КТУ Манас и Ала-Тоо — Компьютерная инженерия.\n'
          '⚠️ Профильная математика обязательна (≥60 баллов).',
    },
    'contract': {
      'kg':
          '🏛️ **Контракт баалары (жылына):**\n'
          '• КМТУ (Политех) — 45 000 – 65 000 сом.\n'
          '• КУУ — 42 000 – 60 000 сом.\n'
          '• ОшМУ / ЖАМУ — 35 000 – 50 000 сом.\n'
          '• КТУ Манас — Акысыз (сынак аркылуу).',
      'ru':
          '🏛️ **Стоимость контракта (в год):**\n'
          '• КГТУ (Политех) — 45 000 – 65 000 сом.\n'
          '• КНУ — 42 000 – 60 000 сом.\n'
          '• ОшГУ / ЖАГУ — 35 000 – 50 000 сом.\n'
          '• КТУ Манас — Бесплатно (по конкурсу).',
    },
    'talon': {
      'kg':
          '📄 **Талон тапшыруу (2020.edu.gov.kg):**\n'
          '1. Порталга катталып, сертификат номерин жаз.\n'
          '2. Онлайн талонду грантка же контракка жибер.\n'
          '3. Тизмеден өтсөң, "ТАСТЫКТАЙМ" басып аттестат тапшыр.',
      'ru':
          '📄 **Подача талонов (2020.edu.gov.kg):**\n'
          '1. Зарегистрируйся на портале по номеру сертификата.\n'
          '2. Отправь электронный талон на грант или контракт.\n'
          '3. При рекомендации нажми "ПОДТВЕРЖДАЮ" до дедлайна.',
    },
  };

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'ai',
      'text': widget.isKg
          ? 'Салам! Мен EduKG кеңешчисимин. Сурооңду жаз же маселени камерага тартып жөнөт!'
          : 'Привет! Я консультант EduKG. Задай вопрос или сфотографируй задачу на камеру!',
      'imagePath': null,
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // --- ЛОГИКА КАМЕРЫ И РЕШЕНИЯ ЗАДАЧ ---
  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: Color(0xFFD32F2F),
                ),
                title: Text(
                  widget.isKg ? 'Камера менен тартуу' : 'Сделать фото задачи',
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _processTaskImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: Color(0xFFD32F2F),
                ),
                title: Text(
                  widget.isKg ? 'Галереядан тандоо' : 'Выбрать из галереи',
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _processTaskImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processTaskImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70, // Оптимизация размера для быстрой передачи
      );

      if (file == null) return;

      setState(() {
        _messages.add({
          'role': 'user',
          'text': widget.isKg ? '📷 Тапшырманын сүрөтү' : '📷 Фото задачи',
          'imagePath': file.path,
        });
        _messages.add({'role': 'ai', 'text': '', 'imagePath': null});
        _isLoading = true;
      });
      _scrollToBottom();

      final aiIndex = _messages.length - 1;
      final bytes = await File(file.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      final prompt = widget.isKg
          ? 'Сен — ЖРТ/ОРТ боюнча репетиторсуң.\n'
                'Сүрөттөгү тапшырманы/суроону таап:\n'
                '1. Кыскача чыгарылышын (1-2 кадам) көрсөт.\n'
                '2. Туура жооптун вариантын (А, Б, В, Г же сандык маанисин) так белгиле.\n'
                'Жоопту ТАЗА КЫРГЫЗ ТИЛИНДЕ гана, кыска жана так жаз.'
          : 'Ты — репетитор по ОРТ/ЖРТ Кыргызстана.\n'
                'Реши задачу на фото:\n'
                '1. Покажи краткий ход решения (1-2 шага).\n'
                '2. Четко выдели верный вариант ответа (А, Б, В, Г или число).\n'
                'Ответь строго на русском языке, без лишней воды.';

      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
            body: jsonEncode({
              'model': _visionModel, // claude-sonnet-5.5
              'messages': [
                {
                  'role': 'user',
                  'content': [
                    {'type': 'text', 'text': prompt},
                    {
                      'type': 'image_url',
                      'image_url': {
                        'url': 'data:image/jpeg;base64,$base64Image',
                      },
                    },
                  ],
                },
              ],
              'max_tokens': 350,
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['choices'][0]['message']['content'] ?? '';
        setState(() {
          _messages[aiIndex]['text'] = reply.trim();
        });
      } else {
        setState(() {
          _messages[aiIndex]['text'] = widget.isKg
              ? 'Сүрөттү иштетүүдө ката чыкты (${response.statusCode})'
              : 'Ошибка распознавания фото (${response.statusCode})';
        });
      }
    } on TimeoutException {
      if (!mounted) return;
      final aiIndex = _messages.length - 1;
      setState(() {
        _messages[aiIndex]['text'] = widget.isKg
            ? 'Сүрөт өтө көп убакытты алды. Кайра тартып көрүңүз.'
            : 'Время ожидания истекло. Попробуй сфотографировать задачу четче.';
      });
    } catch (e) {
      if (!mounted) return;
      final aiIndex = _messages.length - 1;
      setState(() {
        _messages[aiIndex]['text'] = 'Ката: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  // --- ЛОГИКА ТЕКСТОВЫХ СООБЩЕНИЙ ---
  Future<void> _sendMessage([String? quickKey, String? displayLabel]) async {
    final text = displayLabel ?? _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    // 1. Мгновенные кнопки
    if (quickKey != null && _instantAnswers.containsKey(quickKey)) {
      final instantReply = widget.isKg
          ? _instantAnswers[quickKey]!['kg']!
          : _instantAnswers[quickKey]!['ru']!;

      setState(() {
        _messages.add({'role': 'user', 'text': text, 'imagePath': null});
        _messages.add({'role': 'ai', 'text': instantReply, 'imagePath': null});
      });
      _scrollToBottom();
      return;
    }

    final lowerText = text.toLowerCase();

    // 2. Определение языка
    final hasKgLetters = RegExp(r'[өүңӨҮҢ]').hasMatch(text);
    final hasKgWords = RegExp(
      r'\b(кандай|канча|кайда|кайсы|эмне|керек|болот|жок|бар|менен|үчүн|тапшыр|тапшырсам|жрт|жож|салам|окуу|жакшы|болсо|балым|босого|кимсиң|эреже)\b',
    ).hasMatch(lowerText);

    final hasRuWords = RegExp(
      r'\b(как|сколько|куда|какой|какие|какая|где|что|поступить|проходной|привет|здравствуйте|подать|универ|хочу|можно|если|документы|льготы|грант|бюджет|кто ты)\b',
    ).hasMatch(lowerText);

    bool isKyrgyz;
    if (hasKgLetters || hasKgWords) {
      isKyrgyz = true;
    } else if (hasRuWords) {
      isKyrgyz = false;
    } else {
      isKyrgyz = widget.isKg;
    }

    // 3. Мгновенные локальные ответы (0.001 сек)
    if (lowerText.contains('кто ты') ||
        lowerText.contains('какой ты ии') ||
        lowerText.contains('сен кимсиң') ||
        lowerText.contains('кандай ии')) {
      setState(() {
        _messages.add({'role': 'user', 'text': text, 'imagePath': null});
        _messages.add({
          'role': 'ai',
          'text': isKyrgyz
              ? 'Мен — EduKG, Кыргызстандагы абитуриенттер үчүн AI кеңешчимин.'
              : 'Я — AI-помощник EduKG для абитуриентов Кыргызстана.',
          'imagePath': null,
        });
      });
      _controller.clear();
      _scrollToBottom();
      return;
    }

    if (lowerText == 'привет' ||
        lowerText == 'здравствуйте' ||
        lowerText == 'салам' ||
        lowerText == 'салам алейкум') {
      setState(() {
        _messages.add({'role': 'user', 'text': text, 'imagePath': null});
        _messages.add({
          'role': 'ai',
          'text': isKyrgyz
              ? 'Салам! Сурооңду же ЖРТ балыңды жаз, дароо жардам берем.'
              : 'Привет! Напиши свой вопрос или баллы ОРТ, подскажу варианты.',
          'imagePath': null,
        });
      });
      _controller.clear();
      _scrollToBottom();
      return;
    }

    setState(() {
      _messages.add({'role': 'user', 'text': text, 'imagePath': null});
      _messages.add({'role': 'ai', 'text': '', 'imagePath': null});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    final aiIndex = _messages.length - 1;

    final String systemPrompt = isKyrgyz
        ? 'Сен — EduKG AI кеңешчисисиң. ЖООПТУ ТАЗА КЫРГЫЗЧА ГАНА, саламдашпастан, 1-2 кыска сүйлөм менен бер. Босого: негизги 110, предмет 60, грант 120-130+.'
        : 'Ты — AI EduKG. Отвечай СТРОГО НА РУССКОМ, без приветствий и воды, ровно в 1-2 коротких предложениях. Пороги: основной 110, предмет 60, грант 120-130+.';

    final String promptToSend = isKyrgyz
        ? '$text\n(Жоопту кыска 1-2 сүйлөм менен кыргызча гана жаз)'
        : '$text\n(Ответь предельно кратко в 1-2 предложения на русском)';

    try {
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
            body: jsonEncode({
              'model': _textModel,
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': promptToSend},
              ],
              'temperature': 0.0,
              'max_tokens': 80,
            }),
          )
          .timeout(const Duration(seconds: 7));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['choices'][0]['message']['content'] ?? '';
        setState(() {
          _messages[aiIndex]['text'] = reply.trim();
        });
      } else {
        setState(() {
          _messages[aiIndex]['text'] = isKyrgyz
              ? 'Сервер катасы (${response.statusCode})'
              : 'Ошибка сервера (${response.statusCode})';
        });
      }
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _messages[aiIndex]['text'] = isKyrgyz
            ? 'Сервер бош эмес. Суроону кайра жөнөтүңүз.'
            : 'Сервер перегружен. Нажмите кнопку отправки еще раз.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages[aiIndex]['text'] = isKyrgyz
            ? 'Байланыш катасы: $e'
            : 'Ошибка сети: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isKg ? 'AI Кеңешчи' : 'AI Консультант'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                final text = msg['text'] ?? '';
                final imagePath = msg['imagePath'];

                if (text.isEmpty && !isUser) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.isKg
                                ? 'Жооп даярдалууда...'
                                : 'Печатает ответ...',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.82,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFFD32F2F) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Если в сообщении прикреплена фотография
                        if (imagePath != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(imagePath),
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                _buildFastChip(
                  keyId: 'score',
                  label: widget.isKg
                      ? '🎯 Босого баллдар'
                      : '🎯 Пороговые баллы',
                ),
                _buildFastChip(
                  keyId: 'it',
                  label: widget.isKg
                      ? '💻 IT адистиктери'
                      : '💻 IT специальности',
                ),
                _buildFastChip(
                  keyId: 'contract',
                  label: widget.isKg
                      ? '🏛️ Контракт баалары'
                      : '🏛️ Цены на контракт',
                ),
                _buildFastChip(
                  keyId: 'talon',
                  label: widget.isKg
                      ? '📄 Талон эрежеси'
                      : '📄 Как подать талон',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  // Кнопка камеры / галереи
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Color(0xFFD32F2F),
                      size: 26,
                    ),
                    onPressed: _isLoading ? null : _showImagePickerSheet,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: widget.isKg
                            ? 'Суроо же маселе жазыңыз...'
                            : 'Вопрос или задача...',
                        filled: true,
                        fillColor: const Color(0xFFF1F3F4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Color(0xFFD32F2F),
                    ),
                    onPressed: _isLoading ? null : () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFastChip({required String keyId, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        backgroundColor: Colors.white,
        elevation: 1,
        side: BorderSide(color: Colors.grey.shade300),
        onPressed: _isLoading ? null : () => _sendMessage(keyId, label),
      ),
    );
  }
}
