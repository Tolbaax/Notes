import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/shared/cubit/cubit.dart';
import 'package:task_app/shared/cubit/states.dart';
import '../shared/components/components.dart';


class HomeLayout extends StatelessWidget {

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (BuildContext context)=> AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit,AppStates>(
          listener: (BuildContext context,AppStates state) {
            if(state is AppInsertToDataBaseState) {
              Navigator.pop(context);
            }
          } ,
          builder: (BuildContext context,AppStates state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.teal.shade700,
                title: Center(
                  child: Text(
                    cubit.titles[cubit.currentIndex],
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text);
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
                                    },
                                    label: 'Task Time',
                                    type: TextInputType.datetime,
                                    prefix: Icons.watch_later_outlined,
                                    onTab: () {
                                      showTimePicker(context: context, initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text = value!.format(context).toString();
                                      });
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
                                    },
                                    label: 'Task date',
                                    type: TextInputType.datetime,
                                    prefix: Icons.date_range,
                                    onTab: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2030))
                                          .then((value) {
                                        dateController.text = DateFormat.yMMMd().format(value!);
                                      });
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
                      cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                      formKey.currentState?.reset();
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                backgroundColor: Colors.teal.shade400,
                child: Icon(
                  cubit.pIcon,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.teal,
                currentIndex: AppCubit.get(context).currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
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
              body: ConditionalBuilder(
                builder: (context)=> cubit.screens[cubit.currentIndex],
                condition: state is! AppGetDataBaseLoadingState,
                fallback: (context)=> const Center(child: CircularProgressIndicator(),),
              ),
            );
          } ,
        )
      ),
    );
  }
}