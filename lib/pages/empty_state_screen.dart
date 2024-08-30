import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/image/empty_state.svg",
          width: 120,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text("Your task list is empty!")
      ],
    );
  }
}
