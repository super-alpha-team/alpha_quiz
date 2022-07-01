import 'package:alpha_quiz/modules/play/provider/play_screen_vm.dart';
import 'package:alpha_quiz/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditingScreen extends StatelessWidget {
  const EditingScreen({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff46178F),
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff230b47),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(24),
              child: Text(
                message,
                style: TextStyles.h5Bold.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Material(
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    final vm =
                        Provider.of<PlayScreenVM>(context, listen: false);
                    vm.fetchData();
                  },
                  splashColor: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    height: 56,
                    child: const Text(
                      'Refresh',
                      style: TextStyles.subtitle2SemiBold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
