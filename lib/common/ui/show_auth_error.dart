import 'package:firebase_auth_example/core/router/app_router_key.dart';
import 'package:firebase_auth_example/feature/authorization/cubit/auth_cubit_state.dart';
import 'package:flutter/material.dart';

abstract final class ErrorSnackbar {
  static void showAuthError(AuthCubitUnauthorized state) {
    final context = AppRouterKey.rootKey.currentContext!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.error.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
