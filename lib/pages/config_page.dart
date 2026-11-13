import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:cognium_frontend/config.dart';
import 'package:cognium_frontend/services.dart';
import 'package:cognium_frontend/chat_controller.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  ConfigParams config = ConfigParams(
    sysPrt:
        'You are an Artificial inteligence assistant built to answer in the question`s language.',
    llmModel: '',
    embdModel: '',
    diffusionModel: '',
    temp: 0.8,
    maxTokens: -1,
    topK: 40,
    topP: 0.95,
    minP: 0.05,
    sttModel: '',
    ttsModel: '',
    voice: '',
    ttsSpeed: 1.0,
  );

  final List<dynamic> llmModels = [];
  final List<dynamic> embdModels = [];
  final List<dynamic> diffusionModels = [];
  final List<dynamic> ttsModels = [];
  final List<dynamic> sttModels = [];

  final List<dynamic> voices = [];

  final List<Map<String, Map>> mcpServers = [];

  @override
  void initState() {
    super.initState();

    initConfig();
    getLlmModels();
    getEmbdModels();
    getDiffusionModels();
    getTTSModels();
    getVoices();
    getSTTModels();
    getMCPServers();
  }

  Future<void> initConfig() async {
    try {
      final fetchedCfg = await fetchData('/config', 'GET') as Map;

      if (!fetchedCfg.containsKey('detail')) {
        config.sysPrt = fetchedCfg['sys_prt'];
        config.llmModel = fetchedCfg['llm_model'];
        config.embdModel = fetchedCfg['embedding_model'];
        config.diffusionModel = fetchedCfg['diffusion_model'];
        config.temp = fetchedCfg['temp'];
        config.maxTokens = fetchedCfg['max_tokens'];
        config.topK = fetchedCfg['top_k'];
        config.topP = fetchedCfg['top_p'];
        config.minP = fetchedCfg['min_p'];
        config.sttModel = fetchedCfg['stt_model'];
        config.ttsModel = fetchedCfg['tts_model'];
        config.voice = fetchedCfg['voice'];
        config.ttsSpeed = fetchedCfg['tts_speed'];

        setState(() {});
      }
    } catch (e) {
      print('ConfigPage -> initConfig: Error: $e');
    }
  }

  Future<void> saveCfg() async {
    try {
      await fetchData('/config', 'POST', data: config.toJson()) as Map;
    } catch (e) {
      print('ConfigPage -> saveCfg: Error: $e');
    }
  }

  Future<void> getLlmModels() async {
    try {
      final result = await fetchData('/models/Text', 'GET');

      if (result is Map && result.containsKey('models')) {
        setState(() => llmModels.addAll(result['models']));
      }
    } catch (e) {
      print('error: ConfigPage -> getLlmModels => $e');
    }
  }

  Future<void> getEmbdModels() async {
    try {
      final result = await fetchData("/models/Embedding", 'GET');

      if (result is Map && result.containsKey('models')) {
        setState(() => embdModels.addAll(result['models']));
      }
    } catch (e) {
      print("error: ConfigPage -> getEmbdModels => $e");
    }
  }

  Future<void> getDiffusionModels() async {
    try {
      final result = await fetchData('/models/Image', 'GET');

      if (result is Map && result.containsKey('models')) {
        setState(() => diffusionModels.addAll(result['models']));
      }
    } catch (e) {
      print("error: ConfigPage -> getDiffusionModels => $e");
    }
  }

  Future<void> getTTSModels() async {
    try {
      final result = await fetchData('/tts/models', 'GET');

      if (result is Map && result.containsKey('models')) {
        setState(() => ttsModels.addAll(result['models']));
      }
    } catch (e) {
      print("error: ConfigPage -> getTTSMModels => $e");
    }
  }

  Future<void> getSTTModels() async {
    try {
      final result = await fetchData('/stt/models', 'GET');

      if (result is Map && result.containsKey('models')) {
        setState(() => sttModels.addAll(result['models']));
      }
    } catch (e) {
      print("error: ConfigPage -> getSTTModels => $e");
    }
  }

  Future<void> getVoices() async {
    try {
      final result = await fetchData('/voices', 'GET');

      if (result is Map && result.containsKey('voices')) {
        setState(() => voices.addAll(result['voices']));
      }
    } catch (e) {
      print("Error: ConfigPage -> getVoices => $e");
    }
  }

  Future<void> getMCPServers() async {
    try {
      final result = await fetchData('/mcp', 'GET');

      if (result is Map && result.containsKey('mcpServers')) {
        setState(() => mcpServers.addAll(result['mcpServers']));
      }
    } catch (e) {
      print("Error: ConfigPage -> getMCPServers => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Provider.of<ChatController>(context, listen: true);

    return Stack(
      children: [
        Form(
          key: ValueKey(config.hashCode),
          child: ListView(
            children: [
              // General configuration
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ExpansionTile(
                  title: const Text('General'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.brightness_auto,
                          ), // Add light and night themes
                          title: const Text('Theme'),
                          trailing: MenuAnchor(
                            menuChildren: [
                              MenuItemButton(
                                child: const Text('System'),
                                onPressed: () {
                                  setState(() {
                                    null;
                                  });
                                },
                              ),

                              MenuItemButton(
                                child: const Text('Dark'),
                                onPressed: () {
                                  setState(() {
                                    null;
                                  });
                                },
                              ),

                              MenuItemButton(
                                child: const Text('Light'),
                                onPressed: () {
                                  setState(() {
                                    null;
                                  });
                                },
                              ),
                            ],
                            builder:
                                (
                                  BuildContext context,
                                  MenuController controller,
                                  Widget? child,
                                ) {
                                  return TextButton(
                                    onPressed: () {
                                      if (controller.isOpen) {
                                        controller.close();
                                      } else {
                                        controller.open();
                                      }
                                    },
                                    child: Text('System'),
                                  );
                                },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          const Text('System prompt'),

                          Card(
                            child: TextFormField(
                              maxLines: 5,
                              initialValue: config.sysPrt.trim(),
                              onChanged: (v) => config.sysPrt = v,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Models configuration
              Padding(
                padding: EdgeInsets.all(10),
                child: ExpansionTile(
                  title: const Text("Models configuration"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.chat),
                          title: const Text("LLM model"),
                          trailing: PopupMenuButton(
                            child: Text(
                              config.llmModel != '' ? config.llmModel : "None",
                            ),
                            itemBuilder: (context) => llmModels
                                .map(
                                  (m) => PopupMenuItem(
                                    child: Text(m),
                                    onTap: () => setState(() {
                                      config.llmModel = m;
                                      chatCtrl.setSelectedModel(m);
                                    }),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.scatter_plot),
                          title: const Text("Embedding model"),
                          trailing: PopupMenuButton(
                            child: Text(
                              config.embdModel != ''
                                  ? config.embdModel
                                  : "None",
                            ),
                            itemBuilder: (context) => embdModels
                                .map(
                                  (m) => PopupMenuItem(
                                    child: Text(m),
                                    onTap: () =>
                                        setState(() => config.embdModel = m),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.gradient),
                          title: const Text("Diffusion model"),
                          trailing: PopupMenuButton(
                            child: Text(
                              config.diffusionModel != ''
                                  ? config.diffusionModel
                                  : 'None',
                            ),
                            itemBuilder: (context) => diffusionModels
                                .map(
                                  (m) => PopupMenuItem(
                                    child: Text(m),
                                    onTap: () => setState(
                                      () => config.diffusionModel = m,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sampling configuration
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ExpansionTile(
                  title: const Text('Sampling'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('Temperature'),

                          TextFormField(
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                            initialValue: config.temp.toString(),
                            onChanged: (v) {
                              config.temp = double.tryParse(v) ?? config.temp;
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('Max tokens'),

                          TextFormField(
                            maxLength: 5,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[+-]?\d*'),
                              ),
                            ],
                            initialValue: config.maxTokens.toString(),
                            onChanged: (v) {
                              config.maxTokens =
                                  int.tryParse(v) ?? config.maxTokens;
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('Top K'),

                          TextFormField(
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            initialValue: config.topK.toString(),
                            onChanged: (v) {
                              config.topK = int.tryParse(v) ?? config.topK;
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('Top P'),

                          TextFormField(
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                            initialValue: config.topP.toString(),
                            onChanged: (v) {
                              config.topP = double.tryParse(v) ?? config.topP;
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('Min P'),

                          TextFormField(
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                            initialValue: config.minP.toString(),
                            onChanged: (v) {
                              config.minP = double.tryParse(v) ?? config.minP;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // TTS configuration
              Padding(
                padding: const EdgeInsets.all(10),
                child: ExpansionTile(
                  title: const Text("TTS"),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.graphic_eq),
                          title: const Text('TTS Model'),
                          trailing: PopupMenuButton(
                            child: Text(
                              config.ttsModel != ''
                                  ? config.ttsModel
                                  : (ttsModels.firstOrNull ?? 'None'),
                            ),
                            itemBuilder: (context) => ttsModels
                                .map(
                                  (m) => PopupMenuItem(
                                    child: Text(m),
                                    onTap: () =>
                                        setState(() => config.ttsModel = m),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.record_voice_over),
                          title: const Text('Voice'),
                          trailing: PopupMenuButton(
                            child: Text(
                              config.voice != '' ? config.voice : 'Default',
                            ),
                            itemBuilder: (context) => voices
                                .map(
                                  (v) => PopupMenuItem(
                                    child: Text(v),
                                    onTap: () =>
                                        setState(() => config.voice = v),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('Voice speed'),

                          Slider(
                            min: 0.5,
                            max: 2.0,
                            divisions: 15,
                            value: config.ttsSpeed,
                            label: "${config.ttsSpeed.toStringAsFixed(1)}x",
                            onChanged: (value) {
                              setState(() {
                                config.ttsSpeed = value;
                              });
                            },
                          ),

                          Text(
                            'Controls the speed of generated audio',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // STT Configuration
              Padding(
                padding: const EdgeInsets.all(10),
                child: ExpansionTile(
                  title: const Text('STT'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.graphic_eq),
                          title: const Text('STT model'),
                          trailing: PopupMenuButton(
                            child: Text(
                              config.sttModel != '' ? config.sttModel : 'None',
                            ),
                            itemBuilder: (context) => sttModels
                                .map(
                                  (m) => PopupMenuItem(
                                    child: Text(m),
                                    onTap: () =>
                                        setState(() => config.sttModel = m),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // MCP Configuration
              Padding(
                padding: const EdgeInsets.all(10),
                child: ExpansionTile(
                  title: const Text('MCP'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.cable),
                          title: const Text('Add MCP server'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _mcpServerDialog(context),
                          ),
                        ),
                      ),
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: mcpServers.length,
                      itemBuilder: (_, index) {
                        final server = mcpServers[index];
                        final serverName = server.keys.firstOrNull;

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.dns),
                            title: Text(serverName ?? "Unnamed server"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _mcpServerDialog(
                                    context,
                                    serverName: serverName ?? '',
                                    command:
                                        server[serverName]?['command'] ?? '',
                                    script: server[serverName]?['script'] ?? '',
                                  ),
                                  icon: const Icon(Icons.edit),
                                ),

                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Remove MCP Server",
                                          ),
                                          content: Text(
                                            "Do you want to remove ${serverName ?? ''}?",
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text("No"),
                                              onPressed: () => Navigator.of(
                                                dialogContext,
                                              ).pop(),
                                            ),

                                            FilledButton(
                                              child: const Text("Yes"),
                                              onPressed: () {
                                                if (serverName == null) return;

                                                fetchData(
                                                  '/mcp',
                                                  'DELETE',
                                                  data: {
                                                    'server_name': serverName,
                                                  },
                                                );

                                                if (!context.mounted) return;

                                                setState(() {
                                                  mcpServers.removeAt(index);
                                                });

                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              child: const Text('Save Settings'),
              onPressed: () {
                saveCfg();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _mcpServerDialog(
    BuildContext context, {
    String? serverName,
    String? command,
    String? script,
  }) {
    final serverNameController = TextEditingController();
    final commandController = TextEditingController();
    final scriptController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    serverNameController.text = serverName ?? '';
    commandController.text = command ?? '';
    scriptController.text = script ?? '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            serverName == null ? "Add MCP Server" : "Edit MCP Server",
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: serverNameController,
                    decoration: const InputDecoration(
                      labelText: "Server name",
                      hintText: "e.g date",
                      prefixIcon: Icon(Icons.dns),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter a server name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: commandController,
                    decoration: const InputDecoration(
                      labelText: "Command",
                      hintText: "e.g. /usr/bin/python3",
                      prefixIcon: Icon(Icons.terminal),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter a command";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: scriptController,
                    decoration: const InputDecoration(
                      labelText: "Script path",
                      hintText: "/path/to/mcp_server.py",
                      prefixIcon: Icon(Icons.insert_drive_file),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter the script path";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),

            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                final serverName = serverNameController.text.trim();
                final command = commandController.text.trim();
                final script = scriptController.text.trim();

                final payload = {
                  serverName: {'command': command, 'script': script},
                };

                fetchData('/mcp', 'PUT', data: {'server_def': payload});

                final index = mcpServers.indexWhere(
                  (e) => e.containsKey(serverName),
                );

                setState(() {
                  if (index == -1) {
                    mcpServers.add(payload);
                  } else {
                    mcpServers[index] = payload;
                  }
                });

                if (!context.mounted) return;

                Navigator.of(dialogContext).pop();
              },
              child: Text(serverName == null ? "Add" : "Edit"),
            ),
          ],
        );
      },
    ).whenComplete(() {
      serverNameController.dispose();
      commandController.dispose();
      scriptController.dispose();
    });
  }
}
