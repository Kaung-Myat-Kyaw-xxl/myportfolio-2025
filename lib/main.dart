// main.dart - The entry point for your Flutter portfolio application.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  // Runs the Flutter application, starting with the MyApp widget.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // MyApp is the root widget of your application.
  // It sets up the MaterialApp, which provides basic app functionality like navigation and theming.
  const MyApp({super.key});

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
        fontFamily: 'Inter', // Using 'Inter' for a modern look (ensure you add it to pubspec.yaml).
      ),
      // Define the dark theme.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        hintColor: Colors.tealAccent, // A contrasting accent color for dark theme.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      // Set the initial route to the PortfolioPage.
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  // PortfolioPage contains the main structure and sections of your portfolio.
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive design.
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // The main background color for the Scaffold.
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[100] : Colors.grey[900],
      // AppBar for the portfolio, appearing at the top.
      appBar: AppBar(
        title: Text(
          'Kaung Myat Kyaw', // Replace with your actual name
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false, // Align title to the left.
        elevation: 0, // No shadow for a flat, modern look.
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[850],
        actions: [
          // Navigation links in the app bar for larger screens.
          if (screenSize.width > 600) ...[
            _AppBarButton(text: 'About', onPressed: () {/* Scroll to About */}, context: context),
            _AppBarButton(text: 'Skills', onPressed: () {/* Scroll to Skills */}, context: context),
            _AppBarButton(text: 'Projects', onPressed: () {/* Scroll to Projects */}, context: context),
            _AppBarButton(text: 'Contact', onPressed: () {/* Scroll to Contact */}, context: context),
          ],
          // Add a theme toggle button.
          // IconButton(
          //   icon: Icon(
          //     Theme.of(context).brightness == Brightness.light ? Icons.dark_mode : Icons.light_mode,
          //     color: Theme.of(context).appBarTheme.foregroundColor ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white),
          //   ),
          //   onPressed: () {
          //     // TODO: Implement theme toggling logic (e.g., using Provider or Riverpod for state management).
          //     // For now, this is a placeholder. You'd typically wrap MyApp in a StatefulWidget
          //     // or use a state management solution to change the theme dynamically.
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Theme toggle functionality to be implemented!')),
          //     );
          //   },
          // ),
          const SizedBox(width: 20),
        ],
      ),
      // SingleChildScrollView allows the content to be scrollable if it exceeds screen height.
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter, // Center the content horizontally.
          child: Container(
            // Max width for content to keep it readable on very wide screens.
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start (left).
              children: [
                // About Me Section
                _buildSectionTitle(context, 'About Me'),
                _AboutMeSection(),
                const SizedBox(height: 40),

                // Skills Section
                _buildSectionTitle(context, 'Skills'),
                _SkillsSection(),
                const SizedBox(height: 40),

                // Projects Section
                _buildSectionTitle(context, 'Projects'),
                _ProjectsSection(),
                const SizedBox(height: 40),

                // Contact Section
                _buildSectionTitle(context, 'Contact'),
                _ContactSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to create consistent section titles.
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.headlineMedium?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white),
        ),
      ),
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
          color: Theme.of(context).appBarTheme.foregroundColor ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// --- Portfolio Sections ---

class _AboutMeSection extends StatelessWidget {
  const _AboutMeSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust layout based on screen width.
            if (constraints.maxWidth > 700) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for your profile picture.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      'https://i.imgur.com/H5h1sR8.jpeg', // Replace with your image URL
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(Icons.person, size: 80, color: Colors.grey[600]),
                          ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: _buildAboutMeContent(context)),
                ],
              );
            } else {
              return Column(
                children: [
                  // Placeholder for your profile picture.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      'https://i.imgur.com/H5h1sR8.jpeg', // Replace with your image URL
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAboutMeContent(context),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAboutMeContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, I\'m Kaung Myat Kyaw!', // Replace with your actual name
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headlineSmall?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[700] : Colors.blueGrey[200]),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'I am a Senior mobile Developer with 5+ years of experience crafting high-performance, scalable, and intuitive mobile and web applications. My expertise lies in designing robust architectures, leading development teams, and optimizing app performance across various platforms. I am passionate about creating clean, maintainable code and delivering exceptional user experiences.',
          style: TextStyle(
            fontSize: 18,
            height: 1.5,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white70),
          ),
        ),
        const SizedBox(height: 16),
        // Add more details like "What I do" or "My Philosophy" here.
        Text(
          'My core focus includes state management (BLoC, Provider, GetX and RiverPod), clean architecture, testing, and integrating with diverse backend services. I thrive in collaborative environments, mentoring junior developers, and pushing the boundaries of what\'s possible with Flutter.',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Theme.of(context).textTheme.bodyMedium?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white60),
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

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technical Expertise:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineSmall?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[700] : Colors.blueGrey[200]),
              ),
            ),
            const SizedBox(height: 10),
            _buildSkillChips(context, coreSkills),
            const SizedBox(height: 20),
            Text(
              'Professional Skills:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineSmall?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[700] : Colors.blueGrey[200]),
              ),
            ),
            const SizedBox(height: 10),
            _buildSkillChips(context, softSkills),
          ],
        ),
      ),
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
        'live_link': 'https://your-live-demo.com/ecommerce', // Replace with your live demo link (if any)
      },
      {
        'title': 'GlobalHR Cloud App',
        'description': 'GlobalHR is the one solution to manage complex and multiple shifts.Auto shift assignment, leave, absent, overtime control functions will assist you in your daily attendance tracking. GlobalHR can be extended as Employee Self Service Portal by Cloud Version',
        'technologies': 'Flutter, Dart, BloC (Cubit), MVVM Pattern, Clean Architecture, Integration Testing',
        'image': 'https://i.imgur.com/U6kvyKl.png', // Placeholder image
        'github_link': 'https://github.com/yourusername/task_manager',
        'live_link': '', // No live link or replace with your live demo link
      },
      {
        'title': 'SDLite (Distribution App)',
        'description': 'SD Lite is a sales and distribution mobile app which works as an extension of ERP system.It helps you to manage your business efficiently as it can schedule each salesperson route for selected customer area in advance.Major sales and distribution functions like sales order, delivery, invoice, return and cash collection are able to create while you are online or offline.Moreover, useful inventory features like ground stock taking, inventory adjustment, transfer request and damage are included.',
        'technologies': 'Flutter, Dart, Provider ',
        'image': 'https://i.imgur.com/cQmRJVO.png', // Placeholder image
        'github_link': 'https://github.com/yourusername/flutter_animations_lib',
        'live_link': 'https://your-live-demo.com/animations',
      },
      {
        'title': 'Max Energy Galaxy Club',
        'description': 'Rewards, Update Daily Fuel Prices and more.This application is designed to collect Reward Stars for our member customers when fuelling at our Max Energy Fuel Stations by scanning QR codes from purchase vouchers and enjoying member promotions and gifts.',
        'technologies': 'Xamarin(MAUI), C#, MVVM Pattern, Integration Testing',
        'image': 'https://i.imgur.com/LC2K7cs.png', // Placeholder image
        'github_link': 'https://github.com/yourusername/task_manager',
        'live_link': '', // No live link or replace with your live demo link
      },
    ];

    return ListView.builder(
      shrinkWrap: true, // Important for nested scroll views.
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling of this list itself.
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
    );
  }
}

// Custom widget to display a single project card.
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
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use responsive layout for project cards.
            if (constraints.maxWidth > 700) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headlineMedium?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Colors.blueGrey[100]),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Theme.of(context).textTheme.bodyLarge?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Technologies: $technologies',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).textTheme.bodySmall?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white60),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildProjectButtons(context),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: Icon(Icons.broken_image, size: 80, color: Colors.grey[600]),
                            ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: Icon(Icons.broken_image, size: 60, color: Colors.grey[600]),
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineMedium?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[800] : Colors.blueGrey[100]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Theme.of(context).textTheme.bodyLarge?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Technologies: $technologies',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.bodySmall?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white60),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProjectButtons(context),
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
          onPressed: githubLink.isNotEmpty
              ? () {
            // TODO: Implement URL launching (add url_launcher package).
            // For now, print to console.
            log('Opening GitHub: $githubLink');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Would open GitHub: $githubLink')),
            );
          }
              : null, // Disable button if link is empty.
          icon: const Icon(Icons.code),
          label: const Text('View Code'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        if (liveLink.isNotEmpty)
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement URL launching.
              log('Opening Live Demo: $liveLink');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Would open Live Demo: $liveLink')),
              );
            },
            icon: const Icon(Icons.link),
            label: const Text('Live Demo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineSmall?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[700] : Colors.blueGrey[200]),
              ),
            ),
            const SizedBox(height: 15),
            _buildContactInfo(context, Icons.email, 'kaungmyatkyaw.xxl@gmail.com', 'mailto:kaungmyatkyaw.xxl@gmail.com?subject=Your%20Subject&body=Contact%20Me...'),
            _buildContactInfo(context, Icons.link, 'LinkedIn Profile', 'https://www.linkedin.com/in/kaung-myat-kyaw-1b04641b5'),
            _buildContactInfo(context, Icons.code, 'GitHub Profile', 'https://github.com/Kaung-Myat-Kyaw-xxl'),
            // Add more contact methods like Twitter, personal website etc.
          ],
        ),
      ),
    );
  }

  // Helper to build contact information rows.
  Widget _buildContactInfo(BuildContext context, IconData icon, String text, String? url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: url != null
            ? () async {
          // TODO: Implement URL launching (add url_launcher package).
          final Uri _url = Uri.parse(url);
          log('Opening URL: $_url');
          if (!await launchUrl(_url)) {
          //throw Exception('Could not launch $_url');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not launch $url')),
            );
          }
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Would open: $url')),
          // );
        }
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Keep row compact.
            children: [
              Icon(icon, size: 28, color: Theme.of(context).primaryColor),
              const SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyLarge?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white70),
                  decoration: url != null ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
