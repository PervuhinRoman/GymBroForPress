// file: editable_display_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'field_notifier.dart';

/// A scalable widget that displays a field (with a label and value) in read-only mode,
/// and turns into an editable TextField when the user taps the edit button.
/// The field's value is managed by a Riverpod provider.
class EditableDisplayField extends ConsumerStatefulWidget {
  final String label;
  /// A StateNotifierProvider that provides a String (the field value) and a notifier with an update method.
  final StateNotifierProvider<FieldNotifier, String> fieldProvider;

  const EditableDisplayField({
    Key? key,
    required this.label,
    required this.fieldProvider,
  }) : super(key: key);

  @override
  _EditableDisplayFieldState createState() => _EditableDisplayFieldState();
}

class _EditableDisplayFieldState extends ConsumerState<EditableDisplayField> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the current value from the provider.
    _controller = TextEditingController(text: ref.read(widget.fieldProvider));
  }

  @override
  void didUpdateWidget(covariant EditableDisplayField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the controller's text if the provider's value changes externally.
    final currentValue = ref.read(widget.fieldProvider);
    if (_controller.text != currentValue) {
      _controller.text = currentValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmEdit() {
    // Update the global state using the provider's notifier.
    ref.read(widget.fieldProvider.notifier).update(_controller.text);
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isEditing = ref.watch(editModeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isEditing ? _buildEditMode() : _buildDisplayMode(),
      ],
    );
  }

  Widget _buildDisplayMode() {
    return ColoredBox(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _controller.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Color.lerp(Theme.of(context).colorScheme.onSecondary, Colors.grey, 0.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditMode() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => ref.read(editModeProvider.notifier).setEditMode(false),
        ),
      ],
    );
  }
}
