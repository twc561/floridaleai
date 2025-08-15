
import 'package:flutter/material.dart';

class CrashChecklistsScreen extends StatefulWidget {
  const CrashChecklistsScreen({super.key});

  @override
  CrashChecklistsScreenState createState() => CrashChecklistsScreenState();
}

class CrashChecklistsScreenState extends State<CrashChecklistsScreen> {
  // A map to hold the checked state of each item.
  final Map<String, bool> _checklistItems = {};

  // Method to build a list of checklist items based on the crash type.
  List<ChecklistItem> _getChecklistForType(String type) {
    // Common items for all crash types
    final commonItems = [
      ChecklistItem("Scene Safety", "Position patrol vehicle to protect scene, use lights, wear reflective vest."),
      ChecklistItem("Render Aid", "Check for injuries and request EMS if necessary."),
      ChecklistItem("Secure Scene", "Identify and separate involved parties and witnesses."),
      ChecklistItem("Gather Info", "Collect driver's licenses, registrations, and insurance."),
      ChecklistItem("Photograph Scene", "Take photos of vehicle positions, damage, skid marks, and debris."),
      ChecklistItem("Measure Scene", "Take measurements of skid marks and final rest positions."),
      ChecklistItem("Clear Roadway", "Arrange for vehicle removal and clear debris."),
    ];

    if (type == 'Injury/Fatal Crash') {
      return [
        ...commonItems,
        ChecklistItem("Protect Evidence", "Establish a perimeter and protect critical evidence."),
        ChecklistItem("Request Traffic Homicide", "Notify dispatch and request a traffic homicide investigator."),
        ChecklistItem("Medical Examiner", "If fatal, ensure the medical examiner has been notified."),
      ];
    } else if (type == 'DUI Crash') {
      return [
        ...commonItems,
        ChecklistItem("Conduct FSTs", "Perform Standardized Field Sobriety Tests on the suspected impaired driver."),
        ChecklistItem("Implied Consent", "Read implied consent warning for breath/blood/urine test."),
        ChecklistItem("Breath Test", "Transport suspect for a breath test or arrange for a blood draw."),
        ChecklistItem("Vehicle Inventory", "Conduct an inventory search of the vehicle before towing."),
      ];
    } else { // Non-Injury Crash
      return [
        ...commonItems,
        ChecklistItem("Driver Exchange", "Facilitate the exchange of information between drivers."),
        ChecklistItem("Issue Citations", "Issue appropriate traffic citations."),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crash Checklists'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Non-Injury'),
              Tab(text: 'Injury/Fatal'),
              Tab(text: 'DUI Crash'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChecklistTab('Non-Injury Crash'),
            _buildChecklistTab('Injury/Fatal Crash'),
            _buildChecklistTab('DUI Crash'),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistTab(String crashType) {
    final items = _getChecklistForType(crashType);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final key = '$crashType-${item.title}';
        return CheckboxListTile(
          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(item.subtitle),
          value: _checklistItems[key] ?? false,
          onChanged: (bool? value) {
            setState(() {
              _checklistItems[key] = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }
}

// A simple class to hold checklist item data.
class ChecklistItem {
  final String title;
  final String subtitle;
  ChecklistItem(this.title, this.subtitle);
}
