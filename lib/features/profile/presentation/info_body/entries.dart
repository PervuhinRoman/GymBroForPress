import 'package:flutter/material.dart';
import 'package:gymbro/features/profile/presentation/field_notifier.dart';
import 'package:gymbro/features/profile/presentation/info_body/info_body_adapter.dart';
import 'info_wrapper.dart';
import 'package:gymbro/core/widgets/double_text.dart';
import 'package:gymbro/features/profile/presentation/editable_display_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Entries extends StatelessWidget implements InfoBody {
  const Entries({
    super.key,
    required this.infoClauses,
  });

  final List<InfoClause> infoClauses;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        for(var clause in infoClauses) 
          InfoEntry(
            infoClause: clause,
          ),
        ]
      );
  }
}

class InfoClause {
  const InfoClause(
    this.label,
    this.fieldProvider,
  );

  final StateNotifierProvider<FieldNotifier, String> fieldProvider;
  final String label;
}

class InfoEntry extends StatelessWidget {
  const InfoEntry({
    super.key,
    required this.infoClause,
  });

  final InfoClause infoClause;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditableDisplayField(
          label: infoClause.label, 
          fieldProvider: infoClause.fieldProvider
        ),
      ]
    );
  }
}

