import 'package:myapp/src/services/gemini_scenario_prompts.dart';

enum ScenarioDifficulty { easy, medium, hard }

class ScenarioInfo {
  final String title;
  final String briefing;
  final ScenarioDifficulty difficulty;
  final String personaPrompt;
  final List<String> learningObjectives; // Added this property

  const ScenarioInfo({
    required this.title,
    required this.briefing,
    required this.difficulty,
    required this.personaPrompt,
    required this.learningObjectives,
  });
}

// A library of all available training scenarios with enhanced, illustrative briefings.
final List<ScenarioInfo> scenarioLibrary = [
  const ScenarioInfo(
    title: 'Mental Health Crisis',
    briefing: 'You receive a dispatch call for a welfare check on a highway overpass. The subject is a young man who appears highly agitated and is looking down at traffic. This is a high-stakes encounter requiring patience and expert de-escalation skills to prevent a tragedy.',
    difficulty: ScenarioDifficulty.hard,
    personaPrompt: mentalHealthCrisisPersonaPrompt,
    learningObjectives: [
      'Apply core principles of active listening and verbal de-escalation.',
      'Demonstrate effective communication techniques to build rapport.',
      'Articulate the legal considerations for involuntary assessment under Florida\'s Baker Act.',
    ],
  ),
  const ScenarioInfo(
    title: 'Domestic Disturbance',
    briefing: 'Neighbors report loud yelling and the sound of breaking glass from an apartment. You must de-escalate, separate the parties, and determine if a crime has occurred.',
    difficulty: ScenarioDifficulty.medium,
    personaPrompt: domesticDisturbancePersonaPrompt,
    learningObjectives: [
      'Safely separate involved parties.',
      'Conduct independent interviews to gather evidence.',
      'Identify the primary aggressor in a domestic violence situation.',
    ],
  ),
  // ... (Add learning objectives for all other scenarios)
  const ScenarioInfo(
    title: 'DUI Investigation',
    briefing: 'Conduct a traffic stop on a swerving vehicle and assess the driver for signs of impairment using standard procedures.',
    difficulty: ScenarioDifficulty.hard,
    personaPrompt: duiInvestigationPersonaPrompt,
    learningObjectives: [
      'Articulate reasonable suspicion for the initial traffic stop.',
      'Properly administer Standardized Field Sobriety Tests.',
      'Understand the legal standard for a DUI arrest.',
    ],
  ),
  const ScenarioInfo(
    title: 'Escalating Traffic Stop',
    briefing: 'Handle a non-compliant driver who challenges your authority. Tests patience and knowledge of traffic law.',
    difficulty: ScenarioDifficulty.hard,
    personaPrompt: escalatingTrafficStopPersonaPrompt,
    learningObjectives: [
      'Maintain professionalism during a high-stress verbal confrontation.',
      'Clearly articulate commands and legal authority.',
      'Know when to disengage and call for backup.',
    ],
  ),
  const ScenarioInfo(
    title: 'Suspicious Person',
    briefing: 'Make contact with a person a neighbor reported as "suspicious" and lawfully determine their reason for being in the area.',
    difficulty: ScenarioDifficulty.medium,
    personaPrompt: suspiciousPersonPersonaPrompt,
    learningObjectives: [
      'Articulate the basis for an investigatory stop.',
      'Conduct a lawful Terry frisk if reasonable suspicion exists.',
      'De-escalate a situation with a defensive but non-criminal subject.',
    ],
  ),
  const ScenarioInfo(
    title: 'Panhandler Complaint',
    briefing: 'Address a complaint about a homeless man panhandling outside a business while respecting his rights.',
    difficulty: ScenarioDifficulty.medium,
    personaPrompt: panhandlerPersonaPrompt,
    learningObjectives: [
      'Balance the rights of business owners and private citizens.',
      'Apply local ordinances correctly and fairly.',
      'Utilize community resources and outreach programs for the homeless.',
    ],
  ),
  const ScenarioInfo(
    title: 'Welfare Check',
    briefing: 'Check on an elderly woman whose family cannot reach her. You must balance respect for her privacy with ensuring her safety.',
    difficulty: ScenarioDifficulty.medium,
    personaPrompt: welfareCheckPersonaPrompt,
    learningObjectives: [
      'Use communication skills to build trust with a vulnerable person.',
      'Identify signs of elder neglect or abuse.',
      'Understand procedures for forced entry in exigent circumstances.',
    ],
  ),
  const ScenarioInfo(
    title: 'Routine Traffic Stop',
    briefing: 'This is a standard, "by-the-book" traffic stop for a simple speeding violation with a nervous but cooperative driver.',
    difficulty: ScenarioDifficulty.easy,
    personaPrompt: trafficStopPersonaPrompt,
    learningObjectives: [
      'Follow the correct procedural sequence of a traffic stop.',
      'Maintain a professional demeanor.',
      'Clearly explain the reason for the stop and the outcome.',
    ],
  ),
  const ScenarioInfo(
    title: 'Shoplifting a Minor',
    briefing: 'Interview a scared teenager who has been caught shoplifting. Involves juvenile procedures and decision-making.',
    difficulty: ScenarioDifficulty.easy,
    personaPrompt: shopliftingPersonaPrompt,
    learningObjectives: [
      'Understand the legal requirements for interviewing a juvenile.',
      'Apply discretion in choosing between arrest and diversion.',
      'Communicate effectively with a scared young person.',
    ],
  ),
  const ScenarioInfo(
    title: 'Noise Complaint',
    briefing: 'You\'re sent to a noise complaint at a house party in a residential area. The homeowner is a cooperative college student.',
    difficulty: ScenarioDifficulty.easy,
    personaPrompt: noiseComplaintPersonaPrompt,
    learningObjectives: [
      'Gain voluntary compliance through communication.',
      'Resolve a common neighborhood dispute peacefully.',
      'Understand the legal basis for a noise ordinance violation.',
    ],
  ),
];
