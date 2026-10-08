import 'package:flutter/material.dart';

class ChanceCalculatorScreen extends StatefulWidget {
  final bool isKg;
  const ChanceCalculatorScreen({super.key, required this.isKg});

  @override
  State<ChanceCalculatorScreen> createState() => _ChanceCalculatorScreenState();
}

class _ChanceCalculatorScreenState extends State<ChanceCalculatorScreen> {
  final TextEditingController _mainScoreController = TextEditingController();

  final TextEditingController _mathController = TextEditingController();
  final TextEditingController _physController = TextEditingController();
  final TextEditingController _chemController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _engController = TextEditingController();
  final TextEditingController _histController = TextEditingController();

  String _selectedDirection = 'it';
  Map<String, dynamic>? _calculationResult;

  final Map<String, Map<String, String>> _directions = {
    'it': {
      'ru': '💻 IT, Программирование и ИИ',
      'kg': '💻 IT, Программалоо жана ЖИ',
    },
    'med': {
      'ru': '🩺 Лечебное дело, Педиатрия, Фармация',
      'kg': '🩺 Дарылоо иши, Педиатрия, Фармация',
    },
    'eng': {
      'ru': '🏗️ Инженерия, Строительство, Энергетика',
      'kg': '🏗️ Инженерия, Курулуш, Энергетика',
    },
    'econ': {
      'ru': '📊 Экономика, Финансы, Бизнес, Бухучет',
      'kg': '📊 Экономика, Финансы, Бизнес, Бухгалтерия',
    },
    'law': {
      'ru': '⚖️ Юриспруденция и Международное право',
      'kg': '⚖️ Юриспруденция жана Эл аралык укук',
    },
    'ling': {
      'ru': '🌐 Лингвистика, Переводческое дело, МО',
      'kg': '🌐 Лингвистика, Котормочулук, ЭМК',
    },
    'ped': {
      'ru': '📚 Педагогика и Образование (Учителя)',
      'kg': '📚 Педагогика жана Билим берүү (Мугалимдер)',
    },
  };

  void _calculateChances() {
    FocusScope.of(context).unfocus();

    final mainScore = int.tryParse(_mainScoreController.text.trim()) ?? 0;
    final math = int.tryParse(_mathController.text.trim()) ?? 0;
    final phys = int.tryParse(_physController.text.trim()) ?? 0;
    final chem = int.tryParse(_chemController.text.trim()) ?? 0;
    final bio = int.tryParse(_bioController.text.trim()) ?? 0;
    final eng = int.tryParse(_engController.text.trim()) ?? 0;
    final hist = int.tryParse(_histController.text.trim()) ?? 0;

    if (mainScore <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isKg
                ? 'Негизги тесттин баллын жазыңыз!'
                : 'Пожалуйста, укажите балл основного теста!',
          ),
        ),
      );
      return;
    }

    if (mainScore < 110) {
      setState(() {
        _calculationResult = {
          'status': 'fail',
          'grantChance': '0%',
          'contractChance': '0%',
          'message': widget.isKg
              ? 'Негизги тесттин босого балы (110) өткөн жок. ЖОЖдорго талон таштоого мыйзам боюнча уруксат берилбейт.'
              : 'Основной тест ниже порогового (110 баллов). Подача талонов в высшие учебные заведения КР не разрешена.',
          'bishkekUnis': <String>[],
          'southUnis': <String>[],
          'regionUnis': <String>[],
          'intlUnis': <String>[],
          'advice': widget.isKg
              ? 'Сиз колледждерге (орто кесиптик окуу жайларга) аттестат менен тапшыра аласыз.'
              : 'Вы можете подать документы в колледжи (СПО) по аттестату без ограничений ОРТ.',
        };
      });
      return;
    }

    String status = 'good';
    String grantChance = widget.isKg
        ? '10% - 25% (Төмөн)'
        : '10% - 25% (Низкий)';
    String contractChance = widget.isKg
        ? '90% - 99% (Жогору)'
        : '90% - 99% (Высокий)';
    String warningMessage = '';

    List<String> bishkek = [];
    List<String> south = [];
    List<String> regions = [];
    List<String> intl = [];

    switch (_selectedDirection) {
      case 'it':
        if (math < 60) {
          status = 'warning';
          warningMessage = widget.isKg
              ? 'IT багыттары Математиканы (босого ≥ 60) талап кылат. Математикасыз кабыл алынбайт.'
              : 'Для IT направлений профильная Математика обязательна (порог ≥ 60). Без неё прием невозможен.';
          grantChance = '0%';
          contractChance = '0%';
        } else {
          if (mainScore >= 180 && math >= 80) {
            grantChance = widget.isKg
                ? '85% - 95% (Бюджет кепилдик)'
                : '85% - 95% (Высокий шанс бюджета)';
          } else if (mainScore >= 150) {
            grantChance = widget.isKg
                ? '40% - 60% (Орточо)'
                : '40% - 60% (Средний шанс)';
          }

          bishkek = widget.isKg
              ? [
                  'КМТУ (Политех)',
                  'Ж. Баласагын ат. КУУ',
                  'КРСУ',
                  'КГУСТА (Инженердик ин-т)',
                ]
              : [
                  'КГТУ им. Раззакова (Политех)',
                  'КНУ им. Баласагына',
                  'КРСУ',
                  'КГУСТА (Инженерный ин-т)',
                ];
          south = widget.isKg
              ? [
                  'ОшМУ (MIT факультети)',
                  'ОшТУ (Информатика)',
                  'Б. Осмонов ат. ЖАМУ (ИТ)',
                  'МУНИТ (Жалал-Абад)',
                ]
              : [
                  'ОшГУ (Факультет МИТ)',
                  'ОшТУ (Информатика)',
                  'ЖАГУ им. Осмонова (ИТ)',
                  'МУНИТ (Джалал-Абад)',
                ];
          regions = widget.isKg
              ? [
                  'К. Тыныстанов ат. ЫМУ (Каракол)',
                  'С. Нааматов ат. НМУ (Нарын)',
                  'ТМУ (Талас)',
                  'БатМУ (Кызыл-Кыя)',
                ]
              : [
                  'ИГУ им. Тыныстанова (Каракол)',
                  'НГУ им. Нааматова (Нарын)',
                  'ТГУ (Талас)',
                  'БатГУ (Кызыл-Кыя)',
                ];
          intl = widget.isKg
              ? [
                  'КТУ Манас (Акысыз билим берүү)',
                  'Ала-Тоо (AIU)',
                  'АУЦА (AUCA)',
                  'УЦА (Нарын/UCA)',
                ]
              : [
                  'КТУ Манас (Бесплатное обучение)',
                  'Ала-Тоо (AIU)',
                  'АУЦА (AUCA)',
                  'УЦА (Нарын/UCA)',
                ];
        }
        break;

      case 'med':
        if (chem < 60 || bio < 60) {
          status = 'warning';
          warningMessage = widget.isKg
              ? 'Медицина багытына Химия жана Биология экөө тең 60тан жогору болушу милдеттүү!'
              : 'В медицинские вузы обязательно наличие ДВУХ предметов: Химия (≥60) И Биология (≥60)!';
          grantChance = '0%';
          contractChance = '0%';
        } else {
          if (mainScore >= 195 && chem >= 85 && bio >= 85) {
            grantChance = widget.isKg
                ? '90% (Грант КММА / ОшМУ)'
                : '90% (Грант КГМА / ОшГУ)';
          } else if (mainScore >= 165) {
            grantChance = widget.isKg ? '30% - 40%' : '30% - 40%';
            contractChance = widget.isKg
                ? '95% (Контракт кепилдик)'
                : '95% (Контракт гарантия)';
          } else {
            grantChance = '5%';
            contractChance = widget.isKg ? '75% (Контракт)' : '75% (Контракт)';
          }

          bishkek = widget.isKg
              ? ['И. Ахунбаев ат. КММА', 'КРСУ (Медициналык факультет)']
              : ['КГМА им. И. Ахунбаева', 'КРСУ (Медицинский факультет)'];
          south = widget.isKg
              ? [
                  'ОшМУ (Медициналык факультет)',
                  'Б. Осмонов ат. ЖАМУ (Мед. институту)',
                ]
              : [
                  'ОшГУ (Медицинский факультет)',
                  'ЖАГУ им. Осмонова (Мед. институт)',
                ];
          regions = widget.isKg
              ? [
                  'С. Тентишев ат. АзМИ (Кант)',
                  'Эл аралык Жогорку Медициналык Мектеби (ЭЖММ)',
                ]
              : [
                  'АзМИ им. С. Тентишева (Кант)',
                  'Международная высшая школа медицины (МВШМ)',
                ];
          intl = widget.isKg
              ? ['КТУ Манас', 'Салымбеков Университети']
              : ['КТУ Манас', 'Университет Салымбекова'];
        }
        break;

      case 'eng':
        if (math < 60 && phys < 60) {
          status = 'warning';
          warningMessage = widget.isKg
              ? 'Инженерия үчүн Математика же Физика предмети (босого ≥ 60) керек.'
              : 'Для инженерии требуется Математика или Физика не менее 60 баллов.';
          grantChance = '0%';
          contractChance = '20%';
        } else {
          if (mainScore >= 165) {
            grantChance = widget.isKg
                ? '80% - 90% (Бюджет)'
                : '80% - 90% (Бюджет)';
          }
          bishkek = widget.isKg
              ? [
                  'КМТУ им. Раззаков',
                  'К. Скрябин ат. КУАУ (Гидромелиорация/Агроинженерия)',
                ]
              : [
                  'КГТУ им. Раззакова',
                  'КНАУ им. Скрябина (Гидромелиорация/Агроинженерия)',
                ];
          south = widget.isKg
              ? [
                  'ОшТУ (Курулуш, Энергетика)',
                  'Б. Осмонов ат. ЖАМУ (Тоо-кен жана технология)',
                  'БатМУ',
                ]
              : [
                  'ОшТУ (Строительство, Энергетика)',
                  'ЖАГУ им. Осмонова (Горное дело и технологии)',
                  'БатГУ',
                ];
          regions = widget.isKg
              ? ['ЫМУ (Каракол)', 'НМУ (Нарын)', 'ТМУ (Талас)']
              : ['ИГУ (Каракол)', 'НГУ (Нарын)', 'ТГУ (Талас)'];
          intl = widget.isKg
              ? ['КТУ Манас (Инженерия факультети)']
              : ['КТУ Манас (Инженерный факультет)'];
        }
        break;

      case 'econ':
        if (math < 60) {
          status = 'warning';
          warningMessage = widget.isKg
              ? 'Экономика жана финансы факультеттерине Математика (≥60) талап кылынат.'
              : 'Для факультетов Экономики и Финансов обязательна Математика (≥60).';
          grantChance = '0%';
          contractChance = '40%';
        } else {
          if (mainScore >= 180) {
            grantChance = widget.isKg
                ? '80% - 90% (Бюджет)'
                : '80% - 90% (Бюджет)';
          }
          bishkek = widget.isKg
              ? [
                  'Ж. Баласагын ат. КУУ (Экономика/Финансы)',
                  'К. Карасаев ат. БМУ',
                  'КРСУ',
                  'АДАМ Университети (БФЭА)',
                ]
              : [
                  'КНУ им. Баласагына (Экономика/Финансы)',
                  'БГУ им. Карасаева',
                  'КРСУ',
                  'Университет АДАМ (БФЭА)',
                ];
          south = widget.isKg
              ? [
                  'ОшМУ (Бизнес жана Менеджмент)',
                  'Б. Осмонов ат. ЖАМУ (Экономика жана юриспруденция)',
                  'ОшТУ',
                ]
              : [
                  'ОшГУ (Бизнес и Менеджмент)',
                  'ЖАГУ им. Осмонова (Экономика и право)',
                  'ОшТУ',
                ];
          regions = widget.isKg
              ? ['К. Тыныстанов ат. ЫМУ', 'С. Нааматов ат. НМУ', 'ТМУ', 'БатМУ']
              : ['ИГУ им. Тыныстанова', 'НГУ им. Нааматова', 'ТГУ', 'БатГУ'];
          intl = widget.isKg
              ? ['АУЦА (Бизнес башкаруу)', 'Ала-Тоо (Экономика)', 'КТУ Манас']
              : [
                  'АУЦА (Управление бизнесом)',
                  'Ала-Тоо (Экономика)',
                  'КТУ Манас',
                ];
        }
        break;

      case 'law':
        if (hist < 60) {
          status = 'warning';
          warningMessage = widget.isKg
              ? 'Юриспруденция үчүн Тарых предмети (босого ≥ 60) чоң артыкчылык берет.'
              : 'Для сильных юридических факультетов рекомендуется История (≥60).';
        }
        if (mainScore >= 185) {
          grantChance = widget.isKg
              ? '80% - 90% (Бюджет)'
              : '80% - 90% (Бюджет)';
        }
        bishkek = widget.isKg
            ? ['КУУ Юридикалык институту', 'КРСУ (Юрфак)', 'КМЮА (Юракадемия)']
            : ['КНУ Юридический институт', 'КРСУ (Юрфак)', 'КГЮА (Юракадемия)'];
        south = widget.isKg
            ? ['ОшМУ (Юридикалык факультет)', 'Б. Осмонов ат. ЖАМУ']
            : ['ОшГУ (Юридический факультет)', 'ЖАГУ им. Осмонова'];
        regions = widget.isKg
            ? ['ЫМУ им. Тыныстанова', 'БатМУ']
            : ['ИГУ им. Тыныстанова', 'БатГУ'];
        intl = widget.isKg
            ? ['АУЦА (Эл аралык укук)', 'КТУ Манас']
            : ['АУЦА (Международное право)', 'КТУ Манас'];
        break;

      case 'ling':
        if (eng < 60) {
          status = 'warning';
          warningMessage = widget.isKg
              ? 'Лингвистика жана чет тилдери үчүн Англис тили (≥60) зарыл.'
              : 'Для лингвистики и переводческого дела необходим Английский язык (≥60).';
        }
        bishkek = widget.isKg
            ? ['К. Карасаев ат. БМУ', 'И. Арабаев ат. КМУ', 'КУУ']
            : ['БГУ им. К. Карасаева', 'КГУ им. Арабаева', 'КНУ'];
        south = widget.isKg
            ? [
                'ОшМУ (Дүйнөлүк тилдер факультети)',
                'А. Мырсабеков ат. ОГПУ',
                'ЖАМУ',
              ]
            : [
                'ОшГУ (Факультет мировых языков)',
                'ОГПУ им. Мырсабекова',
                'ЖАГУ',
              ];
        regions = widget.isKg
            ? ['ЫМУ (Тилдер бөлүмү)', 'НМУ', 'ТМУ', 'БатМУ']
            : ['ИГУ (Отделение языков)', 'НГУ', 'ТГУ', 'БатГУ'];
        intl = widget.isKg
            ? [
                'Ала-Тоо (Гуманитардык факультет)',
                'КТУ Манас (Синхрондук котормо)',
              ]
            : [
                'Ала-Тоо (Гуманитарный факультет)',
                'КТУ Манас (Синхронный перевод)',
              ];
        break;

      default:
        if (mainScore >= 150) {
          grantChance = widget.isKg
              ? '80% - 95% (Бюджет)'
              : '80% - 95% (Бюджет)';
        }
        bishkek = widget.isKg
            ? ['И. Арабаев ат. КМУ (Башкы педагогикалык)', 'КУУ', 'БМУ']
            : ['КГУ им. И. Арабаева (Главный педагогический)', 'КНУ', 'БГУ'];
        south = widget.isKg
            ? [
                'А. Мырсабеков ат. ОГПУ (Ош)',
                'ОшМУ',
                'Б. Осмонов ат. ЖАМУ (Педагогика)',
              ]
            : [
                'ОГПУ им. Мырсабекова (Ош)',
                'ОшГУ',
                'ЖАГУ им. Осмонова (Педагогика)',
              ];
        regions = widget.isKg
            ? ['ЫМУ (Каракол)', 'НМУ (Нарын)', 'ТМУ (Талас)', 'БатМУ']
            : ['ИГУ (Каракол)', 'НГУ (Нарын)', 'ТГУ (Талас)', 'БатГУ'];
        intl = widget.isKg
            ? ['КТУ Манас (Педагогика бөлүмү)']
            : ['КТУ Манас (Отделение педагогики)'];
    }

    setState(() {
      _calculationResult = {
        'status': status,
        'grantChance': grantChance,
        'contractChance': contractChance,
        'warningMessage': warningMessage,
        'bishkekUnis': bishkek,
        'southUnis': south,
        'regionUnis': regions,
        'intlUnis': intl,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isKg ? 'Шанстарды эсептөө' : 'Калькулятор шансов'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade100, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: Color(0xFFD32F2F)),
                      const SizedBox(width: 8),
                      Text(
                        widget.isKg
                            ? '1. Негизги тест (Сөзсүз)'
                            : '1. Основной тест (Обязательно)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.isKg
                        ? 'Мамлекеттик босого: 110 балл'
                        : 'Минимальный порог МОиН: 110 баллов',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _mainScoreController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: widget.isKg ? 'Мисалы: 162' : 'Например: 162',
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.edit_note_rounded),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, color: Colors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.isKg
                              ? '2. Предметтик тесттер (Тапшыргандарыңыз)'
                              : '2. Предметные тесты (Только сданные)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.isKg
                        ? 'Ар бир предметтин босогосу — 60 балл. Тапшырбагандарды бош калтырыңыз.'
                        : 'Порог каждого предмета — 60 баллов. Несданные оставьте пустыми.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  _buildSubjectRow('📐 Математика', _mathController),
                  const SizedBox(height: 8),
                  _buildSubjectRow('⚡ Физика', _physController),
                  const SizedBox(height: 8),
                  _buildSubjectRow('🧪 Химия', _chemController),
                  const SizedBox(height: 8),
                  _buildSubjectRow('🧬 Биология', _bioController),
                  const SizedBox(height: 8),
                  _buildSubjectRow(
                    widget.isKg ? '🇬🇧 Англис тили' : '🇬🇧 Английский язык',
                    _engController,
                  ),
                  const SizedBox(height: 8),
                  _buildSubjectRow(
                    widget.isKg ? '📜 Тарых' : '📜 История',
                    _histController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isKg
                        ? '3. Каалаган кесиптик багытыңыз:'
                        : '3. Желаемое направление:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedDirection,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _directions.keys.map((key) {
                      return DropdownMenuItem(
                        value: key,
                        child: Text(
                          widget.isKg
                              ? _directions[key]!['kg']!
                              : _directions[key]!['ru']!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedDirection = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.analytics_rounded),
                label: Text(
                  widget.isKg
                      ? 'Кыргызстан боюнча шанстарды эсептөө'
                      : 'Рассчитать шансы по всем вузам КР',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _calculateChances,
              ),
            ),

            if (_calculationResult != null) ...[
              const SizedBox(height: 24),
              _buildResultCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectRow(String title, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '≥60',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 8,
                ),
                filled: true,
                fillColor: const Color(0xFFF1F3F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    final res = _calculationResult!;
    final isFail = res['status'] == 'fail';
    final isWarning = res['status'] == 'warning';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFail
              ? Colors.red
              : (isWarning ? Colors.orange : Colors.green),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFail
                    ? Icons.cancel_rounded
                    : (isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.verified_rounded),
                color: isFail
                    ? Colors.red
                    : (isWarning ? Colors.orange : Colors.green),
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(
                widget.isKg
                    ? 'Жыйынтык жана ЖОЖдор'
                    : 'Итоги анализа и Вузы КР',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          if (isFail) ...[
            Text(
              res['message'],
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              res['advice'],
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ] else ...[
            if (res['warningMessage'] != null &&
                (res['warningMessage'] as String).isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  res['warningMessage'],
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isKg ? 'Грант (Бюджет):' : 'Грант (Бюджет):',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          res['grantChance'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isKg ? 'Контракт:' : 'Контракт:',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          res['contractChance'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            _buildUniCategory(
              widget.isKg
                  ? '🏛️ Бишкек (Мамлекеттик ЖОЖдор):'
                  : '🏛️ Бишкек (Государственные вузы):',
              res['bishkekUnis'],
            ),
            const SizedBox(height: 12),
            _buildUniCategory(
              widget.isKg
                  ? '☀️ Түштүк аймагы (Ош, Жалал-Абад, Баткен):'
                  : '☀️ Южный регион (Ош, Джалал-Абад, Баткен):',
              res['southUnis'],
            ),
            const SizedBox(height: 12),
            _buildUniCategory(
              widget.isKg
                  ? '🏔️ Түндүк аймактар (Каракол, Нарын, Талас):'
                  : '🏔️ Северные регионы (Каракол, Нарын, Талас):',
              res['regionUnis'],
            ),
            const SizedBox(height: 12),
            _buildUniCategory(
              widget.isKg
                  ? '🌍 Эл аралык & Гранттык ЖОЖдор (Манас, АУЦА ж.б.):'
                  : '🌍 Международные и грантовые вузы (Манас, АУЦА и др.):',
              res['intlUnis'],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUniCategory(String title, List<dynamic> unis) {
    if (unis.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        ...unis.map(
          (u) => Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 2.0),
            child: Text(
              '• $u',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
            ),
          ),
        ),
      ],
    );
  }
}
