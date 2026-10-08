import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  final bool isKg;
  const DocumentsScreen({super.key, required this.isKg});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _checklist = [
    {
      'title_ru': 'Паспорт (ID-карта) или свидетельство о рождении',
      'title_kg': 'Паспорт (ID-карта) же туулгандыгы тууралуу күбөлүк',
      'desc_ru': 'Оригинал + 2-3 цветные или четкие копии',
      'desc_kg': 'Түп нускасы + 2-3 так көчүрмөсү',
      'checked': false,
    },
    {
      'title_ru': 'Аттестат о среднем образовании (11 класс)',
      'title_kg': 'Орто билим тууралуу аттестат (11-класс)',
      'desc_ru': 'Оригинал аттестата сдаётся в вуз при подтверждении',
      'desc_kg': 'Түп нускасы ЖОЖго тастыктоо учурунда тапшырылат',
      'checked': false,
    },
    {
      'title_ru': 'Сертификат Общереспубликанского тестирования (ОРТ)',
      'title_kg': 'Жалпы республикалык тестирлөөнүн (ЖРТ) сертификаты',
      'desc_ru': 'Бумажный сертификат с отрывными талонами и баллами',
      'desc_kg': 'Баллдары жана талондору бар кагаз сертификат',
      'checked': false,
    },
    {
      'title_ru': 'Медицинская справка формы 086-У',
      'title_kg': '086-У үлгүсүндөгү медициналык маалымкат',
      'desc_ru': 'Флюорография жана дарыгерлердин корутундусу менен',
      'desc_kg': 'Флюорография жана дарыгерлердин текшерүүсү менен',
      'checked': false,
    },
    {
      'title_ru': 'Цветные фотографии 3х4 см (4-6 штук)',
      'title_kg': '3х4 өлчөмүндөгү түстүү сүрөттөр (4-6 даана)',
      'desc_ru': 'Для личного дела, зачетной книжки и студенческого билета',
      'desc_kg': 'Өздүк дело, зачеттук китепче жана студенттик билет үчүн',
      'checked': false,
    },
    {
      'title_ru': 'Приписное свидетельство или военный билет',
      'title_kg': 'Аскердик каттоо күбөлүгү (приписное) же аскер билети',
      'desc_ru': 'Обязательно для парней и юношей призывного возраста',
      'desc_kg': 'Аскер курагындагы уландар үчүн сөзсүз талап кылынат',
      'checked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final readyCount = _checklist
        .where((item) => item['checked'] == true)
        .length;
    final totalCount = _checklist.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isKg ? 'Документтер жана Талондор' : 'Документы и Талоны',
        ),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFD32F2F),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xFFD32F2F),
          tabs: [
            Tab(
              icon: const Icon(Icons.checklist_rounded),
              text: widget.isKg ? 'Чек-лист' : 'Чек-лист',
            ),
            Tab(
              icon: const Icon(Icons.how_to_reg_rounded),
              text: widget.isKg ? 'Талон эрежеси' : 'Туры & Талоны',
            ),
            Tab(
              icon: const Icon(Icons.warning_amber_rounded),
              text: widget.isKg ? 'Кеңештер' : 'Ошибки',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.purple,
                        radius: 24,
                        child: Text(
                          '$readyCount/$totalCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isKg
                                  ? 'Документтердин даярдыгы'
                                  : 'Готовность документов',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              readyCount == totalCount
                                  ? (widget.isKg
                                        ? '🎉 Бардык документтер даяр! ЖОЖго тапшырсаңыз болот.'
                                        : '🎉 Все документы готовы к подаче в приёмную комиссию!')
                                  : (widget.isKg
                                        ? 'Даяр болгон документтерди белгилеңиз.'
                                        : 'Отмечайте собранные документы галочками.'),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(_checklist.length, (index) {
                  final item = _checklist[index];
                  final isChecked = item['checked'] as bool;
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isChecked
                            ? Colors.green.shade300
                            : Colors.grey.shade200,
                        width: isChecked ? 1.5 : 1,
                      ),
                    ),
                    color: isChecked
                        ? Colors.green.shade50.withOpacity(0.4)
                        : Colors.white,
                    child: CheckboxListTile(
                      activeColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      value: isChecked,
                      onChanged: (val) {
                        setState(() {
                          item['checked'] = val;
                        });
                      },
                      title: Text(
                        widget.isKg ? item['title_kg'] : item['title_ru'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : null,
                          color: isChecked
                              ? Colors.grey.shade700
                              : Colors.black87,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          widget.isKg ? item['desc_kg'] : item['desc_ru'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isChecked
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(
                  icon: Icons.public_rounded,
                  color: Colors.blue,
                  title: widget.isKg
                      ? 'Онлайн кабыл алуу порталы: 2020.edu.gov.kg'
                      : 'Портал онлайн-поступления: 2020.edu.gov.kg',
                  body: widget.isKg
                      ? 'Кыргызстандагы бардык ЖОЖдорго талон таштоо бирдиктүү мамлекеттик автоматташтырылган система аркылуу онлайн жүргүзүлөт. Эч жакка барбай эле телефондон тапшырасыз.'
                      : 'Приём в вузы КР осуществляется строго через единую автоматизированную систему МОиН КР. Подача талонов происходит дистанционно со смартфона или компьютера.',
                ),
                const SizedBox(height: 14),
                _buildRoundCard(
                  roundNum: '1',
                  title: widget.isKg
                      ? '1-ТУР (Июль айынын башы)'
                      : '1-Й ТУР (Начало июля)',
                  details: widget.isKg
                      ? [
                          'Бюджетке (грантка) жана контракка негизги талондорду таштоо.',
                          'Ар бир абитуриент гранттык жана контракттык орундарга өзүнчө талон таштай алат.',
                          'Рейтинг автоматтык түрдө баллдардын бийиктигине жараша түзүлөт.',
                        ]
                      : [
                          'Основной этап для распределения государственных грантов и контракта.',
                          'Абитуриент может зарегистрировать талоны одновременно на грант и контракт.',
                          'Списки формируются автоматически по наивысшему баллу ОРТ.',
                        ],
                ),
                const SizedBox(height: 12),
                _buildRoundCard(
                  roundNum: '!',
                  isWarning: true,
                  title: widget.isKg
                      ? 'ЭҢ МААНИЛҮҮСҮ: ТАСТЫКТОО (ПОДТВЕРЖДЕНИЕ)'
                      : 'ГЛАВНОЕ ПРАВИЛО: ПОДТВЕРЖДЕНИЕ МЕСТА',
                  details: widget.isKg
                      ? [
                          'Эгер система сизди сунуштаса, белгиленген мөөнөткө чейин порталдан "ТАСТЫКТАЙМ" баскычын басуу керек!',
                          'Эгер тастыктабай калсаңыз, ордуңуз жокко чыгарылып, кийинки абитуриентке өтүп кетет.',
                        ]
                      : [
                          'Если система рекомендовала вас к зачислению, необходимо подтвердить желание учиться в личном кабинете до дедлайна!',
                          'Если вовремя не нажать "Подтвердить" и не сдать оригинал аттестата — место сгорает навсегда.',
                        ],
                ),
                const SizedBox(height: 12),
                _buildRoundCard(
                  roundNum: '2-3',
                  title: widget.isKg
                      ? '2-жана 3-ТУРЛАР (Бош калган орундар)'
                      : '2-Й И 3-Й ТУРЫ (Оставшиеся места)',
                  details: widget.isKg
                      ? [
                          '1-турда ээлебей калган гранттык жана контракттык орундарга кайра сынак өтөт.',
                          'Биринчи турда өтпөй калгандар же башка ЖОЖду тандагысы келгендер катышат.',
                        ]
                      : [
                          'Конкурс на вакантные грантовые и контрактные места, не закрытые в 1-м туре.',
                          'Шанс для тех, кто не прошел с первого раза или решил сменить направление.',
                        ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMistakeCard(
                  title: widget.isKg
                      ? '1. Телефон номерин же сырсөздү унутуп калуу'
                      : '1. Потеря сим-карты или пароля от кабинета',
                  desc: widget.isKg
                      ? 'Порталга катталууда колдонгон номерди жоготпоңуз. Коддор жана зачисление боюнча SMS билдирүүлөр ошол номерге келет.'
                      : 'Используйте только личный активный номер телефона. Все SMS-коды подтверждения и результаты приходят именно на него.',
                ),
                const SizedBox(height: 10),
                _buildMistakeCard(
                  title: widget.isKg
                      ? '2. Босого балл жетпеген ЖОЖго талон таштоо'
                      : '2. Подача талона с баллом ниже порогового',
                  desc: widget.isKg
                      ? 'Эгер негизги тест 110дон аз же керектүү предмет 60тан аз болсо, талон таштоого мүмкүн эмес. Талон жөн эле күйүп кетет.'
                      : 'Если основной балл < 110 или предметный < 60, система отклонит заявку. Внимательно проверяйте пороги вуза.',
                ),
                const SizedBox(height: 10),
                _buildMistakeCard(
                  title: widget.isKg
                      ? '3. Сунушталган ЖОЖду убагында тастыктабоо'
                      : '3. Опоздание с подтверждением зачисления',
                  desc: widget.isKg
                      ? 'ЖОЖго сунушталгандан кийин болгону 2-3 күн берилет. Күн сайын порталды текшерип туруу шарт.'
                      : 'На подтверждение места даётся строгий лимит (обычно до 17:00 третьего дня). Проверяйте статус ежедневно.',
                ),
                const SizedBox(height: 10),
                _buildMistakeCard(
                  title: widget.isKg
                      ? '4. Аттестаттын түп нускасын (оригинал) тапшырбоо'
                      : '4. Задержка с подачей оригинала аттестата',
                  desc: widget.isKg
                      ? 'Онлайн тастыктагандан кийин ЖОЖдун кабыл алуу комиссиясына аттестаттын түп нускасын алып барып берүү милдеттүү.'
                      : 'После онлайн-подтверждения оригинал школьного аттестата должен быть передан в приемную комиссию вуза.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundCard({
    required String roundNum,
    required String title,
    required List<String> details,
    bool isWarning = false,
  }) {
    final cardColor = isWarning ? Colors.red : Colors.teal;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWarning ? Colors.red.shade300 : Colors.grey.shade200,
          width: isWarning ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: cardColor,
                child: Text(
                  roundNum,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isWarning ? Colors.red.shade800 : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...details.map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      color: cardColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      d,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMistakeCard({required String title, required String desc}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
