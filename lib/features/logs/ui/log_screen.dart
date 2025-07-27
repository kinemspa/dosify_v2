import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/dose_log_provider.dart';
import 'package:dosify_v2/core/data/models/dose_log.dart';

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(doseLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dose Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: LogSearchDelegate(ref),
              );
            },
          ),
        ],
      ),
      body: logsAsync.when(
        data: (logs) => ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return ListTile(
              title: Text('Taken: ${log.amountTaken} at ${log.takenTime.toLocal()}'),
              subtitle: Text('Notes: ${log.notes ?? 'None'} | Reaction: ${log.reaction ?? 'None'}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Implement edit log (open form dialog)
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class LogSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  LogSearchDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final logsAsync = ref.watch(doseLogsProvider);
    return logsAsync.when(
      data: (logs) {
        final filtered = logs.where((log) =>
        log.notes?.toLowerCase().contains(query.toLowerCase()) ?? false ||
            log.reaction?.toLowerCase().contains(query.toLowerCase()) ?? false,
        ).toList();
        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final log = filtered[index];
            return ListTile(
              title: Text('Taken: ${log.amountTaken} at ${log.takenTime.toLocal()}'),
              subtitle: Text('Notes: ${log.notes ?? 'None'} | Reaction: ${log.reaction ?? 'None'}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink(); // Suggestions can be added later for efficiency
  }
}