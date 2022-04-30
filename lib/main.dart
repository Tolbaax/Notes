import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_app/layout/home_layout.dart';
import 'package:task_app/shared/cubit/bloc_observer.dart';
import 'package:task_app/shared/cubit/cubit.dart';

void main() {
  BlocOverrides.runZoned(
        () {
          AppCubit();
          runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
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

