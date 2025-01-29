import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DeleteUserButton extends StatelessWidget {
  final VoidCallback deleteUser;

  DeleteUserButton({
    super.key,
    required this.deleteUser,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        textStyle: const TextStyle(
          inherit: false,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () => deleteUser(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 0.sp,
          vertical: 20.sp,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            const Text('Delete & Re-Register'),
          ],
        ),
      ),
    );
  }
}
