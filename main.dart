import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ToDoList(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'To-Do App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const ToDoListUIWidget(),
        ));
  }
}

class MyTask {
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  MyTask(this.name, this.description, this.startDate, this.endDate);
}

class ToDoList with ChangeNotifier {
  List<MyTask> myTasks = [
    MyTask('Relax', 'relax time after the day', '03.30 pm', '04.00 pm'),
    MyTask('Dinner', 'Eat the dinner', '04.00 pm', '05.00 pm'),
    MyTask('Study', 'Study your exam', '05.00 pm', '09.00 pm'),
    MyTask('Go to bed', 'Get ready to sleep', '09.00 pm', '09.15 pm'),
  ];
  void addTask(MyTask task) {
    myTasks.add(task);
    notifyListeners();
  }

  void removeTask(MyTask task) {
    myTasks.remove(task);
    notifyListeners();
  }
}

class ToDoListUIWidget extends StatefulWidget {
  const ToDoListUIWidget({super.key});

  @override
  State<ToDoListUIWidget> createState() => _ToDoListUIWidgetState();
}

class _ToDoListUIWidgetState extends State<ToDoListUIWidget> {
  @override
  Widget build(BuildContext context) {
    var toDoListObject = Provider.of<ToDoList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
      ),
      body: ListView.builder(
        itemCount: toDoListObject.myTasks.length,
        itemBuilder: (context, index) {
          var list = toDoListObject.myTasks[index];
          return Dismissible(
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (direction) {
                toDoListObject.removeTask(list);
              },
              key: Key(toDoListObject.myTasks.toString()[index]),
              child: ListWidget(list: list));
          //return ;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTask()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ignore: must_be_immutable
class ListWidget extends StatelessWidget {
  MyTask list;

  ListWidget({super.key, required this.list});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.add_home_work),
        title: Text(list.name),
        subtitle: Text(list.description),
        trailing: Text("${list.startDate} ${list.endDate}"),
      ),
    );
  }
}

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var toDoListObject = Provider.of<ToDoList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: startDateController,
              decoration: const InputDecoration(labelText: 'Start Date'),
            ),
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(labelText: 'End Date'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  var newTask = MyTask(
                      nameController.text,
                      descriptionController.text,
                      startDateController.text,
                      endDateController.text);
                  toDoListObject.addTask(newTask);
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
