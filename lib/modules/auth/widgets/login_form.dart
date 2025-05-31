import 'package:flutter/material.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/modules/auth/data/auth_repository.dart';
import 'package:rota_app/modules/auth/data/auth_repository_api.dart';
import 'package:rota_app/modules/auth/data/auth_repository_mock.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final email = _userController.text.trim();
      final password = _passwordController.text.trim();

      final AuthRepository repository = DevConfig.forceMock
          ? AuthRepositoryMock()
          : AuthRepositoryAPI();

      try {
        final result = await repository.login(email: email, password: password);

        if (DevConfig.enableLogs) {
          debugPrint('Login OK: ${result.user['name']}');
        }

        if (!mounted) return;
        context.go('/home');
      } catch (e) {
        debugPrint('Erro ao logar: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _userController,
            decoration: InputDecoration(
              labelText: 'Usuário',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe seu usuário';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe sua senha';
              }
              if (value.length < 6) {
                return 'Senha deve ter no mínimo 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _onSubmit,
            child: const Text('Confirmar'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              context.push('/esqueceu-senha');
            },
            child: const Text('Esqueceu a senha?'),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Continuar com Google'),
          ),
        ],
      ),
    );
  }
}
