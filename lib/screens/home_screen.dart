import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'math_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isKg = false; // false = Русский, true = Кыргызча
  int _currentNavIndex = 0;

  Map<String, String> get _t => _isKg
      ? {
          'lang': 'Кыргызча',
          'heroTitle': 'Салам, Абитуриент!',
          'heroSub': 'ЖРТ жана Кыргызстандын ЖОЖдоруна тапшыруу боюнча сенин жеке AI кеңешчиң.',
          'heroScore': '🎯 Босого баллдар: Негизги 110 | Предмет. 60',
          'heroDays': '⏳ ЖРТга калды: 145 күн',
          'sections': 'Бөлүмдөр',
          'all': 'Баары',
          'cardAi': 'AI Кеңешчи',
          'cardAiSub': 'Тьютор менен баарлашуу',
          'cardUniv': 'Тапшыруу',
          'cardUnivSub': 'Мүмкүнчүлүк эсеби',
          'cardTask': 'Маселе чыгаруу',
          'cardTaskSub': 'Сүрөт жана талдоо',
          'cardDocs': 'Документтер',
          'cardDocsSub': 'Талондор жана эрежелер',
          'dailyTask': 'AI-Күндүн тапшырмасы',
          'dailyTaskSub': 'Математикадан деңгээл боюнча маселе чыгар...',
          'navHome': 'Башкы',
          'navChat': 'Чат AI',
          'navTests': 'Тесттер',
          'navDocs': 'Документтер',
          'navProfile': 'Профиль',
        }
      : {
          'lang': 'Русский',
          'heroTitle': 'Привет, Абитуриент!',
          'heroSub':
              'Твой персональный AI-помощник по ОРТ и поступлению в вузы КР.',
          'heroScore': '🎯 Пороговые баллы: Осн. 110 | Предмет. 60',
          'heroDays': '⏳ До ОРТ осталось: 145 дней',
          'sections': 'Разделы',
          'all': 'Все',
          'cardAi': 'AI Консультант',
          'cardAiSub': 'Чат с тьютором',
          'cardUniv': 'Поступление',
          'cardUnivSub': 'Калькулятор шансов',
          'cardTask': 'Решить задачу',
          'cardTaskSub': 'Фото с разбором',
          'cardDocs': 'Документы',
          'cardDocsSub': 'Талоны и правила',
          'dailyTask': 'AI-Задание дня',
          'dailyTaskSub': 'Реши задачи по математике по уровням...',
          'navHome': 'Главная',
          'navChat': 'Чат AI',
          'navTests': 'Тесты',
          'navDocs': 'Документы',
          'navProfile': 'Профиль',
        };

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(isKg: _isKg)),
    );
  }

  void _openMathTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MathTasksScreen(isKg: _isKg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
              child: _buildTopBar(),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroBanner(),
                    const SizedBox(height: 22),
                    _buildSectionHeader(),
                    const SizedBox(height: 14),
                    _buildGridSection(),
                    const SizedBox(height: 14),
                    _buildDailyTaskBanner(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFE5253A),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40E5253A),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.wb_sunny_rounded,
                  color: Color(0xFFFFD54F),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'EduKG AI',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E242B),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E9F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<bool>(
              value: _isKg,
              isDense: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Colors.black87,
              ),
              items: const [
                DropdownMenuItem(
                  value: false,
                  child: Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        size: 16,
                        color: Color(0xFF5A6981),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Русский',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        size: 16,
                        color: Color(0xFF5A6981),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Кыргызча',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _isKg = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFEA263B), Color(0xFFBD1426)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4DE5243B),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 10,
            top: -10,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _t['heroTitle']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _t['heroSub']!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12.5,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 86,
                      height: 94,
                      child: AkKalpakRobotHero(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      const Text('🎯', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _t['heroScore']!.replaceAll('🎯 ', ''),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _t['heroDays']!,
                      style: const TextStyle(
                        color: Color(0xFF1E242B),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _t['sections']!,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E242B),
          ),
        ),
        Text(
          '${_t['all']!} →',
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF758295),
          ),
        ),
      ],
    );
  }

  Widget _buildGridSection() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: [
        _buildCard(
          title: _t['cardAi']!,
          subtitle: _t['cardAiSub']!,
          gradient: const [Color(0xFF8CEEC7), Color(0xFF60DEAB)],
          iconBadge: Icons.smart_toy_rounded,
          isDarkText: true,
          artWidget: const AkKalpakRobotIcon(size: 46),
          onTap: _openChat,
        ),
        _buildCard(
          title: _t['cardUniv']!,
          subtitle: _t['cardUnivSub']!,
          gradient: const [Color(0xFF4C6CFE), Color(0xFF3353EA)],
          iconBadge: Icons.school_rounded,
          isDarkText: false,
          artWidget: const ChartGradCapArt(size: 48),
          onTap: _openMathTasks,
        ),
        _buildCard(
          title: _t['cardTask']!,
          subtitle: _t['cardTaskSub']!,
          gradient: const [Color(0xFFFFCF68), Color(0xFFFFB53B)],
          iconBadge: Icons.camera_alt_rounded,
          isDarkText: true,
          artWidget: const ScannerLensArt(size: 48),
          onTap: _openChat,
        ),
        _buildCard(
          title: _t['cardDocs']!,
          subtitle: _t['cardDocsSub']!,
          gradient: const [Color(0xFF905EE9), Color(0xFF743FE0)],
          iconBadge: Icons.assignment_rounded,
          isDarkText: false,
          artWidget: const ClipboardStampArt(size: 48),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required IconData iconBadge,
    required bool isDarkText,
    required Widget artWidget,
    required VoidCallback onTap,
  }) {
    final titleColor = isDarkText ? const Color(0xFF1E242B) : Colors.white;
    final subColor = isDarkText
        ? const Color(0xFF4A5568)
        : Colors.white.withOpacity(0.85);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: isDarkText
                        ? Colors.black.withOpacity(0.08)
                        : Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    iconBadge,
                    size: 17,
                    color: isDarkText ? Colors.black87 : Colors.white,
                  ),
                ),
                artWidget,
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTaskBanner() {
    return InkWell(
      onTap: _openMathTasks,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEBF1FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t['dailyTask']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: Color(0xFF1E242B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _t['dailyTaskSub']!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF6B7A90),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const AkKalpakRobotIcon(size: 34),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEFF2F6), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: const Color(0xFFEA263B),
        unselectedItemColor: const Color(0xFF9AA6B8),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 1) _openChat();
          if (index == 2) _openMathTasks();
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: _t['navHome']!,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: _t['navChat']!,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book_rounded),
            label: _t['navTests']!,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.folder_outlined),
            label: _t['navDocs']!,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            label: _t['navProfile']!,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// ВЕКТОРНАЯ 3D-ГРАФИКА
// -------------------------------------------------------------

class AkKalpakRobotHero extends StatelessWidget {
  const AkKalpakRobotHero({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _AkKalpakRobotHeroPainter());
  }
}

class _AkKalpakRobotHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE2EAF4), Color(0xFFBDCEDB)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(cx - 24, 62, 48, 30));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 22, 60, 44, 28),
        const Radius.circular(14),
      ),
      bodyPaint,
    );

    final strapPaint = Paint()
      ..color = const Color(0xFFFF9800)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 15, 60), Offset(cx - 18, 86), strapPaint);
    canvas.drawLine(Offset(cx + 15, 60), Offset(cx + 18, 86), strapPaint);

    final headRect = Rect.fromLTWH(cx - 27, 28, 54, 38);
    final headPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFD4E6FA), Color(0xFF88B3E3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(headRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(headRect, const Radius.circular(16)),
      headPaint,
    );

    final earPaint = Paint()..color = const Color(0xFF6B99CE);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 31, 38, 5, 16),
        const Radius.circular(3),
      ),
      earPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 26, 38, 5, 16),
        const Radius.circular(3),
      ),
      earPaint,
    );

    final faceRect = Rect.fromLTWH(cx - 21, 34, 42, 26);
    final facePaint = Paint()..color = const Color(0xFF0F1E36);
    canvas.drawRRect(
      RRect.fromRectAndRadius(faceRect, const Radius.circular(12)),
      facePaint,
    );

    final eyePaint = Paint()..color = const Color(0xFF26E5FF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 15, 41, 10, 8),
        const Radius.circular(4),
      ),
      eyePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 5, 41, 10, 8),
        const Radius.circular(4),
      ),
      eyePaint,
    );

    final smilePaint = Paint()
      ..color = const Color(0xFF26E5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(cx - 4, 52)
      ..quadraticBezierTo(cx, 55, cx + 4, 52);
    canvas.drawPath(smilePath, smilePaint);

    final kalpakPath = Path()
      ..moveTo(cx - 24, 28)
      ..lineTo(cx - 14, 5)
      ..quadraticBezierTo(cx, 1, cx + 14, 5)
      ..lineTo(cx + 24, 28)
      ..close();

    final kalpakPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFE2E7ED)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(cx - 24, 1, 48, 28));
    canvas.drawPath(kalpakPath, kalpakPaint);

    final brimPaint = Paint()
      ..color = const Color(0xFF1E242B)
      ..style = PaintingStyle.fill;
    final brimPath = Path()
      ..moveTo(cx - 26, 28)
      ..lineTo(cx + 26, 28)
      ..lineTo(cx + 24, 33)
      ..lineTo(cx - 24, 33)
      ..close();
    canvas.drawPath(brimPath, brimPaint);

    final patternPaint = Paint()
      ..color = const Color(0xFF1E242B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final ornamentPath = Path()
      ..moveTo(cx, 8)
      ..lineTo(cx, 22)
      ..moveTo(cx - 6, 15)
      ..quadraticBezierTo(cx - 3, 11, cx, 15)
      ..quadraticBezierTo(cx + 3, 11, cx + 6, 15);
    canvas.drawPath(ornamentPath, patternPaint);

    canvas.drawCircle(
      Offset(cx, 3),
      2,
      Paint()..color = const Color(0xFF1E242B),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AkKalpakRobotIcon extends StatelessWidget {
  final double size;
  const AkKalpakRobotIcon({super.key, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _AkKalpakRobotIconPainter()),
    );
  }
}

class _AkKalpakRobotIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final headPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE2EAF8), Color(0xFF9BBFEA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(cx - 18, cy - 6, 36, 26));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 18, cy - 6, 36, 26),
        const Radius.circular(10),
      ),
      headPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 14, cy - 2, 28, 18),
        const Radius.circular(7),
      ),
      Paint()..color = const Color(0xFF0F1E36),
    );

    final eyePaint = Paint()..color = const Color(0xFF26E5FF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 10, cy + 2, 7, 5),
        const Radius.circular(2),
      ),
      eyePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 3, cy + 2, 7, 5),
        const Radius.circular(2),
      ),
      eyePaint,
    );

    final kalpakPath = Path()
      ..moveTo(cx - 16, cy - 6)
      ..lineTo(cx - 9, cy - 22)
      ..quadraticBezierTo(cx, cy - 25, cx + 9, cy - 22)
      ..lineTo(cx + 16, cy - 6)
      ..close();
    canvas.drawPath(kalpakPath, Paint()..color = Colors.white);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 18, cy - 7, 36, 4),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF1E242B),
    );

    final pPaint = Paint()
      ..color = const Color(0xFF1E242B)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx, cy - 21), Offset(cx, cy - 8), pPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ChartGradCapArt extends StatelessWidget {
  final double size;
  const ChartGradCapArt({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ChartGradCapPainter()),
    );
  }
}

class _ChartGradCapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 14, 28, 28),
        const Radius.circular(8),
      ),
      Paint()..color = Colors.white.withOpacity(0.9),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(6, 28, 5, 10),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF4C6CFE),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(13, 22, 5, 16),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFFF9800),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(20, 18, 5, 20),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF00C853),
    );

    final capPath = Path()
      ..moveTo(34, 4)
      ..lineTo(48, 11)
      ..lineTo(34, 18)
      ..lineTo(20, 11)
      ..close();
    canvas.drawPath(capPath, Paint()..color = const Color(0xFF1A237E));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(27, 14, 14, 6),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF101750),
    );

    canvas.drawCircle(
      const Offset(34, 11),
      1.8,
      Paint()..color = const Color(0xFFFFD54F),
    );
    final tassel = Path()
      ..moveTo(34, 11)
      ..lineTo(42, 16)
      ..lineTo(41, 22);
    canvas.drawPath(
      tassel,
      Paint()
        ..color = const Color(0xFFFFD54F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScannerLensArt extends StatelessWidget {
  final double size;
  const ScannerLensArt({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ScannerLensPainter()),
    );
  }
}

class _ScannerLensPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final framePaint = Paint()
      ..color = const Color(0xFFE65100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      Path()
        ..moveTo(6, 12)
        ..lineTo(6, 6)
        ..lineTo(12, 6),
      framePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(34, 6)
        ..lineTo(40, 6)
        ..lineTo(40, 12),
      framePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(6, 30)
        ..lineTo(6, 36)
        ..lineTo(12, 36),
      framePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(34, 36)
        ..lineTo(40, 36)
        ..lineTo(40, 30),
      framePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(11, 9, 24, 24),
        const Radius.circular(5),
      ),
      Paint()..color = Colors.white.withOpacity(0.9),
    );
    final linePaint = Paint()
      ..color = const Color(0xFFFFB74D)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(15, 15), const Offset(29, 15), linePaint);
    canvas.drawLine(const Offset(15, 20), const Offset(25, 20), linePaint);

    final lensCenter = const Offset(34, 30);
    canvas.drawCircle(
      lensCenter,
      9,
      Paint()..color = const Color(0xFF80DEEA).withOpacity(0.8),
    );
    canvas.drawCircle(
      lensCenter,
      9,
      Paint()
        ..color = const Color(0xFF0097A7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawLine(
      const Offset(40, 36),
      const Offset(46, 42),
      Paint()
        ..color = const Color(0xFFE65100)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ClipboardStampArt extends StatelessWidget {
  final double size;
  const ClipboardStampArt({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ClipboardStampPainter()),
    );
  }
}

class _ClipboardStampPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(8, 6, 26, 34),
        const Radius.circular(6),
      ),
      Paint()..color = Colors.white,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(16, 3, 10, 5),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFFFCA28),
    );

    final checkPaint = Paint()
      ..color = const Color(0xFF4C6CFE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final y = 14.0 + (i * 7);
      canvas.drawLine(Offset(12, y), Offset(14, y + 2), checkPaint);
      canvas.drawLine(Offset(14, y + 2), Offset(17, y - 2), checkPaint);
      canvas.drawLine(Offset(20, y), Offset(29, y), linePaint);
    }

    final stampHandle = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(34, 22, 6, 12),
        const Radius.circular(2),
      ),
      stampHandle,
    );
    canvas.drawCircle(
      const Offset(37, 36),
      7,
      Paint()..color = const Color(0xFF4E342E),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
