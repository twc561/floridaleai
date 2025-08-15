import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/services/gemini_service.dart';

class AiSearchAdvisorScreen extends StatelessWidget {
  const AiSearchAdvisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController scenarioController = TextEditingController();
    final ValueNotifier<String?> responseNotifier = ValueNotifier(null);
    final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

    Future<void> getAdvice() async {
      if (scenarioController.text.isEmpty) {
        return;
      }

      isLoadingNotifier.value = true;
      responseNotifier.value = null;

      try {
        final geminiService = Provider.of<GeminiService>(context, listen: false);
        final response = await geminiService.getSearchAndSeizureAdvice(scenarioController.text);
        responseNotifier.value = response;
      } catch (e) {
        responseNotifier.value = 'An error occurred: $e';
      } finally {
        isLoadingNotifier.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Search & Seizure Advisor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: scenarioController,
              decoration: InputDecoration(
                labelText: 'Describe the scenario',
                border: const OutlineInputBorder(),
                hintText: 'e.g., "I pulled over a car for speeding and saw a suspicious package on the back seat..."',
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: isLoadingNotifier,
              builder: (context, isLoading, child) {
                return ElevatedButton(
                  onPressed: isLoading ? null : getAdvice,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Get Advice'),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ValueListenableBuilder<String?>(
                  valueListenable: responseNotifier,
                  builder: (context, response, child) {
                    if (response == null) {
                      return const Center(
                        child: Text(
                          'The information provided by this AI advisor is for educational and informational purposes only. It is not a substitute for legal advice.',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return Markdown(data: response);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
