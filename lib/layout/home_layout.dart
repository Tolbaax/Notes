import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../modules/archived_tasks_screen.dart';
import '../modules/done_tasks_screen.dart';
import '../modules/new_tasks_screen.dart';
import '../shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData pIcon = Icons.edit;
  late Database database;
  showTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      timeController.text = value!.format(context).toString();
    });
  }
  showDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030))
        .then((value) {
      dateController.text = DateFormat.yMMMd().format(value!);
    });
  }

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            titles[currentIndex],
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text,
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  pIcon = Icons.edit;
                });
              });
            }
          } else {
            scaffoldKey.currentState
                ?.showBottomSheet(
                    (context) => Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter title';
                                      }
                                      return null;
                                    },
                                    label: 'Task Title',
                                    type: TextInputType.text,
                                    prefix: Icons.title,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  defaultFormField(
                                    controller: timeController,
                                    readOnly: true,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter time';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    type: TextInputType.datetime,
                                    prefix: Icons.watch_later_outlined,
                                    onTab: () {
                                      showTime();
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  defaultFormField(
                                    controller: dateController,
                                    readOnly: true,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter date';
                                      }
                                      return null;
                                    },
                                    label: 'Task date',
                                    type: TextInputType.datetime,
                                    prefix: Icons.date_range,
                                    onTab: () {
                                      showDate();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                    elevation: 40.0)
                .closed
                .then((value) {
              isBottomSheetShown = false;
              setState(() {
                pIcon = Icons.edit;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              pIcon = Icons.add;
            });
          }
        },
        child: Icon(
          pIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.done_outline_outlined,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archived',
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }


  void createDatabase() async{
    // open the database
    database = await openDatabase('todo.db',version: 1,
      onCreate: (Database database, int version) async{
      await database.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,date TEXT,time TEXT,status TEXT)'
      );
      },
      onOpen: (database) {
        print('Database opened');
      }
    );
  }

  Future insertToDatabase({required String title, required String time, required String date}) {
    // Insert some records in a transaction
    return database.transaction((txn) async{
      await txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status)  VALUES("$title","$date","$time","new")'
      );
      return null;
    });
  }

}
