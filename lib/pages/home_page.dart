import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:macro_calculator/controllers/data_controller.dart';
import 'package:macro_calculator/controllers/theme_controller.dart';
import 'package:macro_calculator/pages/results_page.dart';
import 'package:macro_calculator/utils/enums.dart';
import 'package:macro_calculator/utils/helpers.dart';
import 'package:macro_calculator/utils/textStyles.dart';
import 'package:macro_calculator/data/calculator.dart';
import 'package:macro_calculator/widgets/my_button.dart';
import 'package:macro_calculator/widgets/my_drop_down_menu.dart';
import 'package:macro_calculator/widgets/slider.dart';
import 'package:macro_calculator/widgets/tile.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dataController = Provider.of<DataController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Macro Calculator"),
        actions: [
          IconButton(
            tooltip: isThemeDark(context) ? 'Light Mode' : 'Dark Mode',
            icon: Icon(
              isThemeDark(context) ? EvaIcons.sunOutline : EvaIcons.moonOutline,
            ),
            onPressed: () =>
                Provider.of<ThemeController>(context, listen: false)
                    .toggleTheme(),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(6.0),
        children: [
          Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        icon: Icons.male,
                        title: 'Male',
                        selected: dataController.gender == Gender.male,
                        onTap: () => dataController.setGender(Gender.male),
                      ),
                    ),
                    spacer(width: 12),
                    Expanded(
                      child: MyButton(
                        icon: Icons.female,
                        title: 'Female',
                        selected: dataController.gender == Gender.female,
                        onTap: () => dataController.setGender(Gender.female),
                      ),
                    ),
                  ],
                ),

                spacer(height: 12),

                //! height slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Height",
                      style: MyTextStyles(context).cardTitle,
                    ),
                    Row(
                      children: [
                        Text(
                          "${dataController.height!.toStringAsFixed(0)}",
                          style: MyTextStyles(context).homeCardValue,
                        ),
                        Text(
                          "cm",
                          style: MyTextStyles(context).homeCardText,
                        ),
                      ],
                    ),
                  ],
                ),
                MyCustomSlider(
                  value: dataController.height!,
                  minValue: 100,
                  maxValue: 220,
                  onChanged: (value) => dataController.setHeight(value),
                ),

                //! weight slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Weight",
                      style: MyTextStyles(context).cardTitle,
                    ),
                    Row(
                      children: [
                        Text(
                          "${dataController.weight!.toStringAsFixed(0)}",
                          style: MyTextStyles(context).homeCardValue,
                        ),
                        Text(
                          "kg",
                          style: MyTextStyles(context).homeCardText,
                        ),
                      ],
                    ),
                  ],
                ),
                MyCustomSlider(
                  value: dataController.weight!,
                  minValue: 40,
                  maxValue: 150,
                  onChanged: (value) => dataController.setWeight(value),
                ),
                // age number picker
                Text(
                  "Age",
                  style: MyTextStyles(context).cardTitle,
                ),
                Center(
                  child: NumberPicker(
                    minValue: 12,
                    maxValue: 80,
                    itemCount: 7,
                    itemWidth: 47.2,
                    selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textStyle: TextStyle(color: colorScheme(context).tertiary),
                    value: dataController.age!,
                    axis: Axis.horizontal,
                    onChanged: (value) => dataController.setAge(value),
                  ),
                )
              ],
            ),
          ),

          //! second container
          Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Activity level",
                  style: MyTextStyles(context).cardTitle,
                ),
                MyDropDownMenu<ActivityLevel>(
                  items: ActivityLevel.values,
                  value: dataController.activityLevel!,
                  onChanged: (value) => dataController.setActivityLevel(value),
                ),
                SizedBox(height: 8),
                Text(
                  "Goal",
                  style: MyTextStyles(context).cardTitle,
                ),
                MyDropDownMenu<Goal>(
                  items: Goal.values,
                  value: dataController.goal!,
                  onChanged: (value) => dataController.setGoal(value),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Calculate',
        heroTag: 'fab',
        icon: Icon(Icons.done),
        label: Text('Calculate'),
        onPressed: () {
          Calculator calculator = Calculator(
            gender: dataController.gender!,
            height: dataController.height!,
            weight: dataController.weight!,
            age: dataController.age!,
            activityLevel: dataController.activityLevel!,
            goal: dataController.goal!,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                totalCalories: calculator.totalCalories(),
                carbs: calculator.carb(),
                protein: calculator.protein(),
                fats: calculator.fat(),
                bmi: calculator.bmi(),
                tdee: calculator.tdee(),
                bmiScale: calculator.bmiScale(),
              ),
            ),
          );
        },
      ),
    );
  }
}
