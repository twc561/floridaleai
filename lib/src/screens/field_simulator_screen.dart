
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:myapp/src/models/field_simulator/chat_message.dart';
import 'package:myapp/src/models/field_simulator/report_card.dart';
import 'package:myapp/src/models/field_simulator/scenario_info.dart';
import 'package:myapp/src/services/gemini_service.dart';

class FieldSimulatorScreen extends StatelessWidget {
  final ScenarioInfo scenarioInfo;

  const FieldSimulatorScreen({super.key, required this.scenarioInfo});

  @override
  Widget build(BuildContext context) {
    final geminiService = Provider.of<GeminiService>(context, listen: false);
    
    // State Management with ValueNotifiers
    final messagesNotifier = ValueNotifier<List<ChatMessage>>([]);
    final isLoadingNotifier = ValueNotifier<bool>(false);
    final textController = TextEditingController();
    final scrollController = ScrollController();
    final reportCardNotes = <String>[];

    void scrollToBottom() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
    
    // Initial Briefing Message
    void startScenario() {
      geminiService.startChatSession(scenarioInfo.personaPrompt);
      messagesNotifier.value = [
        ChatMessage(
          text: "**SCENARIO BRIEFING:**\n\n${scenarioInfo.briefing}\n\n**The simulation begins now. What is your first action or statement?**",
          sender: ChatSender.system,
        ),
      ];
    }
    
    startScenario(); // Display the briefing immediately

    Future<void> sendMessage({String? messageText}) async {
      final text = messageText ?? textController.text.trim();
      if (text.isEmpty) return;

      final officerMessage = ChatMessage(text: text, sender: ChatSender.officer);
      
      // Update UI immediately with the officer's message
      messagesNotifier.value = [...messagesNotifier.value, officerMessage];
      isLoadingNotifier.value = true;
      textController.clear();
      scrollToBottom();

      // Get AI response
      final aiResponse = await geminiService.continueChat(text);
      
      // Add AI response and any dynamic events to the chat
      final newMessages = <ChatMessage>[aiResponse];
      if (aiResponse.reportCardNote != null && aiResponse.reportCardNote!.isNotEmpty) {
        reportCardNotes.add(aiResponse.reportCardNote!);
      }
      if (aiResponse.dynamicEvent != null && aiResponse.dynamicEvent!.isNotEmpty) {
        newMessages.add(ChatMessage(
          text: "**DYNAMIC EVENT:**\n${aiResponse.dynamicEvent!}",
          sender: ChatSender.system,
        ));
      }
      
      messagesNotifier.value = [...messagesNotifier.value, ...newMessages];
      isLoadingNotifier.value = false;
      scrollToBottom();
    }

    void viewReportCard() {
      final performance = reportCardNotes.length > 5 && !reportCardNotes.any((note) => note.contains('escalated'))
          ? OverallPerformance.excellent
          : OverallPerformance.needsImprovement;

      final reportCard = ReportCard(
        scenarioTitle: scenarioInfo.title,
        learningObjectives: scenarioInfo.learningObjectives,
        performanceNotes: reportCardNotes,
        overallPerformance: performance,
        chatHistory: messagesNotifier.value,
      );

      GoRouter.of(context).pushReplacement('/scenario-summary', extra: reportCard);
    }

    void endSimulationWithArrest() {
      reportCardNotes.add("Officer initiated an arrest, concluding the simulation.");
      messagesNotifier.value = [...messagesNotifier.value, 
        const ChatMessage(
          text: "**SIMULATION ENDED:**\nYou have chosen to arrest the subject.",
          sender: ChatSender.system,
        ),
      ];
      viewReportCard();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(scenarioInfo.title),
        actions: [
          TextButton(
            onPressed: viewReportCard,
            child: const Text('End Simulation'),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<ChatMessage>>(
              valueListenable: messagesNotifier,
              builder: (context, messages, child) {
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return message.sender == ChatSender.officer
                        ? OfficerMessage(message: message)
                        : SubjectMessage(message: message);
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoadingNotifier,
            builder: (context, isLoading, child) {
              return Column(
                children: [
                  if (isLoading) const LinearProgressIndicator(),
                  _buildActionChips(context, isLoading, endSimulationWithArrest, sendMessage),
                  _buildTextComposer(context, isLoading, textController, sendMessage),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionChips(BuildContext context, bool isLoading, void Function() endSimulationWithArrest, Future<void> Function({String? messageText}) sendMessage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: scenarioInfo.suggestedActions.map((action) {
          final isArrest = action.toLowerCase() == 'arrest';
          return ActionChip(
            label: Text(action),
            onPressed: isLoading
                ? null
                : () {
                    if (isArrest) {
                      endSimulationWithArrest();
                    } else {
                      sendMessage(messageText: action);
                    }
                  },
            backgroundColor: isArrest ? Theme.of(context).colorScheme.errorContainer : null,
            labelStyle: isArrest ? TextStyle(color: Theme.of(context).colorScheme.onErrorContainer) : null,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context, bool isLoading, TextEditingController textController, Future<void> Function({String? messageText}) sendMessage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              onSubmitted: (_) => sendMessage(),
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
            onPressed: isLoading ? null : () => sendMessage(),
          ),
        ],
      ),
    );
  }
}

class SubjectMessage extends StatelessWidget {
  final ChatMessage message;
  const SubjectMessage({super.key, required this.message});

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
            MarkdownBody(
              data: message.text,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyLarge?.copyWith(
                  color: message.sender == ChatSender.system
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onSecondaryContainer,
                ),
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
                    : theme.colorScheme.onSecondaryContainer),
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

class OfficerMessage extends StatelessWidget {
  final ChatMessage message;
  const OfficerMessage({super.key, required this.message});

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
