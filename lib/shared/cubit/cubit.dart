import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/shared/cubit/states.dart';

import '../../modules/archived_tasks_screen.dart';
import '../../modules/done_tasks_screen.dart';
import '../../modules/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit(): super(AppInitialState());

  static AppCubit get(context)=> BlocProvider.of(context);

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

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> tasks = [];
  bool isBottomSheetShown = false;
  IconData pIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow,required IconData icon}){
    isBottomSheetShown = isShow;
    pIcon = icon;
  }

  void createDatabase() {
    // open the database
    openDatabase('todo.db',version: 1,
        onCreate: (Database database, int version) async{
          await database.execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,date TEXT,time TEXT,status TEXT)'
          );
        },
        onOpen: (database) {
          getDataFromDatabase(database).then((value) {
            tasks = value;
            emit(AppGetDataBaseState());
          });
          print('Database opened');
        }
    ).then((value){
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({required String title, required String time, required String date}) {
    // Insert some records in a transaction
    return database.transaction((txn) async{
      await txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status)  VALUES("$title","$date","$time","new")'
      ).then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDataBaseState());
        getDataFromDatabase(database).then((value) {
          tasks = value;
          emit(AppGetDataBaseState());
        });

      });
      return null;
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async{
    emit(AppGetDataBaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks');
  }

  void updateDataBase({required String status,required int id}) {
    // Update some record
    database.rawUpdate(
        'UPDATE tasks SET status = ?, WHERE id = ?',
        [status, id]
    ).then((value) {
          emit(AppUpdateDataBaseState());
    });
  }
}
