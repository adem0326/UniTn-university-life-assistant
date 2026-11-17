import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            tooltip: 'New conversation',
            onPressed: () {},
            icon: const Icon(Icons.edit_square),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: 'Search conversations',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          _ConversationTile(
            initials: 'ER',
            name: 'Elena Rostova',
            message: 'I shared the LSTM notes with you',
            time: '12m',
            unread: 2,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ChatPage(
                    name: 'Elena Rostova',
                    subtitle: 'MIT • Electrical Engineering',
                  ),
                ),
              );
            },
          ),
          _ConversationTile(
            initials: 'DS',
            name: 'Distributed Systems Group',
            message: 'Marcus: Tomorrow at 5:30 works',
            time: '38m',
            unread: 4,
            group: true,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ChatPage(
                    name: 'Distributed Systems Group',
                    subtitle: '11 members • CS244',
                    group: true,
                  ),
                ),
              );
            },
          ),
          const _ConversationTile(
            initials: 'MC',
            name: 'Marcus Chen',
            message: 'Are you available for CalHacks?',
            time: '2h',
          ),
          const _ConversationTile(
            initials: 'SC',
            name: 'Study Circle: CS161',
            message: 'Elena: Uploaded a new practice set',
            time: 'Yesterday',
            group: true,
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.initials,
    required this.name,
    required this.message,
    required this.time,
    this.unread = 0,
    this.group = false,
    this.onTap,
  });

  final String initials;
  final String name;
  final String message;
  final String time;
  final int unread;
  final bool group;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryContainer,
                child: group
                    ? const Icon(Icons.groups, color: AppColors.primary)
                    : Text(
                        initials,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(time, style: Theme.of(context).textTheme.bodySmall),
                  if (unread > 0) ...[
                    const SizedBox(height: 6),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '$unread',
                        style: const TextStyle(
                          color: AppColors.surface,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
    required this.name,
    required this.subtitle,
    this.group = false,
  });

  final String name;
  final String subtitle;
  final bool group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryContainer,
              child: Icon(
                group ? Icons.groups : Icons.person,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Conversation details',
            onPressed: () {},
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const _DateDivider(label: 'Today'),
                if (group) const _SenderLabel(label: 'Marcus Chen • 10:24 AM'),
                const _MessageBubble(
                  message: 'I added notes for the log replication section.',
                  received: true,
                ),
                const SizedBox(height: 8),
                if (group)
                  const _SenderLabel(label: 'Elena Rostova • 10:28 AM'),
                const _MessageBubble(
                  message: 'Perfect. I will review them before 5:30.',
                  received: true,
                ),
                const SizedBox(height: 8),
                const _MessageBubble(
                  message: 'Great, let’s use the library room for practice.',
                  received: false,
                ),
                const SizedBox(height: 8),
                const _MessageBubble(
                  message: 'I will bring the midterm practice set.',
                  received: false,
                ),
              ],
            ),
          ),
          Container(
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
                  tooltip: 'Attach',
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file),
                ),
                Expanded(
                  child: TextField(
                    key: const Key('chat_message_field'),
                    decoration: const InputDecoration(
                      hintText: 'Write a message...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  key: const Key('chat_send_button'),
                  tooltip: 'Send',
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                  ),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _SenderLabel extends StatelessWidget {
  const _SenderLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.received});

  final String message;
  final bool received;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: received ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: received ? AppColors.surface : AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          border: received ? Border.all(color: AppColors.outline) : null,
        ),
        child: Text(
          message,
          style: TextStyle(
            color: received ? AppColors.textPrimary : AppColors.surface,
          ),
        ),
      ),
    );
  }
}
