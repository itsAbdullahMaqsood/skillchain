import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:skillchain/core/network/api_exception.dart';
import 'package:skillchain/core/storage/token_storage.dart';
import 'package:skillchain/models/signup_models.dart';
import 'package:skillchain/Pages/home/home_shell.dart';
import 'package:skillchain/services/auth_service.dart';
import 'package:skillchain/services/signup_api_service.dart';

/// Screen 3: Full profile signup (multipart). On success saves tokens and navigates to Home.
class SignupProfilePage extends StatefulWidget {
  const SignupProfilePage({
    super.key,
    required this.email,
    required this.tempToken,
  });

  final String email;
  final String tempToken;

  @override
  State<SignupProfilePage> createState() => _SignupProfilePageState();
}

class _SignupProfilePageState extends State<SignupProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _api = SignupApiService();
  final _authService = AuthService();
  final _tokenStorage = TokenStorage();

  final _fullNameController = TextEditingController();
  late final TextEditingController _emailDisplayController;
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  final _educationController = TextEditingController();
  final _pastExperienceController = TextEditingController();

  String? _gender;
  List<SkillItem> _offeringSkills = [];
  List<SkillItem> _learningSkills = [];
  List<File> _certificates = [];

  File? _profilePic;
  File? _portfolio;
  File? _resume;

  bool _isLoading = false;
  String? _errorMessage;
  List<SkillItem>? _skillsCache;
  bool _skillsLoading = true;
  String? _skillsError;

  @override
  void initState() {
    super.initState();
    _emailDisplayController = TextEditingController(text: widget.email);
    _locationController.text = '';
    _fetchLocation();
    _loadSkills();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailDisplayController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _educationController.dispose();
    _pastExperienceController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() => _locationController.text = 'Location service disabled');
      }
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      if (mounted) {
        setState(() => _locationController.text = 'Permission denied');
      }
      return;
    }
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _locationController.text =
              '${position.latitude},${position.longitude}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _locationController.text = 'Could not get location');
      }
    }
  }

  Future<void> _loadSkills() async {
    if (_skillsCache != null && !_skillsLoading) return;
    if (mounted)
      setState(() {
        _skillsLoading = true;
        _skillsError = null;
      });
    try {
      final list = await _api.getSkills();
      if (mounted) {
        setState(() {
          _skillsCache = list;
          _skillsLoading = false;
          _skillsError = list.isEmpty ? 'No skills loaded' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _skillsLoading = false;
          _skillsError = 'Failed to load skills';
          _skillsCache = [];
        });
      }
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null && mounted) {
      setState(() => _profilePic = File(x.path));
    }
  }

  Future<void> _pickPortfolio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null && mounted) {
      setState(() => _portfolio = File(result.files.single.path!));
    }
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null && mounted) {
      setState(() => _resume = File(result.files.single.path!));
    }
  }

  Future<void> _pickCertificates() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );
    if (result != null && result.files.any((f) => f.path != null) && mounted) {
      setState(() {
        for (final f in result.files) {
          if (f.path != null) _certificates.add(File(f.path!));
        }
      });
    }
  }

  void _removeCertificate(File f) {
    setState(() => _certificates.remove(f));
  }

  Future<void> _submit() async {
    _errorMessage = null;
    if (!_formKey.currentState!.validate()) return;
    if (_offeringSkills.isEmpty) {
      setState(() => _errorMessage = 'Select at least one offering skill');
      return;
    }
    if (_learningSkills.isEmpty) {
      setState(() => _errorMessage = 'Select at least one learning skill');
      return;
    }
    final age = int.tryParse(_ageController.text.trim());
    final phone = _phoneNumberController.text.trim();
    if (age == null || age < 1 || age > 150) {
      setState(() => _errorMessage = 'Enter a valid age (1–150)');
      return;
    }
    if (phone.isEmpty) {
      setState(() => _errorMessage = 'Phone number is required');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final res = await _api.signup(
        token: widget.tempToken,
        email: widget.email,
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        phoneNumber: phone,
        age: age,
        gender: _gender ?? 'other',
        location: _locationController.text.trim(),
        offeringSkills: _offeringSkills.map((e) => e.id).join(','),
        learningSkills: _learningSkills.map((e) => e.id).join(','),
        education: _educationController.text.trim().isEmpty
            ? null
            : _educationController.text.trim(),
        pastExperience: _pastExperienceController.text.trim().isEmpty
            ? null
            : _pastExperienceController.text.trim(),
        profilePic: _profilePic,
        portfolio: _portfolio,
        resume: _resume,
        certificate: _certificates,
      );

      await _authService.persistAuthFromSignup(res);
      await _tokenStorage.clearTempSignupToken();

      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeShell()),
        (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Complete profile',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _field(
                      controller: _fullNameController,
                      label: 'Full name *',
                      validator: (v) =>
                          (v?.trim().isEmpty ?? true) ? 'Required' : null,
                    ),
                    _field(
                      controller: _emailDisplayController,
                      label: 'Email',
                      readOnly: true,
                    ),
                    _field(
                      controller: _passwordController,
                      label: 'Password *',
                      obscureText: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ),
                    _field(
                      controller: _phoneNumberController,
                      label: 'Phone number *',
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v?.trim().isEmpty ?? true) ? 'Required' : null,
                    ),
                    _field(
                      controller: _ageController,
                      label: 'Age *',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final n = int.tryParse(v?.trim() ?? '');
                        if (n == null || n < 1 || n > 150) {
                          return 'Enter 1–150';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: _inputDecoration('Gender *'),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => _gender = v),
                      validator: (v) => v == null ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _locationController,
                      label: 'Location *',
                      validator: (v) =>
                          (v?.trim().isEmpty ?? true) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Offering skills *',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _skillsLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        : _skillsError != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  size: 20,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _skillsError!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.orange.shade800,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _loadSkills,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : DropdownSearch<SkillItem>.multiSelection(
                            key: ValueKey(
                              'offering_${_skillsCache?.length ?? 0}',
                            ),
                            items: _skillsCache ?? [],
                            selectedItems: _offeringSkills,
                            onChanged: (v) =>
                                setState(() => _offeringSkills = v),
                            itemAsString: (s) => s.name,
                            compareFn: (a, b) => a.id == b.id,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: _inputDecoration(
                                'Select at least one',
                              ),
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Select at least one'
                                : null,
                          ),
                    if (!_skillsLoading && _skillsError == null) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Learning skills *',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownSearch<SkillItem>.multiSelection(
                        key: ValueKey('learning_${_skillsCache?.length ?? 0}'),
                        items: _skillsCache ?? [],
                        selectedItems: _learningSkills,
                        onChanged: (v) => setState(() => _learningSkills = v),
                        itemAsString: (s) => s.name,
                        compareFn: (a, b) => a.id == b.id,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: _inputDecoration(
                            'Select at least one',
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Select at least one'
                            : null,
                      ),
                    ],
                    const SizedBox(height: 12),
                    _field(
                      controller: _educationController,
                      label: 'Education',
                    ),
                    _field(
                      controller: _pastExperienceController,
                      label: 'Past experience',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    _fileTile('Profile photo', _profilePic, _pickProfileImage),
                    _fileTile('Portfolio', _portfolio, _pickPortfolio),
                    _fileTile('Resume', _resume, _pickResume),
                    const SizedBox(height: 12),
                    const Text(
                      'Certificates',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _pickCertificates,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.workspace_premium_outlined,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _certificates.isEmpty
                                      ? 'Tap to add certificates'
                                      : '${_certificates.length} certificate(s) selected',
                                  style: TextStyle(
                                    color: _certificates.isEmpty
                                        ? Colors.grey.shade600
                                        : Colors.black87,
                                    fontWeight: _certificates.isEmpty
                                        ? FontWeight.normal
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue.shade600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_certificates.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _certificates.map((f) {
                          final name = f.path.split(RegExp(r'[/\\]')).last;
                          return Chip(
                            label: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            onDeleted: () => _removeCertificate(f),
                          );
                        }).toList(),
                      ),
                    ],
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Create account',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: _inputDecoration(label),
        validator: validator,
      ),
    );
  }

  Widget _fileTile(String label, File? file, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          file != null
              ? file.path.split(RegExp(r'[/\\]')).last
              : 'Not selected',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: TextButton(
          onPressed: onTap,
          child: Text(file == null ? 'Pick' : 'Change'),
        ),
      ),
    );
  }
}
