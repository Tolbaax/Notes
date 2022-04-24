import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:task_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  required String? Function(String?) validate,
  required TextEditingController controller,
  void Function()? suffixPressed,
  required TextInputType type,
  required IconData prefix,
  required String label,
  bool readOnly = false,
  Function()? onTab,
  bool isPassword = false,
  IconData? suffix,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validate,
      obscureText: isPassword,
      onTap: onTab,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
          color: Colors.blue,
        ),
        suffixIcon: IconButton(
          icon: Icon(suffix),
          onPressed: suffixPressed,
        ),
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, BuildContext context) => Dismissible(

  key: Key(model['id'].toString()),
  child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDataBase(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDataBase(status: 'archive', id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.grey.shade800,
                )),
          ],
        ),
      ),
  onDismissed: (direction) {
    AppCubit.get(context).deleteDataBase(id: model['id']);
  },
  background: Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    color: Colors.red,
    child: const Icon(Icons.delete_forever,size: 30.0,color: Colors.white,),
  ),
  direction: DismissDirection.startToEnd,
    );

Widget tasksBuilder(List<Map> tasks)=> ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder: (context)=> ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
      separatorBuilder: (context,index)=>Padding(
        padding: const EdgeInsetsDirectional.only(start: 20.0),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length
  ),
  fallback: (context)=> Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.edit_note_sharp,size: 100,color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'No notes here yet',
          style: TextStyle(fontSize: 17,color: Colors.grey),
        ),
      ],
    ),
  ),
);
