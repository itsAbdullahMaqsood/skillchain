import 'package:flutter/material.dart';
import 'package:skillchain/models/user.dart';
import 'package:skillchain/Widgets/profile_widgets.dart';
import 'package:skillchain/Pages/profile/edit_profile_page.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  final bool isCurrentUser;
  final ValueChanged<UserModel>? onProfileUpdated;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.isCurrentUser,
    this.onProfileUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _updateProfile(UserModel updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });
    widget.onProfileUpdated?.call(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              ProfileHeader(user: _currentUser),
              const SizedBox(height: 24),
              ProfileStatsRow(user: _currentUser),
              const SizedBox(height: 20),
              ProfileInfoSection(user: _currentUser),
              const SizedBox(height: 16),
              ProfileProfessionalSection(user: _currentUser),
              const SizedBox(height: 16),
              ProfileLinksSection(user: _currentUser),
              if (widget.isCurrentUser) ...[
                const SizedBox(height: 24),
                ProfileActionButtons(
                  onEditProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          user: _currentUser,
                          onProfileUpdated: _updateProfile,
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
