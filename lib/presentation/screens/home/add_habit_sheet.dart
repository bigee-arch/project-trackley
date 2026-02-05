import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/habit_provider.dart';
import '../../../data/models/habit_model.dart';

class AddHabitSheet extends ConsumerStatefulWidget {
  const AddHabitSheet({super.key});

  @override
  ConsumerState<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends ConsumerState<AddHabitSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  // Defaults
  int _selectedColor = 0xFF6B4EFF; // Primary
  int _selectedIcon = 0xE1E1; // Icons.run_circle
  String _frequency = 'daily'; // 'daily' | 'weekly'

  final List<Color> _colors = [
    Color(0xFF6B4EFF), // Index 0 (Primary)
    Color(0xFFFF6B6B), // Red
    Color(0xFF4ECDC4), // Teal
    Color(0xFFFFD166), // Yellow
    Color(0xFF06D6A0), // Green
    Color(0xFF118AB2), // Blue
  ];

  final List<IconData> _icons = [
    Icons.run_circle,
    Icons.book,
    Icons.water_drop,
    Icons.fitness_center,
    Icons.code,
    Icons.bed,
    Icons.money,
    Icons.music_note,
    Icons.computer,
    Icons.brush,
  ];

  void _save() {
    if (_titleController.text.isEmpty) return;

    final habit = Habit(
      title: _titleController.text,
      description: _descController.text,
      color: _selectedColor,
      iconCode: _selectedIcon,
      frequencyType: _frequency,
      createdAt: DateTime.now(),
      frequencyDays: _frequency == 'daily' ? '1,2,3,4,5,6,7' : '',
    );

    ref.read(habitsProvider.notifier).addHabit(habit);
    ref.invalidate(todaysHabitsProvider); // Refresh today list
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create New Habit', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 20),

          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Habit Name',
              border: OutlineInputBorder(),
              hintText: 'e.g. Morning Run',
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          // Color Picker
          const Text('Color'),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final c = _colors[index];
                final isSelected = c.value == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = c.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Icon Picker
          const Text('Icon'),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _icons.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final icon = _icons[index];
                final isSelected = icon.codePoint == _selectedIcon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon.codePoint),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color(_selectedColor).withOpacity(0.2)
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Color(_selectedColor), width: 2)
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(icon,
                        color:
                            isSelected ? Color(_selectedColor) : Colors.grey),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _save,
              child: const Text('Create Habit'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
