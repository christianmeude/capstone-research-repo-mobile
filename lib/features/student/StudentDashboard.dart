import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/services/user_service.dart';
import '../../core/services/api_service.dart';
import '../auth/Landing.dart';
import '../research/BrowseRepository.dart';
import '../research/MyResearch.dart';
import '../research/SubmitResearch.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await UserService.getUserProfile();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Log Out", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (shouldLogout == true) {
      await ApiService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Landing()), (route) => false);
    }
  }

  // --- PAGES (Now 4 Tabs) ---
  List<Widget> get _pages => [
    const BrowseRepository(),                // 0: Browse
    const Center(child: Text("Search")),     // 1: Search
    const MyResearch(),                      // 2: My Papers
    const Center(child: Text("Analytics")),  // 3: Analytics (Restored!)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 70,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: GestureDetector(
            onTap: () {
               // Profile Menu Logic (Simplified for brevity)
               // You can paste the _showProfileMenu function here from previous steps if needed
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary500,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary500.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Center(
                child: _isLoading 
                  ? const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                  : Text(_currentUser?.initials ?? "?", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isLoading ? "..." : "Hello, ${_currentUser?.name.split(' ')[0] ?? 'User'}!", style: AppTextStyles.heading4.copyWith(fontSize: 18)),
            Text("BSIT-MWA", style: AppTextStyles.bodyXSmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          IconButton(onPressed: _handleLogout, icon: const Icon(Icons.logout, color: Colors.grey)), // Quick Logout for now
          const SizedBox(width: 10),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: Colors.grey[100], height: 1)),
      ),

      body: _pages[_currentIndex],

      floatingActionButton: _currentIndex == 0 ? FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmitResearch())),
        backgroundColor: AppColors.primary500,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Submit"),
      ) : null,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: AppColors.primary500,
          unselectedItemColor: AppColors.textLight,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Browse'),
            BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_shared_rounded), label: 'My Papers'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Analytics'), // Tab 4
          ],
        ),
      ),
    );
  }
}