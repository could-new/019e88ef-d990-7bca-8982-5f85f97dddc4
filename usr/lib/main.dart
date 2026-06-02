import 'package:flutter/material.dart';

void main() {
  runApp(const StudentAssistantApp());
}

class StudentAssistantApp extends StatelessWidget {
  const StudentAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Student Assistant',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Dark mode as default
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Deep black
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700), // Luxurious gold
          secondary: Color(0xFF800020), // Dark burgundy
          surface: Color(0xFF121212), // Slightly lighter black for cards
          background: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Color(0xFFFFD700),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Color(0xFFFFD700),
          unselectedItemColor: Colors.grey,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        fontFamily: 'Roboto', // Default standard font
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatScreen(),
    const StudyScreen(),
    const RemindersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Study',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// CHAT SCREEN
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'role': 'bot', 'text': 'Hello! I am your AI Student Assistant. How can I help you with your studies today?'}
  ];
  bool _isTyping = false;

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _isTyping = true;
    });
    _messageController.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'role': 'bot',
            'text': 'I can certainly help you with "$userMessage". Let me check my sources and provide a detailed explanation shortly.'
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Open hamburger menu or drawer
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isBot = message['role'] == 'bot';
                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: isBot ? const Color(0xFF1A1A1A) : const Color(0xFF800020), // Bot is dark card, user is burgundy
                      borderRadius: BorderRadius.circular(16.0).copyWith(
                        bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(16.0),
                        bottomRight: !isBot ? const Radius.circular(0) : const Radius.circular(16.0),
                      ),
                      border: isBot ? Border.all(color: const Color(0xFF333333)) : null,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('AI is typing...', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              border: Border(top: BorderSide(color: Color(0xFF333333))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Color(0xFFFFD700)),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask a question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF2C2C2C),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFFFFD700),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.black),
                      onPressed: _sendMessage,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// STUDY SCREEN
class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Sets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStudyCard(context, 'Biology 101', 'Cell Structure & Function', '12 Items'),
          _buildStudyCard(context, 'World History', 'World War II', '24 Items'),
          _buildStudyCard(context, 'Calculus', 'Derivatives', '15 Items'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD700),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildStudyCard(BuildContext context, String subject, String topic, String items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF800020),
          child: const Icon(Icons.book, color: Colors.white),
        ),
        title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$topic\n$items'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFFFD700)),
        onTap: () {},
      ),
    );
  }
}

// REMINDERS SCREEN
class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildReminderCard(context, 'Math Homework', 'Due Tomorrow, 8:00 AM', true),
          _buildReminderCard(context, 'History Essay', 'Due in 3 days', false),
          _buildReminderCard(context, 'Study Session: Biology', 'Today, 6:00 PM', false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD700),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context, String title, String time, bool isHighPriority) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(
          Icons.notification_important,
          color: isHighPriority ? Colors.redAccent : const Color(0xFFFFD700),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(time),
        trailing: IconButton(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: () {},
        ),
      ),
    );
  }
}

// PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF800020),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Student Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
            ),
          ),
          const Center(
            child: Text(
              'High School Junior',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          _buildSettingsTile(Icons.settings, 'Settings'),
          _buildSettingsTile(Icons.school, 'Academic Goals'),
          _buildSettingsTile(Icons.palette, 'Appearance'),
          _buildSettingsTile(Icons.help_outline, 'Help & Support'),
          _buildSettingsTile(Icons.logout, 'Log Out', isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : const Color(0xFFFFD700)),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
