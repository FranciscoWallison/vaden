import 'dart:io';
import 'package:args/args.dart';
import 'package:vaden/vaden.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('serve')
    ..addCommand('generate')
    ..addCommand('config')
    ..addCommand('help');

  final ArgResults argResults = parser.parse(arguments);

  if (argResults.command == null) {
    printUsage(parser);
    exit(1);
  }

  switch (argResults.command?.name) {
    case 'serve':
      _startServer();
      break;
    case 'generate':
      _generateCode();
      break;
    case 'config':
      _showConfig();
      break;
    case 'help':
    default:
      printUsage(parser);
  }
}

void printUsage(ArgParser parser) {
  print('''
VADEN CLI - Ferramenta de Linha de Comando para gerenciamento de projetos Vaden.

Comandos disponíveis:
  serve       Inicia o servidor
  generate    Gera código automaticamente
  config      Mostra as configurações atuais
  help        Exibe esta ajuda

Exemplo de uso:
  dart bin/cli.dart serve
  dart bin/cli.dart generate
''');
}

void _startServer() async {
  print('Iniciando o servidor VADEN...');
  final vaden = VadenApplication();
  await vaden.setup();
  final server = await vaden.run();
  print('Servidor rodando na porta ${server.port}');
}

void _generateCode() {
  print('Gerando código automaticamente...');
  Process.runSync('dart', ['run', 'build_runner', 'build']);
  print('Código gerado com sucesso!');
}

void _showConfig() {
  print('Mostrando configurações do projeto...');
  final settings = ApplicationSettings.load('application.yaml');
  print('Servidor: ${settings["server"]["host"]}:${settings["server"]["port"]}');
  print('Banco de Dados: ${settings["database"]["provider"]}');
}
