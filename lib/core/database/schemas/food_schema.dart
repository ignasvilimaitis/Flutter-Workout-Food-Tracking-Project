class FoodSchema {
  static const createCategoryTable = '''
      CREATE TABLE Category (
        pk_category_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''';

  static const createDiaryEntryTable = '''
      CREATE TABLE DiaryEntry (
        pk_diaryentry_id INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_category_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (fk_category_id) REFERENCES Category(pk_category_id)
      );
    ''';
    
  static const createFoodItemTable = '''
      CREATE TABLE FoodItem (
        pk_fooditem_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT,
        calories REAL,
        carbohydrates REAL,
        fat REAL,
        protein REAL,
        nutrients TEXT,
        serving_size TEXT,
        is_favourite BOOLEAN,
        is_custom BOOLEAN,
        last_used INTEGER NOT NULL 
      );
    ''';

  static const createMealTable = '''
      CREATE TABLE Meal (
        pk_meal_id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      );
    ''';

  static const createDiaryEntryFoodItemTable = '''
      CREATE TABLE DiaryEntryFoodItem (
        pk_diaryentry_fooditem INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_diary_entry_id INTEGER NOT NULL,
        fk_food_item_id INTEGER NOT NULL,
        fk_meal_id INTEGER,
        quantity REAL NOT NULL,

        FOREIGN KEY (fk_diary_entry_id) REFERENCES DiaryEntry(pk_diaryentry_id),
        FOREIGN KEY (fk_food_item_id) REFERENCES FoodItem(pk_fooditem_id),
        FOREIGN KEY (fk_meal_id) REFERENCES Meal(pk_meal_id)
      );
    ''';

  static const createMealFoodItemTable = '''
      CREATE TABLE MealFoodItem (
        pk_mealfood_id INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_id INTEGER NOT NULL,
        food_item_id INTEGER NOT NULL,
        quantity REAL NOT NULL, 

        FOREIGN KEY (meal_id) REFERENCES Meal(pk_meal_id),
        FOREIGN KEY (food_item_id) REFERENCES FoodItem(pk_fooditem_id)
      );
    ''';
}
