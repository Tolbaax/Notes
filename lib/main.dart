import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_app/layout/home_layout.dart';
import 'package:task_app/shared/cubit/bloc_observer.dart';
import 'package:task_app/shared/cubit/cubit.dart';
import 'package:task_app/shared/cubit/states.dart';

void main() {
  BlocOverrides.runZoned(
        () {
          AppCubit();
          AppStates();
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}

