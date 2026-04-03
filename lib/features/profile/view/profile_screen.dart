import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../model/user_profile.dart';
import '../view_model/profile_view_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(_refresh);
    _phone.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  ProfileViewModel get _viewModel =>
      ref.read(profileViewModelProvider.notifier);

  @override
  Widget build(BuildContext context) {
    ref.listen(profileViewModelProvider, (_, next) {
      final profile = next.valueOrNull;
      if (profile != null && !_seeded) {
        _name.text = profile.name;
        _phone.text = profile.emergencyContact;
        _seeded = true;
      }
    });

    final profileAsync = ref.watch(profileViewModelProvider);
    final size = MediaQuery.sizeOf(context);
    final scale = (size.width / 375).clamp(0.85, 1.2);

    return Scaffold(
      backgroundColor: AppColors.creamSurface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Profile',
            style: TextStyle(fontSize: 20 * scale, color: Colors.black)),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load profile.')),
        data: (profile) => _body(context, profile, size, scale),
      ),
    );
  }

  Widget _body(
      BuildContext context, UserProfile profile, Size size, double scale) {
    final edited = _seeded &&
        (_name.text != profile.name || _phone.text != profile.emergencyContact);

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(size.height * 0.05),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: size.height * 0.1,
                      backgroundImage: profile.profilePictureUrl.isNotEmpty
                          ? NetworkImage(profile.profilePictureUrl)
                          : const AssetImage('assets/avatar.png')
                              as ImageProvider,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.pinkAccent),
                      onPressed: _pickPicture,
                    ),
                  ],
                ),
              ),
              _textField(_name, 'Name', size),
              Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: TextFormField(
                  key: ValueKey(profile.email),
                  initialValue: profile.email,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              _textField(_phone, 'Emergency No.', size,
                  keyboardType: TextInputType.phone),
              SizedBox(height: size.height * 0.03),
              if (edited)
                _button(
                  'Save',
                  scale,
                  size,
                  () => _save(profile),
                ),
              SizedBox(height: size.height * 0.005),
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.setPin),
                icon: const Icon(Icons.lock_outline,
                    color: AppColors.primaryPink),
                label: Text('Set App PIN',
                    style: TextStyle(
                        fontSize: 16 * scale, color: AppColors.primaryPink)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryPink),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.12,
                      vertical: size.height * 0.015),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: size.height * 0.005),
              _button('Log Out', scale, size, _logout),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickPicture() async {
    try {
      await _viewModel.pickProfilePicture();
    } on AppException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } catch (_) {
      if (mounted) {
        showAppSnackBar(context, 'Failed to pick image.', isError: true);
      }
    }
  }

  Future<void> _save(UserProfile profile) async {
    try {
      await _viewModel.save(name: _name.text, emergencyContact: _phone.text);
      if (mounted) showAppSnackBar(context, 'Profile updated successfully');
    } catch (_) {
      if (mounted) {
        showAppSnackBar(context, 'Failed to update profile.', isError: true);
      }
    }
  }

  Future<void> _logout() => _viewModel.signOut();

  Widget _textField(
    TextEditingController controller,
    String label,
    Size size, {
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.all(size.height * 0.02),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _button(
      String label, double scale, Size size, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.2, vertical: size.height * 0.015),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label,
          style: TextStyle(fontSize: 16 * scale, color: Colors.white)),
    );
  }
}
