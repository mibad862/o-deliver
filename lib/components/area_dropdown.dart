import 'package:flutter/material.dart';

class FieldDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> fields; // List of areas
  final List<int> selectedFields; // List of selected areas
  final Function(List<int>) onFieldSelectionChanged;
  final String dropDownName;

  FieldDropdown({
    required this.fields,
    required this.selectedFields,
    required this.onFieldSelectionChanged,
    required this.dropDownName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Show the dialog and wait for the result (selected areas)
        final List<int>? result = await showDialog<List<int>>(
          context: context,
          builder: (context) => AreaSelectionDialog(
            areas: fields,
            selectedAreas: selectedFields,
            dropDownName: dropDownName,
          ),
        );

        if (result != null) {
          // Update the selected areas
          onFieldSelectionChanged(result);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          selectedFields.isEmpty
              ? 'Select $dropDownName'
              : selectedFields
              .map((areaId) =>
          fields.firstWhere((area) => area['id'] == areaId)['name'])
              .join(', '),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class AreaSelectionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> areas;
  final List<int> selectedAreas;
  String dropDownName;

  AreaSelectionDialog({
    required this.areas,
    required this.selectedAreas,
    required this.dropDownName,
  });

  @override
  _AreaSelectionDialogState createState() => _AreaSelectionDialogState();
}

class _AreaSelectionDialogState extends State<AreaSelectionDialog> {
  late List<int> selectedAreas;

  @override
  void initState() {
    super.initState();
    selectedAreas = List.from(widget.selectedAreas);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select ${widget.dropDownName}'),
      content: SingleChildScrollView(
        child: Column(
          children: widget.areas.map((area) {
            return CheckboxListTile(
              value: selectedAreas.contains(area['id']),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    selectedAreas.add(area['id']);
                  } else {
                    selectedAreas.remove(area['id']);
                  }
                });
              },
              title: Text(area['name']),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedAreas); // Return the selected areas
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
