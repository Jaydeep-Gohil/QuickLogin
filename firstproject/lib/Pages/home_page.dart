import 'package:flutter/material.dart';
import 'package:firstproject/Pages/profile_page.dart';
import 'package:firstproject/Pages/settings_page.dart';
import 'package:firstproject/Services/auth_service.dart';
import 'package:firstproject/Pages/login_page.dart'; // Make sure this exists!

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userRole = "User";
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _homePageContent(),
      ProfilePage(),
      SettingsPage(),
      TodoPage(),
    ];
    loadUserRole();
  }

  Widget _homePageContent() {
    return Center(
      child: Text(
        userRole == "Admin" ? "Welcome, Admin! Manage Users." : "Welcome, User! Browse Content",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  void loadUserRole() async {
    String role = await AuthService().getUserRole();
    setState(() {
      userRole = role;
      _pages[0] = _homePageContent();
    });
  }

  void logout() async {
    await AuthService().logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _titles = ["Home", "Profile", "Settings", "To-Do"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_titles[_selectedIndex]} - $userRole"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // <--- ensure all items show
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: "To-Do"),
        ],
      ),
    );
  }
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<TodoItem> tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      tasks.add(TodoItem(title: text));
      _taskController.clear();
    });
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _editTask(int index) {
    final editController = TextEditingController(text: tasks[index].title);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Task"),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            labelText: "Task",
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Save"),
            onPressed: () {
              if (editController.text.trim().isEmpty) return;
              setState(() {
                tasks[index].title = editController.text.trim();
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
              labelText: "Enter new task",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.add_circle, color: Colors.deepPurple),
                onPressed: _addTask,
              ),
            ),
            onSubmitted: (_) => _addTask(),
          ),
          SizedBox(height: 16),
          Expanded(
            child: tasks.isEmpty
                ? Center(
              child: Text(
                "No tasks yet, add some!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) => _toggleTask(index),
                    activeColor: Colors.deepPurple,
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      decoration:
                      task.isDone ? TextDecoration.lineThrough : null,
                      color: task.isDone ? Colors.grey : Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _editTask(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  String title;
  bool isDone;
  TodoItem({required this.title, this.isDone = false});
}
