import 'package:flutter/material.dart';

// Data
import '../../../data/workout_model.dart' show Exercise;

// ================================= All Exercises List =================================

class ExerciseList extends StatefulWidget {
  final List<Exercise> exercises;
  final Map<int, int> variationsCount;
  final Map<int, String> primaryMuscleGroups;
  final void Function(int exerciseId)? onFavouriteChanged;

  const ExerciseList({
    super.key,
    required this.exercises,
    required this.variationsCount,
    required this.primaryMuscleGroups,
    required this.onFavouriteChanged,
  });

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '${widget.exercises.length} Results',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).cardColor,
            ),
            child: ListView.builder(
              itemCount: widget.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.exercises[index];
                return ExerciseListItem(
                  exerciseId: exercise.id,
                  exerciseName: exercise.name,
                  muscleGroup: widget.primaryMuscleGroups[exercise.id] ?? 'N/A',
                  type: exercise.type ?? 'N/A',
                  imgPath: exercise.iconPath,
                  variations: widget.variationsCount[exercise.id] ?? 0,
                  isFavourite: exercise.isFavourite,
                  onFavouriteChanged: widget.onFavouriteChanged,
                  onTap: () {},
                );
              },
            ),
          ),
        ),
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
  final void Function(int exerciseId)? onFavouriteChanged;

  const ExerciseListItem({
  required this.exerciseId,
  required this.exerciseName,
  required this.muscleGroup,
  required this.type,
  this.imgPath,
  required this.variations,
  required this.isFavourite,
  this.onTap,
  required this.onFavouriteChanged,
});

  @override
  State<ExerciseListItem> createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<ExerciseListItem> {

  @override
  void initState() {
    super.initState();
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
              child: widget.isFavourite
                  ? IconButton(
                      icon: Icon(Icons.star_rounded, color: Colors.amber),
                      onPressed: () => widget.onFavouriteChanged?.call(widget.exerciseId),
                    )
                  : IconButton(
                      icon: Icon(Icons.star_border_rounded, color: Colors.grey[700]),
                      onPressed: () => widget.onFavouriteChanged?.call(widget.exerciseId),
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