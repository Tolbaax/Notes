import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/shared/cubit/states.dart';
import '../../modules/archived_tasks_screen.dart';
import '../../modules/done_tasks_screen.dart';
import '../../modules/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  // to more easily when use this cubit in many places
  static AppCubit get(context) => BlocProvider.of(context);

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks',];
  List<Widget> screens = [const NewTasksScreen(), const DoneTasksScreen(), const ArchivedTasksScreen(),];
  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool isBottomSheetShown = false;
  IconData pIcon = Icons.edit;

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    pIcon = icon;
  }

  late Database database;

  // 1. create database
  // 2. create tables
  // 3. Open database
  // 4. insert db
  // 5. get from db
  // 6. update in db
  // 7. delete from db

  void createDatabase()  {
    // open the database
    openDatabase('task.db',version: 1,
      onCreate: (Database database,int version) async{
      await database.execute(

        // id INTEGER
        // title STRING
        // date STRING
        // time STRING
        // status STRING
        // STRING => TEXT
        //[status TEXT] => (column name, data type)

        'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,date TEXT,time TEXT,status TEXT )'
      );
      print('database created');
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      }
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({required String title, required String time, required String date}) {
    // Insert some records in a transaction
    return database.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO tasks(title,date,time,status)  VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDataBaseState());
        getDataFromDatabase(database);
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDataBaseLoadingState());
    // Get the records
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        }
        else if (element['status'] == 'done') {
          doneTasks.add(element);
        }
        else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateDataBase({required String status, required int id}) {
    // Update some record
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteDataBase({required int id}) {
    // Delete a record
    database.rawDelete(
        'DELETE FROM  tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }

}
