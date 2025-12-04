import 'package:flutter/material.dart';

// Data
import '../../../data/workout_repository.dart';
import '../../../data/workout_model.dart' show Exercise;

class ExerciseList extends StatelessWidget {
  final List<Exercise> exercises;
  final Map<int, int> variationsCount;
  final Map<int, String> primaryMuscleGroups;
  final ExerciseRepository? exerciseRepo;

  const ExerciseList({
    super.key,
    required this.exercises,
    required this.variationsCount,
    required this.primaryMuscleGroups,
    this.exerciseRepo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '${exercises.length} Results',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).cardColor,
            ),
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ExerciseListItem(
                  exerciseId: exercise.id,
                  exerciseName: exercise.name,
                  muscleGroup: primaryMuscleGroups[exercise.id] ?? 'N/A',
                  type: exercise.type ?? 'N/A',
                  imgPath: exercise.iconPath,
                  variations: variationsCount[exercise.id] ?? 0,
                  isFavourite: exercise.isFavourite,
                  exerciseRepo: exerciseRepo,
                  onTap: () {},
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class ExerciseListItem extends StatefulWidget {
  final int exerciseId;
  final String exerciseName;
  final String muscleGroup;
  final String type;
  final String? imgPath;
  final int variations;
  final bool isFavourite;
  final VoidCallback? onTap;
  final ExerciseRepository? exerciseRepo;

  const ExerciseListItem({
    required this.exerciseId,
    required this.exerciseName,
    required this.muscleGroup,
    required this.type,
    this.imgPath,
    required this.variations,
    required this.isFavourite,
    this.onTap,
    this.exerciseRepo,
  });

  @override
  State<ExerciseListItem> createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<ExerciseListItem> {
  late bool _isFavourite;

  @override
  void initState() {
    super.initState();
    _isFavourite = widget.isFavourite;
  }

  void _toggleFavourite() {
    setState(() {
      _isFavourite = !_isFavourite;
    });
    widget.exerciseRepo?.toggleFavouriteExercise(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    final variationText = widget.variations == 1 ? 'Variation' : 'Variations';

    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          spacing: 12,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: _getIllustration(widget.exerciseName, widget.imgPath),
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exerciseName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 24,
                    children: [
                      Text(widget.muscleGroup, style: TextStyle(fontSize: 12),),
                      Text(widget.type, style: TextStyle(fontSize: 12),),
                      Text(
                        '${widget.variations} $variationText',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isFavourite
                  ? IconButton(
                      icon: Icon(Icons.star_rounded, color: Colors.amber),
                      onPressed: _toggleFavourite,
                    )
                  : IconButton(
                      icon: Icon(Icons.star_border_rounded, color: Colors.grey[700]),
                      onPressed: _toggleFavourite,
                    )
            )
          ],
        ),
      ),
    );
  }

  Widget _getIllustration(String name, String? imgPath) {
    if (imgPath != null) {
      return Image.asset(imgPath);
    }
    
    final firstChar = name[0];
    return Text(
      firstChar, 
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.grey[700]
        ),
      );
  }
}