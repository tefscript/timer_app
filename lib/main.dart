import 'package:flutter/material.dart'; // fornece ferramentas de interface
import 'package:provider/provider.dart'; // para gerenciar estado

//notificar os "ouvintes" sobre mudancas de estado
class ProvedorTimer with ChangeNotifier {
  int _segundos = 0;
  bool _rodando = false;
  late final Stopwatch _cronometro;

  ProvedorTimer() { //construtor do timer
    _cronometro = Stopwatch();
  }

  int get segundos => _segundos; //retorna o valor atual dos segundos

  void iniciarTimer() {
    _rodando = true;
    _cronometro.start();
    _atualizaTimer();
  }

  void pararTimer() {
    _rodando = false;
    _cronometro.stop();
  }

  void reiniciarTimer() {
    _rodando = false;
    _cronometro.reset();
    _segundos = 0;
    notifyListeners(); //atualiza todos os ouvintes sobre mudança
  }
//"espera" um segundo e atualiza
  void _atualizaTimer() {
    Future.delayed(Duration(seconds: 1), () { 
      if (_rodando) {
        _segundos = _cronometro.elapsed.inSeconds;
        notifyListeners();
        _atualizaTimer();
      }
    });
  }
}

//define a classe do app como um todo
class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( //provedor com uma instancia pra acessar em todos os widgets
      create: (_) => ProvedorTimer(),
      child: MaterialApp( //aparencia basica do app definida por isso
        home: TelaTimer(), // define a tela principal
      ),
    );
  }
}

class TelaTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provedorTimer = Provider.of<ProvedorTimer>(context);
    return Scaffold( //estrutura basica e barra de navegacao
      appBar: AppBar( //barra de navegacao
        title: Text('Timer App'),
        centerTitle: true, 
      ),
      body: Container(
        color: const Color.fromARGB(255, 213, 82, 126), 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${provedorTimer.segundos} segundos', 
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20), 
              ElevatedButton(
                onPressed: provedorTimer.iniciarTimer,
                child: Text('Iniciar'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: provedorTimer.reiniciarTimer,
                child: Text('Redefinir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(TimerApp());
}
