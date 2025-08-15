import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/field_simulator/chat_message.dart';
import 'package:myapp/src/models/field_simulator/report_card.dart';
import 'package:myapp/src/models/field_simulator/scenario_info.dart';
import 'package:myapp/src/services/gemini_service.dart';
import 'package:provider/provider.dart';

class FieldSimulatorScreen extends StatefulWidget {
  final ScenarioInfo scenarioInfo;
  const FieldSimulatorScreen({super.key, required this.scenarioInfo});

  @override
  _FieldSimulatorScreenState createState() => _FieldSimulatorScreenState();
}

class _FieldSimulatorScreenState extends State<FieldSimulatorScreen> {
  late final GeminiService _geminiService;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<String> _reportCardNotes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _geminiService = Provider.of<GeminiService>(context, listen: false);
    _startScenario();
  }

  void _startScenario() {
    _geminiService.startChatSession(widget.scenarioInfo.personaPrompt);
    setState(() {
      _messages.add(
        ChatMessage(
          text:
              "**SCENARIO BRIEFING:**\n\n${widget.scenarioInfo.briefing}\n\n**The simulation begins now. What is your first action or statement?**",
          sender: ChatSender.system,
        ),
      );
    });
  }

  Future<void> _sendMessage() async {
    final messageText = _textController.text.trim();
    if (messageText.isEmpty) return;

    final officerMessage = ChatMessage(text: messageText, sender: ChatSender.officer);

    setState(() {
      _messages.add(officerMessage);
      _isLoading = true;
      _textController.clear();
    });
    _scrollToBottom();

    // The service now handles parsing and errors, so the UI code is cleaner.
    final aiResponse = await _geminiService.continueChat(messageText);

    _messages.add(aiResponse);
    if (aiResponse.reportCardNote != null && aiResponse.reportCardNote!.isNotEmpty) {
      _reportCardNotes.add(aiResponse.reportCardNote!);
    }

    if (aiResponse.dynamicEvent != null && aiResponse.dynamicEvent!.isNotEmpty) {
      _messages.add(
        ChatMessage(
          text: "**DYNAMIC EVENT:**\n${aiResponse.dynamicEvent!}",
          sender: ChatSender.system,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _viewReportCard() {
    final performance = _reportCardNotes.length > 5 && !_reportCardNotes.any((note) => note.contains('escalated'))
        ? OverallPerformance.excellent
        : OverallPerformance.needsImprovement;

    final reportCard = ReportCard(
      scenarioTitle: widget.scenarioInfo.title,
      learningObjectives: widget.scenarioInfo.learningObjectives,
      performanceNotes: _reportCardNotes,
      overallPerformance: performance,
    );

    GoRouter.of(context).pushReplacement('/scenario-summary', extra: reportCard);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenarioInfo.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined),
            onPressed: _viewReportCard,
            tooltip: 'End Simulation & View Report',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message.sender == ChatSender.officer) {
                  return _OfficerMessage(message: message);
                } else {
                  return _SubjectMessage(message: message);
                }
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Type your response...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isLoading ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _SubjectMessage extends StatelessWidget {
  final ChatMessage message;
  const _SubjectMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.sender == ChatSender.system
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.sender == ChatSender.system)
              Text(
                "SYSTEM NOTE",
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            Text(
              message.text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: message.sender == ChatSender.system
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSecondaryContainer,
              ),
            ),
            if (message.feedback != null && message.feedback!.isNotEmpty) ...[
              const Divider(height: 16),
              Text(
                "TRAINING FEEDBACK:",
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                   color: message.sender == ChatSender.system
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.feedback!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: (message.sender == ChatSender.system
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSecondaryContainer).withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _OfficerMessage extends StatelessWidget {
  final ChatMessage message;
  const _OfficerMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
