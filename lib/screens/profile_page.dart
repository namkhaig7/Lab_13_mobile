import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/models/users.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late Future<List<AppUser>> _userFuture;

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

  void _login(Global_provider provider) {
    final success = provider.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нэвтрэх нэр эсвэл нууц үг буруу')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
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
                    const Text(
                      'Нэвтэрсэн хэрэглэгч',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text('${user.firstName} ${user.lastName}', style: const TextStyle(fontSize: 18)),
                    Text(user.email),
                    Text(user.phone),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: provider.logout,
                      child: const Text('Гарах'),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Нэвтрэх',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _login(provider),
                      child: const Text('Нэвтрэх'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Жишээ: username: johnd  | password: m38rmF\$',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}