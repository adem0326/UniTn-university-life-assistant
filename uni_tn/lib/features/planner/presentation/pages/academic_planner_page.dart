import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AcademicPlannerPage extends StatefulWidget {
  const AcademicPlannerPage({super.key});

  @override
  State<AcademicPlannerPage> createState() => _AcademicPlannerPageState();
}

class _AcademicPlannerPageState extends State<AcademicPlannerPage> {
  static final DateTime _initialDate = DateTime(2024, 10, 16);

  String _view = 'Week';
  String _filter = 'All';
  DateTime _selectedDate = _initialDate;
  int _nextId = 6;
  final List<_PlannerEvent> _events = [
    _PlannerEvent(
      id: 1,
      title: 'CS106B Programming Abstractions',
      type: 'Lecture',
      location: 'Turing Hall 101 • Main Campus',
      start: DateTime(2024, 10, 16, 9),
      end: DateTime(2024, 10, 16, 10, 15),
    ),
    _PlannerEvent(
      id: 2,
      title: 'MATH51 Linear Algebra & Multivariable',
      type: 'Discussion',
      location: 'Math Corner Room 20 • Quad B',
      start: DateTime(2024, 10, 16, 11, 30),
      end: DateTime(2024, 10, 16, 12, 45),
    ),
    _PlannerEvent(
      id: 3,
      title: 'CS147 HCI Project Review',
      type: 'Lab',
      location: 'd.school Studio 02 • Prototype Bay',
      start: DateTime(2024, 10, 16, 14),
      end: DateTime(2024, 10, 16, 15, 30),
    ),
    _PlannerEvent(
      id: 4,
      title: 'Linear Algebra Problem Set 5',
      type: 'Assignment',
      location: 'Due tomorrow • 5:00 PM',
      start: DateTime(2024, 10, 17, 17),
    ),
    _PlannerEvent(
      id: 5,
      title: 'Operating Systems Midterm',
      type: 'Exam',
      location: 'In 3 days • 120 minutes',
      start: DateTime(2024, 10, 19, 10),
    ),
  ];

  List<DateTime> get _weekDates {
    final weekStart = DateUtils.dateOnly(
      _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1)),
    );
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }

  List<_PlannerEvent> get _visibleEvents {
    final events = _events.where((event) {
      final matchesDate = _view == 'Agenda'
          ? !DateUtils.dateOnly(event.start)
                .isBefore(DateUtils.dateOnly(_selectedDate))
          : DateUtils.isSameDay(event.start, _selectedDate);
      final matchesFilter =
          _filter == 'All' ||
          (_filter == 'Lectures' &&
              ['Lecture', 'Discussion', 'Lab'].contains(event.type)) ||
          (_filter == 'Exams' && event.type == 'Exam') ||
          (_filter == 'Assignments' && event.type == 'Assignment') ||
          (_filter == 'Personal' && event.type == 'Personal');
      return matchesDate && matchesFilter;
    }).toList()..sort((a, b) => a.start.compareTo(b.start));
    return events;
  }

  int get _weekNumber {
    final selectedWeekStart = DateUtils.dateOnly(
      _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1)),
    );
    final initialWeekStart = DateUtils.dateOnly(
      _initialDate.subtract(Duration(days: _initialDate.weekday - 1)),
    );
    return 4 + selectedWeekStart.difference(initialWeekStart).inDays ~/ 7;
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = _events
        .where((event) => DateUtils.isSameDay(event.start, _selectedDate))
        .toList();
    final classCount = dayEvents
        .where((event) => ['Lecture', 'Discussion', 'Lab'].contains(event.type))
        .length;
    final taskCount = dayEvents
        .where((event) => event.isTask && !event.isCompleted)
        .length;
    final deadlines = _events.where((event) => event.isTask).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final openDeadlineCount = deadlines
        .where((event) => !event.isCompleted)
        .length;
    final visibleEvents = _visibleEvents;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        title: const Text('Academic Planner'),
        backgroundColor: const Color(0xFFFAF8FF),
        actions: [
          IconButton.filled(
            key: const Key('planner_add_event'),
            tooltip: 'Add planner item',
            onPressed: _showAddEventDialog,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
            ),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _view == 'Month'
                          ? _formatMonth(_selectedDate)
                          : 'Fall 2024',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Stanford Quad • Autumn Quarter',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('planner_previous_week'),
                tooltip: _periodTooltip(-1),
                visualDensity: VisualDensity.compact,
                onPressed: () => _movePeriod(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _view == 'Month' ? 'Month' : 'Week $_weekNumber',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                key: const Key('planner_next_week'),
                tooltip: _periodTooltip(1),
                visualDensity: VisualDensity.compact,
                onPressed: () => _movePeriod(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PlannerViewSelector(
            selectedView: _view,
            onSelect: (view) => setState(() => _view = view),
          ),
          const SizedBox(height: 18),
          if (_view == 'Month')
            _MonthGrid(
              selectedDate: _selectedDate,
              events: _events,
              onSelectDate: (date) => setState(() => _selectedDate = date),
            )
          else
            _WeekRibbon(
              dates: _weekDates,
              selectedDate: _selectedDate,
              events: _events,
              onSelectDate: (date) => setState(() => _selectedDate = date),
            ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(_selectedDate),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$classCount classes scheduled • $taskCount tasks due',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in [
                  'All',
                  'Exams',
                  'Assignments',
                  'Lectures',
                  'Personal',
                ]) ...[
                  ChoiceChip(
                    key: Key('planner_filter_$filter'),
                    label: Text(filter),
                    selected: _filter == filter,
                    onSelected: (_) => setState(() => _filter = filter),
                    backgroundColor: const Color(0xFFEEF0FF),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: _filter == filter
                          ? AppColors.surface
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    showCheckmark: false,
                    side: BorderSide.none,
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  _view == 'Agenda'
                      ? 'Upcoming agenda'
                      : 'Timeline • ${_formatDate(_selectedDate)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Text(
                '${visibleEvents.length} ${visibleEvents.length == 1 ? 'item' : 'items'}',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (visibleEvents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                children: [
                  const Icon(
                    Icons.event_available_outlined,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nothing scheduled for this view.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: _showAddEventDialog,
                    child: const Text('Add a planner item'),
                  ),
                ],
              ),
            )
          else
            for (var index = 0; index < visibleEvents.length; index++) ...[
              _TimelineEventCard(
                event: visibleEvents[index],
                isLast: index == visibleEvents.length - 1,
                onToggleComplete: visibleEvents[index].isTask
                    ? (value) => _toggleComplete(visibleEvents[index], value)
                    : null,
              ),
              const SizedBox(height: 8),
            ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Upcoming Deadlines',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (openDeadlineCount > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$openDeadlineCount due',
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              TextButton(
                onPressed: () => setState(() => _view = 'Agenda'),
                child: const Text('View all'),
              ),
            ],
          ),
          for (final event in deadlines)
            _DeadlineCard(
              event: event,
              onToggleComplete: (value) => _toggleComplete(event, value),
            ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.surface,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Optimal Focus Window Today',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Free interval: 03:45 PM – 05:30 PM. Perfect for a focused study session.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _showAddEventDialog,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(0, 38),
                  ),
                  child: const Text('Block time'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _movePeriod(int offset) {
    setState(() {
      if (_view == 'Month') {
        final targetMonth = DateTime(
          _selectedDate.year,
          _selectedDate.month + offset,
          1,
        );
        final lastDay = DateTime(
          targetMonth.year,
          targetMonth.month + 1,
          0,
        ).day;
        _selectedDate = DateTime(
          targetMonth.year,
          targetMonth.month,
          _selectedDate.day.clamp(1, lastDay).toInt(),
        );
      } else {
        final days = _view == 'Day' ? 1 : 7;
        _selectedDate = _selectedDate.add(Duration(days: days * offset));
      }
    });
  }

  String _periodTooltip(int offset) {
    final direction = offset < 0 ? 'Previous' : 'Next';
    final period = switch (_view) {
      'Month' => 'month',
      'Day' => 'day',
      _ => 'week',
    };
    return '$direction $period';
  }

  void _toggleComplete(_PlannerEvent event, bool? completed) {
    final index = _events.indexWhere((item) => item.id == event.id);
    if (index < 0) return;
    setState(() {
      _events[index] = event.copyWith(isCompleted: completed ?? false);
    });
  }

  Future<void> _showAddEventDialog() async {
    final event = await showDialog<_PlannerEvent>(
      context: context,
      builder: (context) => _AddPlannerEventDialog(initialDate: _selectedDate),
    );
    if (!mounted || event == null) return;
    setState(() {
      _events.add(event.copyWith(id: _nextId++));
      _selectedDate = DateUtils.dateOnly(event.start);
      _filter = 'All';
      _view = 'Day';
    });
  }
}

class _PlannerViewSelector extends StatelessWidget {
  const _PlannerViewSelector({
    required this.selectedView,
    required this.onSelect,
  });

  final String selectedView;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    const views = ['Month', 'Week', 'Day', 'Agenda'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF0FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          for (final view in views)
            Expanded(
              child: InkWell(
                key: Key('planner_view_$view'),
                borderRadius: BorderRadius.circular(999),
                onTap: () => onSelect(view),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: selectedView == view
                        ? AppColors.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    view,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selectedView == view
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: selectedView == view
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WeekRibbon extends StatelessWidget {
  const _WeekRibbon({
    required this.dates,
    required this.selectedDate,
    required this.events,
    required this.onSelectDate,
  });

  final List<DateTime> dates;
  final DateTime selectedDate;
  final List<_PlannerEvent> events;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final date in dates)
          _DateBubble(
            date: date,
            selected: DateUtils.isSameDay(date, selectedDate),
            hasEvent: events.any(
              (event) => DateUtils.isSameDay(event.start, date),
            ),
            onTap: () => onSelectDate(date),
          ),
      ],
    );
  }
}

class _DateBubble extends StatelessWidget {
  const _DateBubble({
    required this.date,
    required this.selected,
    required this.hasEvent,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final bool hasEvent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return InkWell(
      key: Key('planner_date_${date.day}'),
      borderRadius: BorderRadius.circular(17),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 66,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(17),
          border: selected ? null : Border.all(color: AppColors.outline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekdays[date.weekday - 1],
              style: TextStyle(
                color: selected ? AppColors.surface : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${date.day}',
              style: TextStyle(
                color: selected ? AppColors.surface : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Icon(
              Icons.circle,
              size: 5,
              color: hasEvent
                  ? (selected ? AppColors.surface : AppColors.primary)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.selectedDate,
    required this.events,
    required this.onSelectDate,
  });

  final DateTime selectedDate;
  final List<_PlannerEvent> events;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(selectedDate.year, selectedDate.month);
    final gridStart = firstOfMonth.subtract(
      Duration(days: firstOfMonth.weekday - 1),
    );
    final dates = List.generate(
      35,
      (index) => gridStart.add(Duration(days: index)),
    );
    const weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Column(
      children: [
        Row(
          children: [
            for (final label in weekdayLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dates.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final date = dates[index];
            final isSelected = DateUtils.isSameDay(date, selectedDate);
            final inMonth = date.month == selectedDate.month;
            final hasEvent = events.any(
              (event) => DateUtils.isSameDay(event.start, date),
            );
            return InkWell(
              key: Key('planner_month_date_${date.day}_${date.month}'),
              borderRadius: BorderRadius.circular(10),
              onTap: () => onSelectDate(date),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.surface
                            : (inMonth
                                  ? AppColors.textPrimary
                                  : AppColors.outlineVariant),
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                    if (hasEvent)
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.surface
                              : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TimelineEventCard extends StatelessWidget {
  const _TimelineEventCard({
    required this.event,
    required this.isLast,
    required this.onToggleComplete,
  });

  final _PlannerEvent event;
  final bool isLast;
  final ValueChanged<bool?>? onToggleComplete;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.type);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 58,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, right: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(event.start),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                      ),
                    ),
                    if (event.end != null)
                      Text(
                        _formatTime(event.end!),
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(fontSize: 10),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 24,
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.22),
                          blurRadius: 0,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.only(top: 3),
                        color: AppColors.outline,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF0EFF8)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F172A),
                      blurRadius: 12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  decoration: event.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                          ),
                        ),
                        _EventTypeChip(type: event.type),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: color,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    if (event.isTask) ...[
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Checkbox(
                            key: Key('planner_complete_${event.id}'),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: event.isCompleted,
                            onChanged: onToggleComplete,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.isCompleted ? 'Completed' : 'Mark complete',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  const _DeadlineCard({required this.event, required this.onToggleComplete});

  final _PlannerEvent event;
  final ValueChanged<bool?> onToggleComplete;

  @override
  Widget build(BuildContext context) {
    final isExam = event.type == 'Exam';
    final color = isExam ? AppColors.danger : AppColors.primary;
    return Container(
      key: Key('planner_deadline_${event.id}'),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0EFF8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isExam ? Icons.event_busy_outlined : Icons.assignment_outlined,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    decoration: event.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 13, color: color),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${_formatDate(event.start)} • ${_formatTime(event.start)}',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: color),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  event.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Checkbox(
            key: Key('planner_deadline_complete_${event.id}'),
            visualDensity: VisualDensity.compact,
            value: event.isCompleted,
            onChanged: onToggleComplete,
          ),
        ],
      ),
    );
  }
}

class _EventTypeChip extends StatelessWidget {
  const _EventTypeChip({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AddPlannerEventDialog extends StatefulWidget {
  const _AddPlannerEventDialog({required this.initialDate});

  final DateTime initialDate;

  @override
  State<_AddPlannerEventDialog> createState() => _AddPlannerEventDialogState();
}

class _AddPlannerEventDialogState extends State<_AddPlannerEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  late DateTime _date = widget.initialDate;
  TimeOfDay _time = const TimeOfDay(hour: 15, minute: 45);
  String _type = 'Assignment';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add planner item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('planner_event_title'),
                controller: _titleController,
                autofocus: false,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a title'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('planner_event_location'),
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location or notes',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: const Key('planner_event_type'),
                initialValue: _type,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const ['Assignment', 'Exam', 'Lecture', 'Personal']
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      key: const Key('planner_event_date'),
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(_formatDate(_date)),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      key: const Key('planner_event_time'),
                      onPressed: _pickTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(_time.format(context)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const Key('planner_event_save'),
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (date != null) setState(() => _date = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(context: context, initialTime: _time);
    if (time != null) setState(() => _time = time);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final start = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );
    Navigator.of(context).pop(
      _PlannerEvent(
        id: 0,
        title: _titleController.text.trim(),
        type: _type,
        location: _locationController.text.trim().isEmpty
            ? 'No location added'
            : _locationController.text.trim(),
        start: start,
      ),
    );
  }
}

class _PlannerEvent {
  const _PlannerEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.location,
    required this.start,
    this.end,
    this.isCompleted = false,
  });

  final int id;
  final String title;
  final String type;
  final String location;
  final DateTime start;
  final DateTime? end;
  final bool isCompleted;

  bool get isTask => ['Assignment', 'Exam', 'Personal'].contains(type);

  _PlannerEvent copyWith({int? id, bool? isCompleted}) {
    return _PlannerEvent(
      id: id ?? this.id,
      title: title,
      type: type,
      location: location,
      start: start,
      end: end,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

Color _eventColor(String type) {
  return switch (type) {
    'Exam' => AppColors.danger,
    'Assignment' => AppColors.primary,
    'Lab' => AppColors.cyan,
    'Discussion' => AppColors.secondary,
    _ => AppColors.primary,
  };
}

String _formatDate(DateTime date) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
}

String _formatMonth(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.year}';
}

String _formatTime(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour < 12 ? 'AM' : 'PM';
  return '$hour:$minute $period';
}
