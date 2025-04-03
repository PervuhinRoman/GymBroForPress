import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255, // Fully opaque
    100 + random.nextInt(100), // Red: 0–255
    100 + random.nextInt(100), // Green: 0–255
    100 + random.nextInt(100), // Blue: 0–255
  );
}

class DebugState {
  final bool isDebugEnabled;

  const DebugState({this.isDebugEnabled = true});

  DebugState copyWith({bool? isDebugEnabled}) {
    return DebugState(
      isDebugEnabled: isDebugEnabled ?? this.isDebugEnabled,
    );
  }
}

class DebugController extends StateNotifier<DebugState> {
  DebugController() : super(const DebugState());

  void toggleDebug() {
    state = state.copyWith(isDebugEnabled: !state.isDebugEnabled);
  }

  void setDebug(bool value) {
    state = state.copyWith(isDebugEnabled: value);
  }
}

final debugProvider = StateNotifierProvider<DebugController, DebugState>(
  (ref) => DebugController(),
);


class DebugBox extends ConsumerWidget {
  const DebugBox({
    super.key,
    this.child,
    this.width,
    this.height,
  });

  final Widget? child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDebug = ref.watch(debugProvider).isDebugEnabled;
    return Placeholder(
      color: isDebug ? Colors.black : Color.fromARGB(0, 0, 0, 0),
      strokeWidth: 1,
      
      child: child ?? SizedBox(width: width ?? 50, height: height ?? 50,),
    );
  }
}

class DebugGizmo extends ConsumerWidget {
  const DebugGizmo({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDebug = ref.watch(debugProvider).isDebugEnabled;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDebug ? getRandomColor() : Color.fromARGB(0, 0, 0, 0)
        ),
      ),
      child: child ?? DebugBox(),
    );
  }
}
