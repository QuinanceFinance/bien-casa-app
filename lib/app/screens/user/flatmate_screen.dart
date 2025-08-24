import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/flatmate/survey/flatmate_survey.dart';
import 'widgets/flatmate/home/flatmate_app_bar.dart';
import 'widgets/flatmate/home/flatmate_filter_section.dart';
import 'widgets/flatmate/home/match_card_section.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class FlatmateScreen extends StatefulWidget {
  const FlatmateScreen({super.key});

  @override
  State<FlatmateScreen> createState() => _FlatmateScreenState();
}

class _FlatmateScreenState extends State<FlatmateScreen> {
  bool _isFirstTime = true;
  bool _isLoading = true;
  int _currentIndex = 1; // Set to 1 for Flatmate tab

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedSurvey =
        prefs.getBool('flatmate_survey_completed') ?? false;

    setState(() {
      _isFirstTime = !hasCompletedSurvey;
      _isLoading = false;
    });
  }

  Future<void> _markSurveyCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('flatmate_survey_completed', true);

    setState(() {
      _isFirstTime = false;
    });
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // App bar with SVG icons
          const FlatmateAppBar(),

          // Filter section with tabs
          const FlatmateFilterSection(),

          // Match card section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Match card section
                  const MatchCardSection(),

                  // Reset button for testing (at bottom)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool(
                            'flatmate_survey_completed',
                            false,
                          );
                          setState(() {
                            _isFirstTime = true;
                          });
                        },
                        child: const Text('Reset Survey (For Testing)'),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Always use Scaffold with bottom nav bar
    return Scaffold(
      backgroundColor: Colors.white,

      body:
          _isFirstTime
              ? FlatmateSurvey(onSurveyComplete: _markSurveyCompleted)
              : _buildMainContent(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate to the appropriate screen based on the index
          if (index == 0) {
            // Home tab - use offAllNamed to prevent back button
            Get.offAllNamed('/user-home');
          }

          // We're already on the Flatmate tab (index 1), so no navigation needed
          // Add other navigation options as needed for other tabs
        },
      ),
    );
  }
}
