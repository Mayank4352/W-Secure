import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../view_model/connect_nearby_view_model.dart';

class ConnectNearbyScreen extends ConsumerStatefulWidget {
  const ConnectNearbyScreen({super.key});

  @override
  ConsumerState<ConnectNearbyScreen> createState() =>
      _ConnectNearbyScreenState();
}

class _ConnectNearbyScreenState extends ConsumerState<ConnectNearbyScreen> {
  final _location = TextEditingController();
  final _timeFrom = TextEditingController();
  final _timeTo = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _location.dispose();
    _timeFrom.dispose();
    _timeTo.dispose();
    _message.dispose();
    super.dispose();
  }

  ConnectNearbyViewModel get _viewModel =>
      ref.read(connectNearbyViewModelProvider.notifier);

  Future<void> _useCurrentLocation() async {
    try {
      _location.text = await _viewModel.currentLocationLabel();
      _viewModel.clearSuggestions();
    } on AppException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } catch (_) {
      if (mounted) {
        showAppSnackBar(context, 'Could not get current location.',
            isError: true);
      }
    }
  }

  Future<void> _send() async {
    try {
      await _viewModel.saveAlert(
        location: _location.text,
        timeFrom: _timeFrom.text,
        timeTo: _timeTo.text,
        message: _message.text,
      );
      if (mounted) showAppSnackBar(context, 'Alert saved successfully!');
    } on AppException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } catch (_) {
      if (mounted) {
        showAppSnackBar(context, 'Could not save the alert.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = ref.watch(connectNearbyViewModelProvider);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.creamSurface,
      appBar: AppBar(
        backgroundColor: AppColors.creamSurface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title:
            const Text('Connect nearby', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.height * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _location,
                onChanged: _viewModel.fetchSuggestions,
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location,
                        color: AppColors.primaryPink),
                    onPressed: _useCurrentLocation,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              if (suggestions.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        suggestions[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _location.text = suggestions[index];
                        _viewModel.clearSuggestions();
                      },
                    ),
                  ),
                ),
              SizedBox(height: size.height * 0.03),
              const Text('Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(child: _dateField(_timeFrom, 'From (DD-MM-YYYY)')),
                  SizedBox(width: size.height * 0.02),
                  Expanded(child: _dateField(_timeTo, 'To (DD-MM-YYYY)')),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              const Text('Message',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: size.height * 0.01),
              TextField(
                controller: _message,
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: 'Enter your message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Center(
                child: ElevatedButton(
                  onPressed: _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                        vertical: size.height * 0.02),
                  ),
                  child: const Text('SEND',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
