import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  final List<Map<String, Object>> _allQuestions = [
    {
      'question': 'Which language is used to develop Flutter?',
      'answers': ['Java', 'Kotlin', 'Dart', 'Swift'],
      'correctAnswer': 'Dart'
    },
    {
      'question': 'What file extension is used in Flutter projects?',
      'answers': ['.dart', '.flutter', '.java', '.cpp'],
      'correctAnswer': '.dart'
    },
    {
      'question': 'Who developed the Flutter framework?',
      'answers': ['Apple', 'Google', 'Facebook', 'Microsoft'],
      'correctAnswer': 'Google'
    },
    {
      'question': 'What is Flutter primarily used for?',
      'answers': [
        'Game Development',
        'Web Development',
        'Mobile App Development',
        'AI'
      ],
      'correctAnswer': 'Mobile App Development'
    },
    {
      'question': 'Which programming language is used in Flutter development?',
      'answers': ['Python', 'C++', 'Dart', 'Ruby'],
      'correctAnswer': 'Dart'
    },
    {
      'question': 'Which company owns Dart programming language?',
      'answers': ['Apple', 'Google', 'IBM', 'Microsoft'],
      'correctAnswer': 'Google'
    },
    {
      'question': 'Which of the following is a Flutter widget?',
      'answers': ['Column', 'Grid', 'FlexBox', 'None'],
      'correctAnswer': 'Column'
    },
    {
      'question': 'What is a widget in Flutter?',
      'answers': [
        'An application',
        'A framework',
        'A UI component',
        'An algorithm'
      ],
      'correctAnswer': 'A UI component'
    },
    {
      'question': 'What does “Hot Reload” do in Flutter?',
      'answers': [
        'Restarts the app',
        'Rebuilds the UI',
        'Updates the database',
        'None of the above'
      ],
      'correctAnswer': 'Rebuilds the UI'
    },
    {
      'question': 'Which of these platforms does Flutter support?',
      'answers': ['iOS', 'Android', 'Web', 'All of the above'],
      'correctAnswer': 'All of the above'
    },
    {
      'question': 'What is Dart?',
      'answers': ['A game', 'A language', 'A tool', 'A library'],
      'correctAnswer': 'A language'
    },
    {
      'question': 'How is state managed in Flutter?',
      'answers': ['Stateless Widgets', 'Stateful Widgets', 'Both', 'Neither'],
      'correctAnswer': 'Both'
    },
    {
      'question': 'What is the use of pubspec.yaml file?',
      'answers': [
        'For UI design',
        'For managing dependencies',
        'For performance tuning',
        'None'
      ],
      'correctAnswer': 'For managing dependencies'
    },
    {
      'question': 'What is the root widget of the app called?',
      'answers': ['main()', 'rootWidget()', 'MyApp', 'MaterialApp'],
      'correctAnswer': 'MaterialApp'
    },
    {
      'question': 'What is the purpose of the build method in Flutter?',
      'answers': [
        'To manage app state',
        'To build the UI',
        'To run animations',
        'None of the above'
      ],
      'correctAnswer': 'To build the UI'
    },
    {
      'question': 'Which method is used to build the app UI in Flutter?',
      'answers': ['build()', 'initState()', 'runApp()', 'widgetBuild()'],
      'correctAnswer': 'build()'
    },
    {
      'question': 'Which tool is used to manage dependencies in Flutter?',
      'answers': ['gradle', 'npm', 'pub', 'cocoapods'],
      'correctAnswer': 'pub'
    },
    {
      'question': 'What is the default state management approach in Flutter?',
      'answers': ['ScopedModel', 'Provider', 'Redux', 'None of the above'],
      'correctAnswer': 'Provider'
    },
    {
      'question': 'Which widget is used for structuring the UI in rows?',
      'answers': ['Column', 'Row', 'Grid', 'Stack'],
      'correctAnswer': 'Row'
    },
    {
      'question': 'What is a Scaffold widget used for?',
      'answers': ['Design', 'App layout', 'Backend', 'None'],
      'correctAnswer': 'App layout'
    },
  ];

  late List<Map<String, Object>> _selectedQuestions;
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _resetQuiz();
  }

  void _resetQuiz() {
    setState(() {
      _selectedQuestions = _getRandomQuestions();
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  List<Map<String, Object>> _getRandomQuestions() {
    List<Map<String, Object>> shuffledQuestions = List.from(_allQuestions)
      ..shuffle(Random());
    return shuffledQuestions.take(5).toList();
  }

  void _answerQuestion(String selectedAnswer) {
    if (selectedAnswer ==
        _selectedQuestions[_currentQuestionIndex]['correctAnswer']) {
      _score++;
    }
    setState(() {
      _currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          )
        ],
      ),
      body: _currentQuestionIndex < _selectedQuestions.length
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: QuizQuestion(
                key: ValueKey<int>(_currentQuestionIndex),
                question: _selectedQuestions[_currentQuestionIndex]['question']
                    as String,
                answers: _selectedQuestions[_currentQuestionIndex]['answers']
                    as List<String>,
                answerQuestion: _answerQuestion,
              ),
            )
          : ResultScreen(
              score: _score,
              totalQuestions: _selectedQuestions.length,
              restartQuiz: _resetQuiz),
    );
  }
}

class QuizQuestion extends StatelessWidget {
  final String question;
  final List<String> answers;
  final Function(String) answerQuestion;

  const QuizQuestion({
    Key? key,
    required this.question,
    required this.answers,
    required this.answerQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                question,
                style: TextStyle(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ...answers.map((answer) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => answerQuestion(answer),
                  child: Text(
                    answer,
                    style: TextStyle(fontSize: screenHeight * 0.025),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback restartQuiz;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.restartQuiz,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _saveResult(score);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You answered $score out of $totalQuestions correctly!',
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: restartQuiz,
              child: const Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveResult(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('quizHistory') ?? [];
    history.add('Score: $score');
    prefs.setStringList('quizHistory', history);
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<List<String>> _getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('quizHistory') ?? [];
  }

  void _clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('quizHistory');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
      ),
      body: FutureBuilder<List<String>>(
        future: _getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No quiz history yet!'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: snapshot.data!
                      .map((result) => ListTile(title: Text(result)))
                      .toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _clearHistory();
                  Navigator.of(context).pop();
                },
                child: const Text('Clear History'),
              ),
            ],
          );
        },
      ),
    );
  }
}
