import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final bool isKg;
  const ChatScreen({super.key, required this.isKg});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  bool _isLoading = false;

  // Твой ключ Groq
  final String _apiKey =
      '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';

  // База мгновенных ответов для кнопок (0.01 сек)
  final Map<String, Map<String, String>> _instantAnswers = {
    'score': {
      'kg':
          '🎯 **ЖРТ босого баллдары:**\n'
          '• **Негизги тест** — 110 балл.\n'
          '• **Предметтик тесттер** — 60 балл.\n'
          '• **Мамлекеттик грант (бюджет)** — 120-130+ баллдан башталат.',
      'ru':
          '🎯 **Пороговые баллы ОРТ:**\n'
          '• **Основной тест** — 110 баллов.\n'
          '• **Предметные тесты** — 60 баллов.\n'
          '• **Грант (бюджет)** — обычно от 120-130+ баллов.',
    },
    'it': {
      'kg':
          '💻 **IT жана Программалоо ЖОЖдору:**\n'
          '1. **КМТУ (Политех)** — Программалык инженерия, Маалыматтык коопсуздук.\n'
          '2. **КУУ (Баласагын)** — Маалыматтык системалар жана технологиялар.\n'
          '3. **ОшМУ & ЖАМУ** — Колдонмо информатика, МИТ факультети.\n'
          '4. **КТУ Манас & Ала-Тоо** — Компьютердик инженерия.\n'
          '⚠️ *Милдеттүү: Математика предмети (≥60 балл).*',
      'ru':
          '💻 **Ведущие IT-вузы Кыргызстана:**\n'
          '1. **КГТУ (Политех)** — Программная инженерия, Информатика.\n'
          '2. **КНУ им. Баласагына** — Информационные системы.\n'
          '3. **ОшГУ & ЖАГУ** — Прикладная информатика, Факультет МИТ.\n'
          '4. **КТУ Манас & Ала-Тоо** — Компьютерная инженерия.\n'
          '⚠️ *Обязательно: профильная Математика (≥60 баллов).*',
    },
    'contract': {
      'kg':
          '🏛️ **Контракт баалары (болжолдуу):**\n'
          '• **КМТУ (Политех)** — 45 000 – 65 000 сом/жыл.\n'
          '• **КУУ (Улуттук университет)** — 42 000 – 60 000 сом/жыл.\n'
          '• **ОшМУ / ЖАМУ** — 35 000 – 50 000 сом/жыл.\n'
          '• **КТУ Манас** — Билим алуу акысыз (сынак аркылуу).',
      'ru':
          '🏛️ **Стоимость контракта (ориентировочно):**\n'
          '• **КГТУ (Политех)** — 45 000 – 65 000 сом/год.\n'
          '• **КНУ (Национальный)** — 42 000 – 60 000 сом/год.\n'
          '• **ОшГУ / ЖАГУ** — 35 000 – 50 000 сом/год.\n'
          '• **КТУ Манас** — Обучение бесплатное (по конкурсу).',
    },
    'talon': {
      'kg':
          '📄 **Талон таштоо эрежеси (2020.edu.gov.kg):**\n'
          '1. Порталга катталып, ЖРТ сертификат номериңизди жазасыз.\n'
          '2. 1-турда грантка же контракка электрондук талон жөнөтөсүз.\n'
          '3. Рейтингден өтсөңүз, убакытка чейин **"ТАСТЫКТАЙМ"** басып, аттестат тапшырасыз.',
      'ru':
          '📄 **Подача талонов через 2020.edu.gov.kg:**\n'
          '1. Регистрируетесь на портале по номеру сертификата ОРТ.\n'
          '2. Отправляете онлайн-талон на грант или контракт выбранного вуза.\n'
          '3. Если вас рекомендовали — обязательно нажмите **"ПОДТВЕРЖДАЮ"** до дедлайна.',
    },
  };

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'ai',
      'text': widget.isKg
          ? 'Салам! Мен EduKG кеңешчисимин. ЖРТ баллдарыңды же сурооңду жаз, дароо жардам берем!'
          : 'Привет! Я консультант EduKG. Напиши свои баллы ОРТ или вопрос, отвечу моментально!',
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? quickKey, String? displayLabel]) async {
    final text = displayLabel ?? _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    // Быстрый ответ без обращения к серверу
    if (quickKey != null && _instantAnswers.containsKey(quickKey)) {
      final instantReply = widget.isKg
          ? _instantAnswers[quickKey]!['kg']!
          : _instantAnswers[quickKey]!['ru']!;

      setState(() {
        _messages.add({'role': 'user', 'text': text});
        _messages.add({'role': 'ai', 'text': instantReply});
      });
      _scrollToBottom();
      return;
    }

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _messages.add({'role': 'ai', 'text': ''});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    final aiIndex = _messages.length - 1;

    final systemPrompt = widget.isKg
        ? 'Сен — Кыргызстандагы бүтүрүүчүлөр үчүн ЖРТ жана ЖОЖдор боюнча расмий EduKG кеңешчисисиң. '
              'Суроолорго СӨЗСҮЗ ТАЗА КЫРГЫЗ ТИЛИНДЕ, кыска, так жана 2-3 пункт менен толук жооп бер. '
              'Босого баллдар: негизги 110, предметтик 60. ЖОЖдор: КМТУ, КУУ, КРСУ, Манас, ОшМУ, ЖАМУ.'
        : 'Ты — официальный AI-консультант EduKG по ОРТ и вузам Кыргызстана. '
              'Отвечай четко, кратко (2-3 пункта) и вежливо на русском языке. '
              'Пороги: 110 основной, 60 предметный. Вузы: КГТУ, КНУ, КРСУ, Манас, ОшГУ, ЖАГУ.';

    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant', // Стабильная и быстрая модель Groq
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': text},
          ],
          'temperature': 0.3,
          'max_tokens': 500,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['choices'][0]['message']['content'] ?? '';
        setState(() {
          _messages[aiIndex]['text'] = reply;
        });
      } else {
        setState(() {
          _messages[aiIndex]['text'] = widget.isKg
              ? 'Ката: ${response.statusCode} - ${response.body}'
              : 'Ошибка: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages[aiIndex]['text'] = widget.isKg
            ? 'Байланыш катасы: $e'
            : 'Ошибка соединения: $e';
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
                      horizontal: 16,
                      vertical: 12,
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
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 14,
                        height: 1.4,
                      ),
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
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: widget.isKg
                            ? 'Суроо жазыңыз...'
                            : 'Напишите вопрос...',
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
                  const SizedBox(width: 8),
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
