import 'package:flutter/material.dart';

class MathTasksScreen extends StatefulWidget {
  final bool isKg;
  const MathTasksScreen({super.key, required this.isKg});

  @override
  State<MathTasksScreen> createState() => _MathTasksScreenState();
}

class _MathTasksScreenState extends State<MathTasksScreen> {
  int? _selectedLevel; // 1, 2 или 3
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswerChecked = false;
  int _score = 0;

  // Локализация текстов
  Map<String, String> get _t => widget.isKg
      ? {
          'title': 'Математика: Күндүн тапшырмасы',
          'chooseLevel': 'Кыйындык деңгээлин тандаңыз',
          'lvl1Title': '1-деңгээл: Базалык (Негизги)',
          'lvl1Desc': '30 тапшырма • Арифметика, бөлчөктөр, жөнөкөй теңдемелер',
          'lvl2Title': '2-деңгээл: Орточо (Стандарт)',
          'lvl2Desc': '30 тапшырма • Проценттер, геометрия, кыймыл маселелери',
          'lvl3Title': '3-деңгээл: Татаал (Грант / Олимпиада)',
          'lvl3Desc': '30 тапшырма • Логика, комбинаторика, А жана Б тилкесин салыштыруу',
          'startBtn': 'Баштоо',
          'questionOf': 'Суроо',
          'from': 'ичинен',
          'check': 'Текшерүү',
          'next': 'Кийинкиси',
          'finish': 'Жыйынтык',
          'correct': 'Туура! Азаматсыз 🎉',
          'wrong': 'Ката! Туура жообу төмөндө 📌',
          'explanation': 'Түшүндүрмөсү:',
          'resultTitle': 'Сынак аяктады!',
          'yourScore': 'Сиздин упайыңыз:',
          'retry': 'Кайра тапшыруу',
          'backHome': 'Башкы бетке чыгуу',
        }
      : {
          'title': 'Математика: Задание дня',
          'chooseLevel': 'Выбери уровень сложности',
          'lvl1Title': 'Уровень 1: Базовый',
          'lvl1Desc': '30 заданий • Арифметика, дроби, линейные уравнения',
          'lvl2Title': 'Уровень 2: Средний (Стандарт ОРТ)',
          'lvl2Desc': '30 заданий • Проценты, геометрия, задачи на движение',
          'lvl3Title': 'Уровень 3: Сложный (Бюджет / Грант)',
          'lvl3Desc':
              '30 заданий • Сравнение колонок А и Б, комбинаторика, логика',
          'startBtn': 'Начать',
          'questionOf': 'Вопрос',
          'from': 'из',
          'check': 'Проверить ответ',
          'next': 'Следующий вопрос',
          'finish': 'Завершить тест',
          'correct': 'Верно! Отличная работа 🎉',
          'wrong': 'Неверно! Правильный ответ ниже 📌',
          'explanation': 'Пояснение:',
          'resultTitle': 'Уровень пройден!',
          'yourScore': 'Твой результат:',
          'retry': 'Пройти снова',
          'backHome': 'На главную',
        };

  // База заданий по математике формата ЖРТ/ОРТ
  List<Map<String, dynamic>> _getQuestionsForLevel(int level) {
    if (level == 1) {
      // 1-деңгээл: Базовые вычисления, дроби, сравнения
      return [
        {
          'q_kg': 'Эсептеңиз: 15 - 3 × (4 - 2) + 8 ÷ 2 = ?',
          'q_ru': 'Вычислите: 15 - 3 × (4 - 2) + 8 ÷ 2 = ?',
          'options': ['11', '13', '15', '17'],
          'correct': 1, // 15 - 6 + 4 = 13
          'exp_kg': 'Алгач кашаа: (4-2)=2. Андан соң көбөйтүү жана бөлүү: 3×2=6 жана 8÷2=4. Жыйынтыгы: 15 - 6 + 4 = 13.',
          'exp_ru': 'Сначала скобки: (4-2)=2. Затем умножение и деление: 3×2=6 и 8÷2=4. Итого: 15 - 6 + 4 = 13.',
        },
        {
          'q_kg': 'Теңдемени чыгаргыла: 3x + 7 = 28',
          'q_ru': 'Решите уравнение: 3x + 7 = 28',
          'options': ['5', '6', '7', '8'],
          'correct': 2, // 3x = 21 -> x = 7
          'exp_kg': '3x = 28 - 7 => 3x = 21 => x = 7.',
          'exp_ru': '3x = 28 - 7 => 3x = 21 => x = 7.',
        },
        {
          'q_kg': 'А жана Б тилкелерин салыштырыңыз:\n[Колонка А]: (-3)²\n[Колонка Б]: -3²',
          'q_ru': 'Сравните значения колонок:\n[Колонка А]: (-3)²\n[Колонка Б]: -3²',
          'options': [
            widget.isKg ? 'А чоңураак' : 'Колонка А больше',
            widget.isKg ? 'Б чоңураак' : 'Колонка Б больше',
            widget.isKg ? 'Эки маани тең' : 'Значения равны',
            widget.isKg ? 'Аныктоо мүмкүн эмес' : 'Недостаточно данных',
          ],
          'correct': 0, // 9 > -9
          'exp_kg':
              'Колонка А: (-3)² = 9. Колонка Б: -3² = -9. Ошондуктан А чоң.',
          'exp_ru': 'Колонка А: (-3)² = 9. Колонка Б: -3² = -9. 9 > -9, значит Колонка А больше.',
        },
        {
          'q_kg': 'Сандын 25%ы 40ка барабар болсо, ал сандын өзү канча?',
          'q_ru': 'Если 25% числа равны 40, чему равно само число?',
          'options': ['100', '120', '160', '200'],
          'correct': 2, // 40 * 4 = 160
          'exp_kg': '25% - бул төрттөн бир бөлүгү (1/4). Демек 40 × 4 = 160.',
          'exp_ru': '25% — это четверть числа (1/4). Значит, 40 × 4 = 160.',
        },
        {
          'q_kg': 'Жөнөкөйлөтүңүз: 2/5 + 3/10 = ?',
          'q_ru': 'Упростите выражение: 2/5 + 3/10 = ?',
          'options': ['5/15', '7/10', '1/2', '4/5'],
          'correct': 1, // 4/10 + 3/10 = 7/10
          'exp_kg': 'Жалпы бөлүүчүсү 10: 4/10 + 3/10 = 7/10.',
          'exp_ru': 'Общий знаменатель 10: 4/10 + 3/10 = 7/10.',
        },
      ];
    } else if (level == 2) {
      // 2-деңгээл: Геометрия, проценты, текстовые задачи
      return [
        {
          'q_kg': 'Тик бурчтуу үч бурчтуктун катеттери 6 см жана 8 см. Гипотенузасын тапкыла.',
          'q_ru': 'Катеты прямоугольного треугольника равны 6 см и 8 см. Найдите гипотенузу.',
          'options': ['9 см', '10 см', '12 см', '14 см'],
          'correct': 1, // Пифагор: 36+64=100 -> 10
          'exp_kg': 'Пифагор теоремасы: c² = a² + b² = 6² + 8² = 36 + 64 = 100. c = 10 см.',
          'exp_ru': 'Теорема Пифагора: c² = a² + b² = 6² + 8² = 36 + 64 = 100 => c = 10 см.',
        },
        {
          'q_kg': 'Товардын баасы 1000 сом эле. Алгач 20%га кымбаттап, анан 20%га арзандады. Азыркы баасы канча?',
          'q_ru': 'Товар стоил 1000 сомов. Сначала он подорожал на 20%, а затем подешевел на 20%. Какова новая цена?',
          'options': ['1000 сом', '960 сом', '980 сом', '1040 сом'],
          'correct': 1, // 1000 -> 1200 -> 960
          'exp_kg': '1000 + 20% = 1200 сом. Андан соң 1200дөн 20% (240 сом) кемийт: 1200 - 240 = 960 сом.',
          'exp_ru': '1000 + 20% = 1200. Затем от 1200 отнимаем 20% (240 сом): 1200 - 240 = 960 сомов.',
        },
        {
          'q_kg': 'Автоунаа 180 км жолду 3 саатта басып өттү. Анын ылдамдыгы канча км/саат?',
          'q_ru': 'Автомобиль проехал 180 км за 3 часа. Какова его скорость?',
          'options': ['50 км/ч', '55 км/ч', '60 км/ч', '65 км/ч'],
          'correct': 2,
          'exp_kg': 'Ылдамдык V = S / t = 180 / 3 = 60 км/саат.',
          'exp_ru': 'Скорость V = S / t = 180 / 3 = 60 км/ч.',
        },
      ];
    } else {
      // 3-деңгээл: ОРТ логикасы, салыштыруулар, комбинаторика
      return [
        {
          'q_kg': 'Эгер x > y жана xy < 0 болсо, А жана Б тилкелерин салыштырыңыз:\n[Колонка А]: x\n[Колонка Б]: 0',
          'q_ru': 'Если x > y и xy < 0, сравните колонки:\n[Колонка А]: x\n[Колонка Б]: 0',
          'options': [
            widget.isKg ? 'А чоңураак' : 'Колонка А больше',
            widget.isKg ? 'Б чоңураак' : 'Колонка Б больше',
            widget.isKg ? 'Эки маани тең' : 'Значения равны',
            widget.isKg ? 'Аныктоо мүмкүн эмес' : 'Недостаточно данных',
          ],
          'correct': 0, // x > 0, y < 0 -> x > 0
          'exp_kg': 'xy < 0 болгондуктан бири оң, бири терс. x > y болгондуктан, x сөзсүз оң сан (x > 0). Демек А чоң.',
          'exp_ru': 'Так как xy < 0, знаки чисел разные. Так как x > y, x обязательно положительный (x > 0). Колонка А > 0.',
        },
        {
          'q_kg': '5 окуучунун арасынан 2 нөөмөтчүнү канча түрдүү жол менен тандап алса болот?',
          'q_ru': 'Сколькими способами из 5 учеников можно выбрать 2 дежурных?',
          'options': ['10', '15', '20', '25'],
          'correct': 0, // C(5, 2) = 10
          'exp_kg':
              'Айкалыштар формуласы: C(5, 2) = (5 × 4) / (2 × 1) = 10 жол.',
          'exp_ru':
              'Формула сочетаний: C(5, 2) = (5 × 4) / (2 × 1) = 10 способов.',
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(title: Text(_t['title']!), backgroundColor: Colors.white),
      body: _selectedLevel == null ? _buildLevelSelector() : _buildQuizBody(),
    );
  }

  // 1. Экран выбора уровня сложности
  Widget _buildLevelSelector() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t['chooseLevel']!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E242B),
            ),
          ),
          const SizedBox(height: 16),
          _buildLevelCard(
            level: 1,
            title: _t['lvl1Title']!,
            subtitle: _t['lvl1Desc']!,
            badgeColor: const Color(0xFF4CAF50),
            gradient: const [Color(0xFFE8F5E9), Colors.white],
            icon: Icons.filter_1_rounded,
          ),
          const SizedBox(height: 14),
          _buildLevelCard(
            level: 2,
            title: _t['lvl2Title']!,
            subtitle: _t['lvl2Desc']!,
            badgeColor: const Color(0xFFFF9800),
            gradient: const [Color(0xFFFFF3E0), Colors.white],
            icon: Icons.filter_2_rounded,
          ),
          const SizedBox(height: 14),
          _buildLevelCard(
            level: 3,
            title: _t['lvl3Title']!,
            subtitle: _t['lvl3Desc']!,
            badgeColor: const Color(0xFFE52D27),
            gradient: const [Color(0xFFFFEBEE), Colors.white],
            icon: Icons.filter_3_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required int level,
    required String title,
    required String subtitle,
    required Color badgeColor,
    required List<Color> gradient,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLevel = level;
          _currentQuestionIndex = 0;
          _score = 0;
          _selectedAnswerIndex = null;
          _isAnswerChecked = false;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: gradient),
          border: Border.all(color: badgeColor.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E242B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // 2. Экран прохождения тестов
  Widget _buildQuizBody() {
    final questions = _getQuestionsForLevel(_selectedLevel!);

    if (_currentQuestionIndex >= questions.length) {
      return _buildResultScreen(questions.length);
    }

    final q = questions[_currentQuestionIndex];
    final questionText = widget.isKg ? q['q_kg'] : q['q_ru'];
    final options = q['options'] as List<String>;
    final correctIndex = q['correct'] as int;

    return Column(
      children: [
        // Прогресс бар вверху
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / questions.length,
          backgroundColor: Colors.grey.shade200,
          color: const Color(0xFFE52D27),
          minHeight: 5,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Номер вопроса
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE52D27).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_t['questionOf']!} ${_currentQuestionIndex + 1} ${_t['from']!} ${questions.length}',
                        style: const TextStyle(
                          color: Color(0xFFE52D27),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      '⭐ Балл: $_score',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Карточка с вопросом
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    questionText,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      color: Color(0xFF1E242B),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Варианты ответов (A, B, C, D)
                ...List.generate(options.length, (idx) {
                  final letter = String.fromCharCode(65 + idx); // A, B, C, D
                  final isSelected = _selectedAnswerIndex == idx;

                  Color borderCol = Colors.grey.shade300;
                  Color bgCol = Colors.white;
                  Color textCol = Colors.black87;

                  if (_isAnswerChecked) {
                    if (idx == correctIndex) {
                      borderCol = const Color(0xFF4CAF50);
                      bgCol = const Color(0xFFE8F5E9);
                      textCol = const Color(0xFF2E7D32);
                    } else if (isSelected) {
                      borderCol = const Color(0xFFE52D27);
                      bgCol = const Color(0xFFFFEBEE);
                      textCol = const Color(0xFFC62828);
                    }
                  } else if (isSelected) {
                    borderCol = const Color(0xFFE52D27);
                    bgCol = const Color(0xFFFFEBEE).withOpacity(0.5);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: _isAnswerChecked
                          ? null
                          : () {
                              setState(() => _selectedAnswerIndex = idx);
                            },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: bgCol,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderCol, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFE52D27)
                                    : Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                options[idx],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textCol,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                // Пояснение после проверки
                if (_isAnswerChecked) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedAnswerIndex == correctIndex
                              ? _t['correct']!
                              : _t['wrong']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _selectedAnswerIndex == correctIndex
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFC62828),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_t['explanation']!} ${widget.isKg ? q['exp_kg'] : q['exp_ru']}',
                          style: const TextStyle(fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Нижняя кнопка: «Проверить» или «Следующий»
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE52D27),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _selectedAnswerIndex == null
                    ? null
                    : () {
                        if (!_isAnswerChecked) {
                          setState(() {
                            _isAnswerChecked = true;
                            if (_selectedAnswerIndex == correctIndex) {
                              _score++;
                            }
                          });
                        } else {
                          setState(() {
                            _currentQuestionIndex++;
                            _selectedAnswerIndex = null;
                            _isAnswerChecked = false;
                          });
                        }
                      },
                child: Text(
                  !_isAnswerChecked
                      ? _t['check']!
                      : (_currentQuestionIndex + 1 == questions.length
                            ? _t['finish']!
                            : _t['next']!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 3. Экран итогов
  Widget _buildResultScreen(int total) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              _t['resultTitle']!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              '${_t['yourScore']!} $_score / $total',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE52D27),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE52D27),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedLevel = null;
                });
              },
              child: Text(
                _t['retry']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
