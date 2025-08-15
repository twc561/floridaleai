import 'package:myapp/src/models/field_simulator/scenario_info.dart';
import 'package:myapp/src/services/gemini_persona_prompt.dart';

List<ScenarioInfo> getScenarios() {
  return [
    ScenarioInfo(
      title: 'Mental Health Crisis Intervention',
      briefing:
          'You are dispatched to a highway overpass where a 28-year-old male, David, is in a severe mental health crisis and contemplating suicide. Your goal is to de-escalate the situation and ensure his safety.',
      learningObjectives: [
        'Establish rapport with a person in crisis.',
        'Use active listening and empathetic communication.',
        'Apply de-escalation techniques.',
        'Make a safe and effective disposition.'
      ],
      personaPrompt: mentalHealthCrisisPersonaPrompt,
      suggestedActions: [
        'Introduce yourself and state your purpose.',
        'Use a calm and non-threatening tone.',
        'Ask open-ended questions.',
        'Express empathy and a willingness to help.',
      ],
    ),
    // Add more scenarios here in the future
  ];
}
