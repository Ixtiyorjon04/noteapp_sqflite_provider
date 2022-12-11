import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp_sqflite_provider/handler/db_handler.dart';
import 'package:noteapp_sqflite_provider/screen/home_screen.dart';

import '../model/model.dart';

class AddUpdateTask extends StatefulWidget {

  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDT;
  bool? update;


  AddUpdateTask({
      this.todoId, this.todoTitle,this.todoDT, this.todoDesc, this.update});


  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<NoteModel>> dataList;
  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(text: widget.todoTitle);
    final TextEditingController descController = TextEditingController(text: widget.todoDesc);
    String appTitle;
    if(widget.update == true){
      appTitle = "Update Task";
    }else{
      appTitle = "Add Task";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _fromKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: titleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Note Title',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 5,
                          controller: descController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Write notes here',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          if (_fromKey.currentState!.validate()) {
                          if(widget.update == true){
                            dbHelper!.update(NoteModel(
                              id: widget.todoId,
                                title: titleController.text,
                                desc: descController.text,
                              dateandtime: widget.todoDT
                              )
                            );
                          }else{
                            dbHelper!.insert(NoteModel(
                                title: titleController.text,
                                desc: descController.text,
                                dateandtime: DateFormat('yMd')
                                    .add_jm()
                                    .format(DateTime.now())
                                    .toString()));
                          }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                            titleController.clear();
                            descController.clear();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: 120,
                          height: 55,
                          decoration: const BoxDecoration(boxShadow: [
                            // BoxShadow(
                            //   color: Colors.black12,
                            //   blurRadius: 5,
                            //   spreadRadius: 1,
                            // )
                          ]),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            titleController.clear();
                            descController.clear();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: 120,
                          height: 55,
                          decoration: const BoxDecoration(boxShadow: [
                            // BoxShadow(
                            //   color: Colors.black12,
                            //   blurRadius: 5,
                            //   spreadRadius: 1,
                            // )
                          ]),
                          child: Text(
                            'Clear',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
