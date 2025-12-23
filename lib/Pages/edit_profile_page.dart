import 'package:flutter/material.dart';
import 'package:skillchain/models/user.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onProfileUpdated;

  const EditProfilePage({
    super.key,
    required this.user,
    required this.onProfileUpdated,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  late TextEditingController _educationController;
  late TextEditingController _pastExperienceController;
  late TextEditingController _portfolioLinkController;
  late TextEditingController _resumeController;
  late TextEditingController _ageController;
  late TextEditingController _usernameController;
  late TextEditingController _linkedinController;
  late TextEditingController _githubController;
  late TextEditingController _twitterController;

  String? _selectedGender;
  String? _profilePicUrl;
  List<String> _offeringSkills = [];
  final TextEditingController _skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneNumberController = TextEditingController(text: widget.user.phoneNumber);
    _locationController = TextEditingController(text: widget.user.location);
    _bioController = TextEditingController(text: widget.user.bio ?? '');
    _educationController = TextEditingController(text: widget.user.education ?? '');
    _pastExperienceController = TextEditingController(text: widget.user.pastExperience ?? '');
    _portfolioLinkController = TextEditingController(text: widget.user.portfolioLink);
    _resumeController = TextEditingController(text: widget.user.resume ?? '');
    _ageController = TextEditingController(text: widget.user.age.toString());
    _usernameController = TextEditingController(text: widget.user.username ?? '');
    _linkedinController = TextEditingController(text: widget.user.linkedin ?? '');
    _githubController = TextEditingController(text: widget.user.github ?? '');
    _twitterController = TextEditingController(text: widget.user.twitter ?? '');
    _selectedGender = widget.user.gender;
    _profilePicUrl = widget.user.profilePic;
    _offeringSkills = List.from(widget.user.offeringSkills);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _educationController.dispose();
    _pastExperienceController.dispose();
    _portfolioLinkController.dispose();
    _resumeController.dispose();
    _ageController.dispose();
    _usernameController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _twitterController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    if (_skillController.text.trim().isNotEmpty) {
      setState(() {
        _offeringSkills.add(_skillController.text.trim());
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _offeringSkills.remove(skill);
    });
  }

  void _saveProfile() {
    // Validate required fields
    if (_fullNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneNumberController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _portfolioLinkController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final age = int.tryParse(_ageController.text.trim());
    if (age == null || age < 1 || age > 150) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid age"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create updated user
    final updatedUser = UserModel(
      id: widget.user.id,
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: widget.user.password, // Keep existing password
      age: age,
      gender: _selectedGender!,
      location: _locationController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      portfolioLink: _portfolioLinkController.text.trim(),
      verified: widget.user.verified,
      bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
      profilePic: _profilePicUrl,
      education: _educationController.text.trim().isEmpty ? null : _educationController.text.trim(),
      offeringSkills: _offeringSkills,
      pastExperience: _pastExperienceController.text.trim().isEmpty
          ? null
          : _pastExperienceController.text.trim(),
      resume: _resumeController.text.trim().isEmpty ? null : _resumeController.text.trim(),
      timeCoins: widget.user.timeCoins,
      subscriptionPackage: widget.user.subscriptionPackage,
      ratings: widget.user.ratings,
      reviews: widget.user.reviews,
      status: widget.user.status,
      earnedCertificates: widget.user.earnedCertificates,
      myOffers: widget.user.myOffers,
      username: _usernameController.text.trim().isEmpty ? null : _usernameController.text.trim(),
      posts: widget.user.posts,
      donations: widget.user.donations,
      connections: widget.user.connections,
      linkedin: _linkedinController.text.trim().isEmpty ? null : _linkedinController.text.trim(),
      github: _githubController.text.trim().isEmpty ? null : _githubController.text.trim(),
      twitter: _twitterController.text.trim().isEmpty ? null : _twitterController.text.trim(),
    );

    widget.onProfileUpdated(updatedUser);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.purple.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: _saveProfile,
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade400,
                          Colors.purple.shade400,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _profilePicUrl != null && _profilePicUrl!.isNotEmpty
                              ? NetworkImage(_profilePicUrl!)
                              : null,
                          child: _profilePicUrl == null || _profilePicUrl!.isEmpty
                              ? const Icon(Icons.person, size: 60, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.blue.shade600,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                onPressed: () {
                                  _showImageUrlDialog();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      _showImageUrlDialog();
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text(
                      "Change Photo",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Required Fields Section
            _buildSectionTitle("Required Information", Icons.info_outline, Colors.blue),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _fullNameController,
              label: "Full Name *",
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: "Email *",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneNumberController,
              label: "Phone Number *",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _locationController,
              label: "Location *",
              icon: Icons.location_on,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _portfolioLinkController,
              label: "Portfolio Link *",
              icon: Icons.link,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _ageController,
                    label: "Age *",
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: "Gender *",
                        prefixIcon: Icon(Icons.people, color: Colors.blue.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Optional Fields Section
            _buildSectionTitle("Additional Information", Icons.description, Colors.purple),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _bioController,
              label: "Bio",
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _educationController,
              label: "Education",
              icon: Icons.school,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _pastExperienceController,
              label: "Past Experience",
              icon: Icons.work,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _resumeController,
              label: "Resume Link",
              icon: Icons.description,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _usernameController,
              label: "Username (max 15 chars)",
              icon: Icons.alternate_email,
              maxLength: 15,
            ),
            const SizedBox(height: 24),

            // Offering Skills Section
            _buildSectionTitle("Offering Skills", Icons.stars, Colors.orange),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _skillController,
                      decoration: InputDecoration(
                        labelText: "Add a skill",
                        prefixIcon: Icon(Icons.add_circle_outline, color: Colors.blue.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onSubmitted: (_) => _addSkill(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.purple.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addSkill,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_offeringSkills.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _offeringSkills.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.purple.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          skill,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _removeSkill(skill),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),

            // Social Links Section
            _buildSectionTitle("Social Links", Icons.share, Colors.green),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _linkedinController,
              label: "LinkedIn",
              icon: Icons.business,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _githubController,
              label: "GitHub",
              icon: Icons.code,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _twitterController,
              label: "Twitter",
              icon: Icons.alternate_email,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 32),

            // Save Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade600,
                    Colors.purple.shade600,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        ),
      ),
    );
  }

  void _showImageUrlDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final urlController = TextEditingController(text: _profilePicUrl ?? '');
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text("Update Profile Picture"),
            ],
          ),
          content: TextField(
            controller: urlController,
            decoration: InputDecoration(
              hintText: "Enter image URL",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _profilePicUrl = urlController.text.trim().isEmpty
                      ? null
                      : urlController.text.trim();
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

