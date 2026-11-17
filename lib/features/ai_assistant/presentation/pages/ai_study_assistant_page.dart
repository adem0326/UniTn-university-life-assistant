import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AiStudyAssistantPage extends StatelessWidget {
  const AiStudyAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SmartCampus',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('AI Assistant'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.surface),
                    SizedBox(width: 8),
                    Text(
                      'CAMPUS COPILOT V3.4',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.circle, color: AppColors.cyan, size: 8),
                    SizedBox(width: 6),
                    Text(
                      'Synced',
                      style: TextStyle(color: AppColors.surface, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'SmartCampus Copilot',
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Grounded in verified university course materials and campus resources.',
                  style: TextStyle(color: AppColors.surface, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: const Text(
                'Distributed_Systems_Lec07.pdf',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Text('34 pages indexed'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Change'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Accelerated Study Modes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('All modes')),
            ],
          ),
          const SizedBox(height: 8),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ModeCard(
                  icon: Icons.article_outlined,
                  title: 'Chat with Slides',
                  subtitle: 'Ask questions about lecture pages.',
                ),
                SizedBox(width: 10),
                _ModeCard(
                  icon: Icons.quiz_outlined,
                  title: 'Generate MCQ',
                  subtitle: 'Create midterm-style questions.',
                ),
                SizedBox(width: 10),
                _ModeCard(
                  icon: Icons.summarize_outlined,
                  title: 'Summarize',
                  subtitle: 'Extract the key takeaways.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Current study thread',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Can you explain the Raft Consensus Algorithm in simple terms?',
                style: TextStyle(color: AppColors.surface),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryContainer,
                child: Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'In simple terms, think of Raft as an elected student committee.',
                        ),
                        const SizedBox(height: 12),
                        const _AnswerPoint(
                          number: '1',
                          title: 'Leader Election',
                          detail: 'Nodes hold elections and a majority elects one leader.',
                        ),
                        const _AnswerPoint(
                          number: '2',
                          title: 'Log Replication',
                          detail: 'The leader replicates entries to peer nodes before committing.',
                        ),
                        const _AnswerPoint(
                          number: '3',
                          title: 'Safety',
                          detail: 'Committed entries are preserved across elections.',
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Generate 3 quiz questions'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Chip(label: Text('Summarize key takeaways')),
                SizedBox(width: 8),
                Chip(label: Text('Create flashcards')),
                SizedBox(width: 8),
                Chip(label: Text('Explain simply')),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _AiInputBar(),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 10),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 5),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerPoint extends StatelessWidget {
  const _AnswerPoint({
    required this.number,
    required this.title,
    required this.detail,
  });

  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 2),
                Text(detail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiInputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        MediaQuery.viewPaddingOf(context).bottom + 10,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Attach file',
            onPressed: () {},
            icon: const Icon(Icons.attach_file),
          ),
          Expanded(
            child: TextField(
              key: const Key('ai_prompt_field'),
              decoration: const InputDecoration(
                hintText: 'Ask your study copilot...',
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            key: const Key('ai_send_button'),
            tooltip: 'Send',
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
            ),
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
