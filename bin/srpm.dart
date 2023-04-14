///
/// SRPM - the Simple Reverse Proxy Manager
/// (c) 2023 the University of Fool
///

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:srpm/data_process.dart';
import 'package:srpm/generate.dart';
import 'package:toml/toml.dart';
import 'package:nanoid/nanoid.dart';

void main(List<String> arguments) async {
  exitCode = 0;

  var parser = ArgParser();
  parser.addOption('config', abbr: 'c', defaultsTo: './config.toml');
  parser.addFlag('help', abbr: 'h');
  parser.addCommand('list');
  var create = parser.addCommand('create');
  create.addOption('name', abbr: 'n');
  create.addOption('target-address', abbr: 'a');
  create.addOption('domain', abbr: 'd');
  create.addOption('ssl-cert', abbr: 'c', defaultsTo: 'none');
  create.addOption('ssl-key', abbr: 'k', defaultsTo: 'none');
  parser.addCommand('generate');
  final results = parser.parse(arguments);

  if (results["help"]) {
    printHelp();
    return;
  }

  final configuration =
      (await TomlDocument.load(results['config'] as String)).toMap();

  /// Check for configuration
  if ((configuration['dataDir'] == null) ||
      (configuration['outputPath'] == null)) {
    exitCode = 1;
    print("ERROR: configuration file not valid!");
    exit(1);
  }

  /// Check for command
  if (results.command?.name == null) {
    exitCode = 1;
    print("ERROR: please provide a command!");
    exit(1);
  }

  /// Check for data
  var workingDir =
      (await Directory("${configuration['dataDir']}").create(recursive: true))
          .path;
  await Directory("$workingDir/targets").create(recursive: true);
  var listFile = File('$workingDir/list.json');
  TargetList targetList;
  try {
    targetList = TargetList.fromJson(jsonDecode(await listFile.readAsString()));
  } catch (e) {
    await listFile.writeAsString(jsonEncode(TargetList([], [])));
    targetList = TargetList([], []);
  }
  List<Target> targetListObj = [];
  try {
    for (var element in targetList.idList) {
      targetListObj.add(Target.fromJson(jsonDecode(
          await File('$workingDir/targets/$element.json').readAsString())));
    }
  } catch (e) {
    print(e);
  }

  if (results.command?.name == 'list') {
    showList(targetList);
  }
  if (results.command?.name == 'create') {
    createTarget(workingDir, results.command);
  }
  if (results.command?.name == 'generate') {
    generate(targetListObj, configuration["outputPath"]);
  }
  return;
}

void showList(TargetList list) {
  int index = 0;
  for (var element in list.nameList) {
    print("* $element (${list.idList[index]})");
    index++;
  }
  return;
}

void createTarget(String workingDir, ArgResults? options) async {
  if (options != null) {
    var target = Target(options['name'], nanoid(), options['target-address'],
        options['domain'], options['ssl-cert'], options['ssl-key']);
    var targetList = TargetList.fromJson(
        jsonDecode(await File('$workingDir/list.json').readAsString()));
    targetList.idList.add(target.id);
    targetList.nameList.add(target.name);
    await File('$workingDir/list.json').writeAsString(jsonEncode(targetList));
    await File('$workingDir/targets/${target.id}.json')
        .writeAsString(jsonEncode(target));
    return;
  } else {
    return;
  }
}

void generate(List<Target> targets, String configPath) {
  String output = "";
  for (var element in targets) {
    if (element.sslCert == 'none' && element.sslCertKey == 'none') {
      output += makePlainConfig(element);
    } else {
      output += makeSslConfig(element);
    }
  }
  File(configPath).writeAsStringSync(output);
}

void printHelp() {
  print("""
Usage: srpm [global options] <command> [options]

srpm @1.0.0

Global Options:
  -h --help     Display this help
  -c --config   Define configuration file path
                (defaults to: ./config.toml)
Commands and Options:
  list          List all the configured proxies

  create        Create a new proxy
  [Options]
    -n --name   The name of the proxy
    -a --target-address
                The target of the proxy
    -d --domain The domain of the proxy
    -c --ssl-cert
    -k --ssl-key
                The cert.pem and private key of the
                SSL certificate, will be configured
                as plain http when these are 'none'
                (defaults to: none)

  generate      Generate a Nginx-readable configuration file
                using the configured proxies

(c) University of Fool 2023
This is open-source software. For more informations 
please visit (https://github.com/University-Of-Fool/srpm).
""");
}
