// main_new.dart - The entry point for my Flutter portfolio application.

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:kmk_portfolio/src/shared/webColors.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  // Runs the Flutter application, starting with the MyApp widget.
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Title for the browser tab or app switcher.
      title: 'Kaung Myat Kyaw - Flutter Developer',
      // Define the light theme for the application.
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // A good primary color for a professional look.
        visualDensity: VisualDensity.adaptivePlatformDensity, // Adapts UI density based on platform.
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0D1B2A), // Replace with your desired color
          elevation: 0,
        ),
        //fontFamily: 'BebasNeue', // Using 'Inter' for a modern look (ensure you add it to pubspec.yaml).
      ),
      // Define the dark theme.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        hintColor: Colors.tealAccent, // A contrasting accent color for dark theme.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0D1B2A), // Replace with your desired color
          elevation: 0,
        ),
        //fontFamily: 'BebasNeue',
      ),
      themeMode: ThemeMode.system,
      // Set the initial route to the PortfolioPage.
      home: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: PortfolioPage(),
      ),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey skillsKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  @override
  void initState(){
    super.initState();

  }

  @override
  void dispose() {
    _scrollController.dispose(); // Always dispose
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive design.
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // The main background color for the Scaffold.
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[100] : WebColors.scaffoldDarkBackgroundColor,
      // AppBar for the portfolio, appearing at the top.
      appBar: AppBar(
        title: Text(
          'Kaung Myat Kyaw', // Replace with your actual name
          style: TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 32,
            color: Theme.of(context).appBarTheme.foregroundColor ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : WebColors.primaryDarkTextColor),
          ),
        ),
        centerTitle: false, // Align title to the left.
        elevation: 0, // No shadow for a flat, modern look.
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : WebColors.scaffoldDarkBackgroundColor,
        actions: [
          // Navigation links in the app bar for larger screens.
          if (screenSize.width > 600) ...[
            _AppBarButton(text: 'Projects', onPressed: () { _scrollToSection(projectsKey); }, context: context),
            _AppBarButton(text: 'Skills', onPressed: () { _scrollToSection(skillsKey); }, context: context),
            _AppBarButton(text: 'About', onPressed: () { _scrollToSection(aboutKey); }, context: context),
            _AppBarButton(text: 'Contact', onPressed: () { _scrollToSection(contactKey); }, context: context),
          ],
          const SizedBox(width: 20),
        ],
      ),
      // SingleChildScrollView allows the content to be scrollable if it exceeds screen height.
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          //physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: Align(
            alignment: Alignment.topCenter, // Center the content horizontally.
            child: Container(
              // Max width for content to keep it readable on very wide screens.
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start (left).
                children: [
                  // Intro Seciton
                  _IntroSection(onContactPressed: (){ _scrollToSection(contactKey); }),
                  _buildDivider(context),

                  // Projects Section
                  Container(
                    key: projectsKey,
                    child: _ProjectsSection(),
                  ),
                  _buildDivider(context),

                  // Skills Section
                  Container(
                    key: skillsKey,
                    child: _SkillsSection(),
                  ),
                  _buildDivider(context),

                  // About Me Section
                  Container(
                    key: aboutKey,
                    child: _AboutMeSection(),
                  ),
                  _buildDivider(context),

                  // Contact Section
                  Container(
                    key: contactKey,
                    child: ContactFormSection(),
                  ),
                  const SizedBox(height: 40,),
                  Divider(
                    color: Color(0xFF484848), // Line color
                    thickness: 1,       // Line thickness
                    height: 0,         // Space above and below the line
                  ),

                  // Footer Section
                  FooterSection(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context){
    return Divider(
      color: Color(0xFF484848),
      thickness: 1,
      height: 80,
    );
  }

}

// A simple button for the App Bar.
class _AppBarButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final BuildContext context; // Pass context to access theme.

  const _AppBarButton({
    required this.text,
    required this.onPressed,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : WebColors.primaryDarkTextColor,
          fontSize: 16,
        ),
      ),
    );
  }
}

// --- Portfolio Sections ---

class _IntroSection extends StatelessWidget {
  _IntroSection({required this.onContactPressed});
  final VoidCallback onContactPressed;

  final ValueNotifier<bool> _hovering = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust layout based on screen width.
        if (constraints.maxWidth > 700) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildIntroContent(context, constraints)),
              const SizedBox(width: 60),
              // Placeholder for your profile picture.
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://i.imgur.com/FM7agKE.jpeg',
                  width: 500,
                  height: 600,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child; // Image loaded

                    return Container(
                      width: 500,
                      height: 600,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: WebColors.hoverColor,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: const CupertinoActivityIndicator(radius: 18),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        height: 500,
                        width: 600,
                        color: Colors.grey[300],
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Icon(Icons.broken_image, size: 100, color: Colors.grey[600]),
                      ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildIntroContent(context, constraints),
              const SizedBox(height: 64),
              // Placeholder for your profile picture.
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://i.imgur.com/FM7agKE.jpeg',
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child; // Image loaded

                    return Container(
                      width: double.infinity,
                      height: 400,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: WebColors.hoverColor,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: const CupertinoActivityIndicator(radius: 18),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        height: 400,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                      ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildIntroContent(BuildContext context, BoxConstraints constraints){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HI, I AM',
          style: TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: constraints.maxWidth > 700 ? 101 : 57,
            fontWeight: FontWeight.w400,
            height: constraints.maxWidth > 700 ? 0.9 : 1, // 90%
            color: Theme.of(context).textTheme.headlineSmall?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[700] : WebColors.titleDarkColor),
          ),
        ),
        //const SizedBox(height: 10),
        Text(
          'KAUNG MYAT KYAW.',
          style: TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: constraints.maxWidth > 700 ? 101 : 57,
            fontWeight: FontWeight.w400,
            height: constraints.maxWidth > 700 ? 0.9 : 1, // 90%
            color: Theme.of(context).textTheme.bodyLarge?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : WebColors.titleDarkColor),
          ),
        ),
        const SizedBox(height: 8),
        // Add more details like "What I do" or "My Philosophy" here.
        Text(
          'A Yangon based mobile app developer passionate about building accessible and user friendly mobile app.',
          style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              fontSize: constraints.maxWidth > 700 ? 18 : 16,
              height: constraints.maxWidth > 700 ? 1.5 : 1.6,
              color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xFFC7C7C7)
          ),
        ),
        const SizedBox(height: 40),
        _buildIntroButtons(context, constraints),
        if (kIsWeb)   // Web only button
          const SizedBox(height: 40),
        if (kIsWeb)  // Web only button
          _buildPDFViewButton(context, constraints),
      ],
    );
  }

  Widget _buildPDFViewButton(BuildContext context, BoxConstraints constraints){
    return ElevatedButton.icon(
      icon: Icon(Icons.picture_as_pdf, color: Colors.white), // white icon
      label: Text(
        "View Resume",
        style: TextStyle(
            fontFamily: 'ManropeBold',
            color: Colors.white
        ), // white text
      ),
      onPressed: () async {
        final url = Uri.parse('assets/resume/resume_2025.pdf');
        if (!await launchUrl(url)) {
          if(context.mounted){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not launch $url')),
            );
          }
        }
        log('Opening Resume Link: $url');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // transparent background
        elevation: 0,
        foregroundColor: WebColors.primaryColor, // ripple effect
        shadowColor: Colors.grey, // remove shadow
        side: BorderSide(color: WebColors.primaryColor, width: 1.5),
        minimumSize: Size(constraints.maxWidth > 700 ? 187 : 164, constraints.maxWidth > 700 ? 58 : 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildIntroButtons(BuildContext context, BoxConstraints constraints){
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16.0,  //horizontally
      runSpacing: 12.0,
      children: [
        _buildContactButton(context, constraints),
        GestureDetector(
          onTap: () async {
            final linkedInUrl = "https://www.linkedin.com/in/kaung-myat-kyaw-1b04641b5";
            final Uri url = Uri.parse(linkedInUrl);
            if (!await launchUrl(url)) {
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $linkedInUrl')),
                );
              }
            }
            log('Opening Linkedin Link: $linkedInUrl');
          },
          child: ClipOval(
            child: Container(
              width: constraints.maxWidth > 700 ? 54 : 48,
              height: constraints.maxWidth > 700 ? 54 : 48,
              color: WebColors.hoverColor,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logos/Vector.png',
                width: 25, // Adjust size as needed
                height: 25,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final gitHubUrl = "https://github.com/Kaung-Myat-Kyaw-xxl";
            final Uri url = Uri.parse(gitHubUrl);
            if (!await launchUrl(url)) {
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $gitHubUrl')),
                );
              }
            }
            log('Opening GitHub Link: $gitHubUrl');
          },
          child: ClipOval(
            child: Container(
              width: constraints.maxWidth > 700 ? 54 : 48,
              height: constraints.maxWidth > 700 ? 54 : 48,
              color: WebColors.hoverColor,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logos/bxl-github.png',
                width: 28, // Adjust size as needed
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContactButton(BuildContext context, BoxConstraints constraints){
    return MouseRegion(
      onEnter: (_) => _hovering.value = true,
      onExit: (_) => _hovering.value = false,
      cursor: SystemMouseCursors.click,
      child: ValueListenableBuilder<bool>(
        valueListenable: _hovering,
        builder: (context, isHovered, _) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: onContactPressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                constraints: BoxConstraints(minHeight: constraints.maxWidth > 700 ? 54 : 48, minWidth: constraints.maxWidth > 700 ? 187 : 164),
                padding: const EdgeInsets.only(left: 16, right: 5),
                decoration: BoxDecoration(
                  color: isHovered
                      ? WebColors.primaryHoverColor
                      : WebColors.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: isHovered
                      ? [
                    BoxShadow(
                      color: Color.fromRGBO(158, 158, 158, 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 8),
                    ),
                  ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CONTACT ME',
                      style: TextStyle(
                        fontFamily: 'ManropeBold',
                        fontSize: constraints.maxWidth > 700 ? 16 : 14,
                        color: Color(0xFF0A0A0A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: constraints.maxWidth > 700 ? 46 : 40,
                      height: constraints.maxWidth > 700 ? 46 : 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Icon(
                        Icons.north_east,
                        color: Colors.white,
                        size: constraints.maxWidth > 700 ? 24 : 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AboutMeSection extends StatelessWidget {
  const _AboutMeSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust layout based on screen width.
        if (constraints.maxWidth > 700) {
          return Padding(
            padding: const EdgeInsets.only(top: 100.0, bottom: 200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for your profile picture.
                Text(
                  'ABOUT ME', // Replace with your actual name
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 101,
                    fontWeight: FontWeight.w400,
                    height: 0.9,
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Color(0xFFFFFFFF),
                  ),
                ),
                const SizedBox(width: 213),
                Expanded(child: _buildAboutMeContent(context)),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for your profile picture.
                Text(
                  'ABOUT ME', // Replace with your actual name
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 43,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -2,
                    height: 0.9,
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Color(0xFFFFFFFF),
                  ),
                ),
                const SizedBox(height: 30),
                _buildAboutMeContent(context),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildAboutMeContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am a mobile app developer based in Yangon, Myanmar(Burma). Has Marine Engineering Technology background. ', // Replace with your actual name
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 32,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[700] : Color(0xFFFFFFFF),
          ),
        ),
        const SizedBox(height: 35),
        Text(
          'I am a Senior mobile Developer with 5+ years of experience crafting high-performance, scalable, and intuitive mobile and web applications. My expertise lies in designing robust architectures, leading development teams, and optimizing app performance across various platforms. I am passionate about creating clean, maintainable code and delivering exceptional user experiences.',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Color(0xFFC7C7C7),
          ),
        ),
        const SizedBox(height: 20),
        // Add more details like "What I do" or "My Philosophy" here.
        Text(
          'My core focus includes state management (BLoC, Provider, GetX and RiverPod), clean architecture, testing, and integrating with diverse backend services. I thrive in collaborative environments, mentoring junior developers, and pushing the boundaries of what\'s possible with Flutter.',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Color(0xFFC7C7C7),
          ),
        ),
      ],
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection();

  @override
  Widget build(BuildContext context) {
    // Define your skills. You can categorize them further.
    final List<String> coreSkills = [
      'Flutter & Dart', 'State Management (BLoC, RiverPod, Provider and GetX)',
      'Clean Architecture', 'Unit & Widget Testing', 'Firebase/Firestore',
      'RESTFul APIs', 'Git/Version Control', 'Performance Optimization',
      'Responsive UI Design', 'CI/CD Principles', 'SQL/SQFLite Databases'
    ];
    final List<String> softSkills = [
      'Team Leadership', 'Mentoring', 'Problem-Solving',
      'Communication', 'Agile Methodologies', 'Code Review'
    ];

    return LayoutBuilder(
      builder: (context, constraints){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SKILL",
              style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: constraints.maxWidth > 700 ? 76 : 43,
                letterSpacing: constraints.maxWidth > 700 ? 0 : -2,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFFFFFFFF),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technical Expertise',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.headlineSmall?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[700] : Colors.blueGrey[200]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSkillChips(context, coreSkills),
                    const SizedBox(height: 40),
                    Text(
                      'Professional Skills',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.headlineSmall?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[700] : Colors.blueGrey[200]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSkillChips(context, softSkills),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper to build a wrap of skill chips.
  Widget _buildSkillChips(BuildContext context, List<String> skills) {
    return Wrap(
      spacing: 8.0, // horizontal spacing between chips
      runSpacing: 8.0, // vertical spacing between lines of chips
      children: skills.map((skill) => Chip(
        label: Text(skill),
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[100] : Colors.blueGrey[700],
        labelStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Colors.white,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      )).toList(),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection();

  @override
  Widget build(BuildContext context) {
    // Define your portfolio projects here.
    // Each project should highlight your senior-level contributions.
    final List<Map<String, String>> projects = [
      {
        'title': 'E-commerce Mobile App (Neo Shopping)',
        'description': 'Introduction our feature-rich e-commerce app, Neo Shopping, designed to revolutionize your shopping experience. Discover a vast array of products across diverse categories, ranging from fashion to home appliances and more.You can explore, compare and purchase items with ease with out app.',
        'technologies': 'Flutter, Dart, Firebase (Firestore, Auth), Provider, REST API, Unit Testing',
        'image': 'https://i.imgur.com/S1vuY5O.png', // Placeholder image
        'github_link': 'https://github.com/yourusername/ecommerce_app', // Replace with your GitHub link
        'live_link': 'https://play.google.com/store/apps/details?id=com.mit.app092&pcampaignid=web_share',
      },
      {
        'title': 'GlobalHR Cloud App',
        'description': 'GlobalHR is the one solution to manage complex and multiple shifts.Auto shift assignment, leave, absent, overtime control functions will assist you in your daily attendance tracking. GlobalHR can be extended as Employee Self Service Portal by Cloud Version',
        'technologies': 'Flutter, Dart, BloC (Cubit), MVVM Pattern, Clean Architecture, Integration Testing',
        'image': 'https://i.imgur.com/U6kvyKl.png', // Placeholder image
        'github_link': 'https://github.com/yourusername/task_manager',
        'live_link': 'https://play.google.com/store/apps/details?id=com.globalwave.globalta&pcampaignid=web_share',
      },
      {
        'title': 'SDLite (Distribution App)',
        'description': 'SD Lite is a sales and distribution mobile app which works as an extension of ERP system.It helps you to manage your business efficiently as it can schedule each salesperson route for selected customer area in advance.Major sales and distribution functions like sales order, delivery, invoice, return and cash collection are able to create while you are online or offline.Moreover, useful inventory features like ground stock taking, inventory adjustment, transfer request and damage are included.',
        'technologies': 'Flutter, Dart, Provider ',
        'image': 'https://i.imgur.com/cQmRJVO.png', // Placeholder image
        'github_link': 'https://github.com/yourusername/flutter_animations_lib',
        'live_link': 'https://play.google.com/store/apps/details?id=com.mit.sdlitemit&pcampaignid=web_share',
      },
      {
        'title': 'Max Energy Galaxy Club',
        'description': 'Rewards, Update Daily Fuel Prices and more.This application is designed to collect Reward Stars for our member customers when fuelling at our Max Energy Fuel Stations by scanning QR codes from purchase vouchers and enjoying member promotions and gifts.',
        'technologies': 'Xamarin(MAUI), C#, MVVM Pattern, Integration Testing',
        'image': 'https://i.imgur.com/LC2K7cs.png', // Placeholder image
        'github_link': 'https://github.com/yourusername/task_manager',
        'live_link': 'https://play.google.com/store/apps/details?id=com.maxenergy.galaxyclub&pcampaignid=web_share',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
            builder: (context, constraints){
              return Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'FEATURED PROJECTS', // Title
                              style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: constraints.maxWidth > 700 ? 76 : 43,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: constraints.maxWidth > 700 ? 0.0 : -2,
                                  color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Color(0xFFFFFFFF)
                              )
                          ),
                          SizedBox(height: 8),
                          Text(
                              'Here are some of the selected projects that showcase my passion for cross platform mobile development.', // Subtitle
                              style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: constraints.maxWidth > 700 ? 18 : 16,
                                  height: 1.5,
                                  color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Color(0xFFC7C7C7)
                              )
                          ),
                          SizedBox(height: constraints.maxWidth > 700 ? 80 : 50),
                        ],
                      )
                  ),
                  if(constraints.maxWidth > 700)
                    Expanded(
                        flex: 1,
                        child: SizedBox()
                    )
                ],
              );
            }
        ),
        // Spacing before list

        // The ListView builder
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _ProjectCard(
              title: project['title']!,
              description: project['description']!,
              technologies: project['technologies']!,
              imageUrl: project['image']!,
              githubLink: project['github_link']!,
              liveLink: project['live_link']!,
            );
          },
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String technologies;
  final String imageUrl;
  final String githubLink;
  final String liveLink;

  const _ProjectCard({
    required this.title,
    required this.description,
    required this.technologies,
    required this.imageUrl,
    required this.githubLink,
    required this.liveLink,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use responsive layout for project cards.
            if (constraints.maxWidth > 700) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05), // Very transparent glass color
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 126),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const CupertinoActivityIndicator(radius: 18),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 600,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.broken_image, size: 80, color: Colors.grey[600]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 48, top: 60, bottom: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 32,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFFFFFFFF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            description,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Color(0xFFC7C7C7),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Technologies',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xFFFFFFFF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildProjectTechChips(context, convertStringToList(technologies)),
                          const SizedBox(height: 48),
                          _buildProjectButtons(context),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05), // Very transparent glass color
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 126),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;

                                return Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const CupertinoActivityIndicator(radius: 18),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 400,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.broken_image, size: 80, color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 24,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Color(0xFFC7C7C7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Technologies',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProjectTechChips(context, convertStringToList(technologies)),
                  const SizedBox(height: 30),
                  _buildProjectButtons(context),
                  const SizedBox(height: 50),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // Helper to build project action buttons.
  Widget _buildProjectButtons(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: [
        ElevatedButton.icon(
          onPressed: liveLink.isNotEmpty ? () async {

            final Uri url = Uri.parse(liveLink);
            if (!await launchUrl(url)) {
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $liveLink')),
                );
              }
            }
            log('Opening Live Link: $liveLink');
          }
              : null, // Disable button if link is empty.
          icon: const Icon(Icons.link, color: Color(0xFFD3E97A),),
          label: const Text('View Live'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // transparent background
            elevation: 0,
            foregroundColor: WebColors.primaryColor, // ripple effect
            shadowColor: Colors.grey, // remove shadow
            side: BorderSide(color: WebColors.primaryColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  // Helper to build a wrap of project tech chips.
  Widget _buildProjectTechChips(BuildContext context, List<String> skills) {
    return Wrap(
      spacing: 8.0, // horizontal spacing between chips
      runSpacing: 8.0, // vertical spacing between lines of chips
      children: skills.map((skill) => Chip(
        label: Text(skill),
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[100] : Colors.blueGrey[700],
        labelStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Colors.white,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      )).toList(),
    );
  }

  List<String> convertStringToList(dynamic tech) {
    if (tech is String) {
      return tech.split(',').map((e) => e.trim()).toList();
    } else if (tech is List<String>) {
      return tech;
    }
    return []; // fallback if null or unexpected type
  }

}

class ContactFormSection extends StatefulWidget {
  const ContactFormSection({super.key});

  @override
  State<ContactFormSection> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSending = false;

  Future<void> sendEmail() async {
    const serviceId = 'service_b5qcv2s';
    const templateId = 'template_dpkbwfb';
    const publicKey = 'SlUlCt7tudL42vNcm';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'from_name': _nameController.text,
            'from_email': _emailController.text,
            'subject': _subjectController.text,
            'message': _messageController.text,
          },
        }),
      );

      if (response.statusCode == 200) {
        if(mounted){
          log('Email sent response: ${response.statusCode}, ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email sent successfully!')),
          );
        }
        _formKey.currentState?.reset();
      } else {
        log('EmailJS Error: ${response.statusCode}, ${response.body}');
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send email.')),
          );
        }
      }
    } catch (e) {
      log('EmailJS Exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exception occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          if(constraints.maxWidth > 700){
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LET'S CONNECT",
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 76,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFFFFFFFF),
                        ),
                      ),
                      const SizedBox(height: 16,),

                      _buildRichText(context, constraints, 'Say hello at ', 'kaungmyatkyaw.xxl@gmail.com', true),
                      const SizedBox(height: 8,),

                      _buildRichText(context, constraints, 'For more info, here\'s my ', 'resume', false),
                      const SizedBox(height: 40),

                      _buildContactButtons(context)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _buildContactForm(context),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "LET'S CONNECT",
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 43,
                    letterSpacing: -2,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFFFFFFFF),
                  ),
                ),
                const SizedBox(height: 16,),

                _buildRichText(context, constraints, 'Say hello at ', 'kaungmyatkyaw.xxl@gmail.com', true),
                const SizedBox(height: 8,),

                _buildRichText(context, constraints, 'For more info, here\'s my ', 'resume', false),
                const SizedBox(height: 40),

                _buildContactButtons(context),
                const SizedBox(height: 60,),

                _buildContactForm(context),
              ],
            );
          }
        }
    );
  }

  Widget _buildRichText(BuildContext context, BoxConstraints constraints, String normalText, String linkText, bool isEmail){
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: constraints.maxWidth > 700 ? 18 : 16,
          height: constraints.maxWidth > 700 ? 1.5 : 1.6,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.blueGrey[800]
              : Color(0xFFC7C7C7),
        ),
        children: [
          TextSpan(text: normalText),
          TextSpan(
            text: linkText,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: constraints.maxWidth > 700 ? 18 : 16,
              height: constraints.maxWidth > 700 ? 1.5 : 1.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFFFFFFFF), // Link color
              decoration: TextDecoration.underline,
              decorationColor: WebColors.primaryColor, // 👈 underline color
              decorationThickness: 2,           // 👈 thickness of the underline
              decorationStyle: TextDecorationStyle.solid, // dashed/dotted/solid
            ),
            recognizer: TapGestureRecognizer()..onTap = () async {
              late Uri uri;
              if(isEmail){
                uri = Uri(scheme: 'mailto', path: 'kaungmyatkyaw.xxl@gmail.com',);
              }else{
                uri = Uri.parse('assets/resume/resume_2025.pdf');
              }

              if (!await launchUrl(uri)) {
                if(context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch link!')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm(BuildContext context){
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey), // default color
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: WebColors.primaryColor, width: 2), // color when focused
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFFC7C7C7),
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _nameController,
            decoration: inputDecoration,
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          Text('Email',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFFC7C7C7),
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _emailController,
            decoration: inputDecoration,
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          Text('Subject',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFFC7C7C7),
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _subjectController,
            decoration: inputDecoration,
          ),
          const SizedBox(height: 16),
          Text('Message',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFFC7C7C7),
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _messageController,
            decoration: inputDecoration,
            maxLines: 10,
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: WebColors.primaryColor, // your light green color
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: _isSending ? null : () async {
              if (_formKey.currentState?.validate() ?? false) {
                setState(() => _isSending = true);
                await sendEmail();
                setState(() => _isSending = false);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: _isSending ? CupertinoActivityIndicator() : Text('SUBMIT',
                style: TextStyle(
                  fontFamily: 'ManropeBold',
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Color(0xFF0A0A0A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButtons(BuildContext context){
    final List<Map<String, String>> iconItems = [
      {
        'icon': 'assets/logos/bxl-github.png',
        'url': 'https://github.com/Kaung-Myat-Kyaw-xxl',
      },
      {
        'icon': 'assets/logos/bxl-linkedin.png',
        'url': 'https://www.x.com/',
      },
      {
        'icon': 'assets/logos/bxl-instagram.png',
        'url': 'https://www.instagram.com/kaung_myat_xxl/',
      },
      {
        'icon': 'assets/logos/Vector.png',
        'url': 'https://www.linkedin.com/in/kaung-myat-kyaw-1b04641b5',
      },
    ];

    return Wrap(
      spacing: 24.0,
      runSpacing: 12.0,
      children: List.generate(iconItems.length, (index) {
        final icon = iconItems[index]['icon']!;
        final url = iconItems[index]['url']!;

        return IconButton(
          onPressed: () async {
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else {
              log('Could not launch $url');
            }
          },
          icon: Image.asset(icon, height: 32, width: 32,),
        );
      }),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: isDark ? Colors.transparent : Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            '© ${DateTime.now().year} Kaung Myat Kyaw',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
