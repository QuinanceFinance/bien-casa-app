import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flatmate/survey/flatmate_survey.dart';
import 'flatmate/home/_widgets/flatmate_app_bar.dart';
import 'flatmate/home/_widgets/flatmate_filter_section.dart';
import 'flatmate/home/_widgets/match_card_section.dart';
import 'flatmate/home/_widgets/available_flats_section.dart';
import 'flatmate/home/_widgets/available_campaigns_section.dart';
import 'flatmate/home/_pages/flatmates.dart';
import 'flatmate/home/_pages/flats_page.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../controllers/flatmate_match_controller.dart';

class FlatmateScreen extends StatefulWidget {
  const FlatmateScreen({super.key});

  @override
  State<FlatmateScreen> createState() => _FlatmateScreenState();
}

class _FlatmateScreenState extends State<FlatmateScreen> {
  bool _isFirstTime = true;
  bool _isLoading = true;
  int _currentIndex = 1; // Set to 1 for Flatmate tab
  int _selectedTabIndex = 0; // 0 for Hot tab (default), 1 for Flatmates, etc.

  @override
  void initState() {
    super.initState();
    // Initialize FlatmateMatchController if not already initialized
    if (!Get.isRegistered<FlatmateMatchController>()) {
      Get.put(FlatmateMatchController());
    }
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
          FlatmateFilterSection(
            initialTabIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),

          // Content based on selected tab
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  // Build content based on selected tab
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0: // Hot tab
        return SingleChildScrollView(
          child: Column(
            children: [
              // Match card section for Hot tab
              const MatchCardSection(),

              // Available flats section
              AvailableFlatsSection(
                onViewAllTap: () {
                  setState(() {
                    _selectedTabIndex = 2; // Switch to Flats tab
                  });
                },
              ),
              
              // Available campaigns section
              AvailableCampaignsSection(
                onViewAllTap: () {
                  setState(() {
                    _selectedTabIndex = 1; // Switch to Flatmates tab
                  });
                },
              ),

              // Reset button for testing (at bottom)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('flatmate_survey_completed', false);
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
        );
      case 1: // Flatmates tab
        return const Flatmates();
      case 2: // Flats tab
        return const FlatsPage();
      case 3: // Short-stay tab
        return const Center(child: Text('Short-stay Coming Soon'));
      default:
        return const MatchCardSection();
    }
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
