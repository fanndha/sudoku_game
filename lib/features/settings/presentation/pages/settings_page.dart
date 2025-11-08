/// File: lib/features/settings/presentation/pages/settings_page.dart
/// Main page untuk Settings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/error_highlight_toggle.dart';
import '../widgets/music_toggle.dart';
import '../widgets/settings_section.dart';
import '../widgets/sound_toggle.dart';
import '../widgets/theme_switcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SettingsBloc>().add(const ResetSettingsEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pengaturan direset ke default'),
                ),
              );
            },
            tooltip: 'Reset ke Default',
          ),
        ],
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SettingsLoaded) {
            return _buildSettings(context, state);
          } else if (state is SettingsError) {
            return _buildError(context, state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSettings(BuildContext context, SettingsLoaded state) {
    final settings = state.settings;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Theme Section
        SettingsSection(
          title: 'Tampilan',
          icon: Icons.palette,
          children: [
            ThemeSwitcher(
              currentTheme: settings.themeMode,
              onThemeChanged: (theme) {
                context.read<SettingsBloc>().add(ChangeTheme(theme));
              },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Audio Section
        SettingsSection(
          title: 'Audio',
          icon: Icons.volume_up,
          children: [
            SoundToggle(
              isEnabled: settings.soundEnabled,
              volume: settings.soundVolume,
              onToggle: (enabled) {
                context.read<SettingsBloc>().add(ToggleSoundEvent(enabled));
              },
              onVolumeChanged: (volume) {
                context.read<SettingsBloc>().add(UpdateSoundVolumeEvent(volume));
              },
            ),
            const SizedBox(height: 12),
            MusicToggle(
              isEnabled: settings.musicEnabled,
              volume: settings.musicVolume,
              onToggle: (enabled) {
                context.read<SettingsBloc>().add(ToggleMusicEvent(enabled));
              },
              onVolumeChanged: (volume) {
                context.read<SettingsBloc>().add(UpdateMusicVolumeEvent(volume));
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Getaran'),
              subtitle: const Text('Aktifkan getaran'),
              value: settings.vibrationEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(ToggleVibrationEvent(value));
              },
              secondary: const Icon(Icons.vibration),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Gameplay Section
        SettingsSection(
          title: 'Permainan',
          icon: Icons.sports_esports,
          children: [
            SwitchListTile(
              title: const Text('Auto Validasi'),
              subtitle: const Text('Validasi otomatis setiap input'),
              value: settings.autoValidate,
              onChanged: (value) {
                context.read<SettingsBloc>().add(ToggleAutoValidateEvent(value));
              },
              secondary: const Icon(Icons.check_circle),
            ),
            ErrorHighlightToggle(
              isEnabled: settings.errorHighlight,
              onToggle: (enabled) {
                context.read<SettingsBloc>().add(ToggleErrorHighlightEvent(enabled));
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Timer'),
              subtitle: const Text('Tampilkan timer saat bermain'),
              value: settings.timerEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(ToggleTimerEvent(value));
              },
              secondary: const Icon(Icons.timer),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Mode Catatan'),
              subtitle: const Text('Aktifkan mode catatan'),
              value: settings.notesEnabled,
              onChanged: (value) {
                // Update notes enabled
                // Note: You might need to add this event to the bloc
              },
              secondary: const Icon(Icons.edit_note),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Notifications Section
        SettingsSection(
          title: 'Notifikasi',
          icon: Icons.notifications,
          children: [
            SwitchListTile(
              title: const Text('Notifikasi'),
              subtitle: const Text('Aktifkan semua notifikasi'),
              value: settings.notificationsEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(ToggleNotificationsEvent(value));
              },
              secondary: const Icon(Icons.notifications_active),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Tantangan Harian'),
              subtitle: const Text('Reminder tantangan harian'),
              value: settings.dailyChallengeReminder,
              onChanged: settings.notificationsEnabled
                  ? (value) {
                      // Update daily challenge reminder
                    }
                  : null,
              secondary: const Icon(Icons.today),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Pencapaian'),
              subtitle: const Text('Notifikasi pencapaian baru'),
              value: settings.achievementNotifications,
              onChanged: settings.notificationsEnabled
                  ? (value) {
                      // Update achievement notifications
                    }
                  : null,
              secondary: const Icon(Icons.emoji_events),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Language Section
        SettingsSection(
          title: 'Bahasa',
          icon: Icons.language,
          children: [
            ListTile(
              title: const Text('Bahasa Aplikasi'),
              subtitle: Text(settings.language == 'id' ? 'Indonesia' : 'English'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showLanguageDialog(context, settings.language);
              },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // About Section
        SettingsSection(
          title: 'Tentang',
          icon: Icons.info,
          children: [
            ListTile(
              title: const Text('Versi Aplikasi'),
              subtitle: const Text(AppStrings.appVersion),
              leading: const Icon(Icons.phone_android),
            ),
            ListTile(
              title: const Text('Kebijakan Privasi'),
              leading: const Icon(Icons.privacy_tip),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Open privacy policy
              },
            ),
            ListTile(
              title: const Text('Syarat & Ketentuan'),
              leading: const Icon(Icons.description),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Open terms
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<SettingsBloc>().add(const LoadSettings());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Indonesia'),
              value: 'id',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(ChangeLanguageEvent(value));
                  Navigator.pop(dialogContext);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(ChangeLanguageEvent(value));
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}