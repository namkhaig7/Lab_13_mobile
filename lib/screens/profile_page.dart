import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/models/users.dart';
import '../l10n/strings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late Future<List<AppUser>> _userFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userFuture = Provider.of<Global_provider>(context, listen: false).loadUsers();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(Global_provider provider) async {
    setState(() {
      _isLoading = true;
    });
    final success = await provider.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() {
      _isLoading = false;
    });
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.lastLoginError ?? AppStrings.t(context, 'login_error'),
          ),
        ),
      );
      return;
    }
    FocusScope.of(context).unfocus();
  }

  Widget _languageSelector(Global_provider provider) {
    const languageLabels = {'en': 'English', 'mn': 'Монгол'};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          AppStrings.t(context, 'language'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        InputDecorator(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: provider.locale,
              isExpanded: true,
              items: provider.supportedLocales
                  .map(
                    (locale) => DropdownMenuItem(
                      value: locale,
                      child: Text(languageLabels[locale.languageCode] ?? locale.languageCode),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) provider.setLocale(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Consumer<Global_provider>(
          builder: (context, provider, child) {
            if (provider.isLoggedIn && provider.currentUser != null) {
              final user = provider.currentUser!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.t(context, 'login'),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text('${user.firstName} ${user.lastName}', style: const TextStyle(fontSize: 18)),
                    Text(user.email),
                    Text(user.phone),
                    if (provider.token != null) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Token:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      //task2
                      SelectableText(
                        provider.token == 'offline'
                            ? 'Offline session (no server token)'
                            : provider.token!,
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: provider.logout,
                      child: Text(AppStrings.t(context, 'logout')),
                    ),
                    _languageSelector(provider),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.t(context, 'login'),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.t(context, 'login_hint'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: AppStrings.t(context, 'username'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: AppStrings.t(context, 'password'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _login(provider),
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(AppStrings.t(context, 'login_button')),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Жишээ: username: johnd  | password: m38rmF\$',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  _languageSelector(provider),
                ],
              ),
            );
          },
        );
      },
    );
  }
}