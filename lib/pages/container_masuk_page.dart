import 'package:flutter/material.dart';
import '../services/container_service.dart';
import '../utils/storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/services.dart';

class ContainerMasukPage extends StatefulWidget {
  const ContainerMasukPage({super.key});

  @override
  State<ContainerMasukPage> createState() => _ContainerMasukPageState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _ContainerMasukPageState extends State<ContainerMasukPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController contController = TextEditingController();
  final FocusNode containerFocusNode = FocusNode();

  final FocusNode newblockFocusNode = FocusNode();
  final FocusNode newrowFocusNode = FocusNode();
  final FocusNode newcolFocusNode = FocusNode();
  final FocusNode newstackFocusNode = FocusNode();
  final FocusNode newnotruckFocusNode = FocusNode();

  final FocusNode btnsaveFocusNode = FocusNode();


  final TextEditingController blockController = TextEditingController();
  final TextEditingController rowController = TextEditingController();
  final TextEditingController colController = TextEditingController();
  final TextEditingController stackController = TextEditingController();
  final TextEditingController notruckController = TextEditingController();

  final TextEditingController newblockController = TextEditingController();
  final TextEditingController newrowController = TextEditingController();
  final TextEditingController newcolController = TextEditingController();
  final TextEditingController newstackController = TextEditingController();
  final TextEditingController newnotruckController = TextEditingController();

  //List<String> suggestions = [];

  final service = AuthService();

  @override
  void initState() {
    super.initState();

    // default hari ini
    //dateController.text = DateTime.now().toString().substring(0, 10);
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  Future<void> getDetail(String cont) async {
    final token = await Storage.getToken();

    final result = await service.getContainerLocation(
      cont,
      token ?? "",
    );

    if (result["status"] == "success") {
      final data = result["data"];

      setState(() {
        blockController.text =
            data["block"]?.toString() ?? "";

        rowController.text =
            data["row"]?.toString() ?? "";

        colController.text =
            data["col"]?.toString() ?? "";

        stackController.text =
            data["stack"]?.toString() ?? "";

        notruckController.text =
            data["truck_number"]?.toString() ?? "";

        newnotruckController.text =
            data["truck_number"]?.toString() ?? "";
      });
    }
  }

  void resetForm() {
    setState(() {
      // dateController.clear();
      contController.clear();

      blockController.clear();
      rowController.clear();
      colController.clear();
      stackController.clear();
      notruckController.clear();

      newblockController.clear();
      newrowController.clear();
      newcolController.clear();
      newstackController.clear();
      newnotruckController.clear();
    });

    FocusScope.of(context).requestFocus(containerFocusNode);
  }

  void resetAfterSave() {
    setState(() {
      // dateController.clear();
      // contController.clear();

      blockController.clear();
      rowController.clear();
      colController.clear();
      stackController.clear();
      notruckController.clear();

      blockController.text = newblockController.text ;
      rowController.text = newrowController.text ;
      colController.text = newcolController.text ;
      stackController.text = newstackController.text ;
      notruckController.text = newnotruckController.text ;

      newblockController.clear();
      newrowController.clear();
      newcolController.clear();
      newstackController.clear();
      newnotruckController.clear();
    });

    FocusScope.of(context).requestFocus(containerFocusNode);
  }

  Future<void> saveContainer() async {

    // VALIDASI BLOCK
    if (newblockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Block Baru wajib diisi"),
        ),
      );

      FocusScope.of(context).requestFocus(newblockFocusNode);

      return;
    }

    // VALIDASI ROW
    if (newrowController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Row Baru wajib diisi"),
        ),
      );

      FocusScope.of(context).requestFocus(newrowFocusNode);

      return;
    }

    // VALIDASI COL
    if (newcolController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Col Baru wajib diisi"),
        ),
      );

      FocusScope.of(context).requestFocus(newcolFocusNode);

      return;
    }

    // VALIDASI STACK
    if (newstackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Stack Baru wajib diisi"),
        ),
      );

      FocusScope.of(context).requestFocus(newstackFocusNode);

      return;
    }

    if (newnotruckController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No Truck wajib diisi"),
        ),
      );

      FocusScope.of(context).requestFocus(newnotruckFocusNode);

      return;
    }

    final token = await Storage.getToken();

    final lokasi =
        "${newrowController.text} "
        "${newcolController.text} "
        "${newstackController.text}";

    final result = await service.updateLocationContainer(
      contNumber: contController.text,
      blockLoc: newblockController.text,
      location: lokasi,
      truckNumber: newnotruckController.text,
      token: token ?? "",
    );

    if (result["status"] == "success") {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Update Container Lokasi Berhasil"),
        ),
      );

      //resetForm();
      resetAfterSave();

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"]),
        ),
      );

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Container Masuk")),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TANGGAL
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Tanggal (Tgl/Bln/Thn)",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  String formattedDate =
                  DateFormat('dd/MM/yyyy').format(pickedDate);

                  setState(() {
                    dateController.text = formattedDate;

                    // kosongkan container
                    contController.clear();
                    blockController.clear();
                    rowController.clear();
                    colController.clear();
                    stackController.clear();
                    newblockController.clear();
                    newrowController.clear();
                    newcolController.clear();
                    newstackController.clear();

                    // hapus suggestion
                    //suggestions = [];
                  });

                  FocusScope.of(context).requestFocus(containerFocusNode);
                }


              },
            ),

            const SizedBox(height: 10),



            TypeAheadField<String>(
              key: ValueKey(dateController.text),
              suggestionsCallback: (pattern) async {
                final token = await Storage.getToken();

                return await service.getContainerByDateIn(
                  pattern,
                  dateController.text,
                  token ?? "",
                );
              },

              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },



              onSelected: (suggestion) async {
                contController.text = suggestion;

                FocusScope.of(context).unfocus();

                await getDetail(suggestion);

                FocusScope.of(context).requestFocus(newblockFocusNode);
              },

              builder: (context, controller, focusNode) {
                return TextField(
                  controller: contController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: "No Container",
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: const Text(
                "Lokasi Sekarang",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: blockController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Block",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: rowController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Row",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: colController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Col",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: stackController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Stack",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextField(
              controller: notruckController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "TruckNumber",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: const Text(
                "Lokasi Baru",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              maxLength: 1,
              controller: newblockController,
              readOnly: false,
              focusNode: newblockFocusNode,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(newrowFocusNode);
              },
              decoration: const InputDecoration(
                labelText: "Block",
                border: OutlineInputBorder(),
                counterText: "",
              ),
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context)
                      .requestFocus(newrowFocusNode);
                }
              },
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLength: 2,
                    controller: newrowController,
                    readOnly: false,
                    focusNode: newrowFocusNode,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(newcolFocusNode);
                    },
                    decoration: const InputDecoration(
                      labelText: "Row",
                      border: OutlineInputBorder(),
                      counterText: "",
                    ),
                    onChanged: (value) {
                      if (value.length == 2) {
                        FocusScope.of(context)
                            .requestFocus(newcolFocusNode);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    maxLength: 2,
                    controller: newcolController,
                    readOnly: false,
                    focusNode: newcolFocusNode,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(newstackFocusNode);
                    },
                    decoration: const InputDecoration(
                      labelText: "Col",
                      border: OutlineInputBorder(),
                      counterText: "",
                    ),
                    onChanged: (value) {
                      if (value.length == 2) {
                        FocusScope.of(context)
                            .requestFocus(newstackFocusNode);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    maxLength: 2,
                    controller: newstackController,
                    readOnly: false,
                    focusNode: newstackFocusNode,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(newnotruckFocusNode);
                    },
                    decoration: const InputDecoration(
                      labelText: "Stack",
                      border: OutlineInputBorder(),
                      counterText: "",
                    ),
                    onChanged: (value) {
                      if (value.length == 2) {
                        //FocusScope.of(context).unfocus();
                        FocusScope.of(context)
                            .requestFocus(btnsaveFocusNode);
                        // optional:
                        // saveContainer();
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextField(
              controller: newnotruckController,
              readOnly: false,
              focusNode: newnotruckFocusNode,
              decoration: const InputDecoration(
                labelText: "TruckNumber",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                // SAVE
                Expanded(
                  child: ElevatedButton(
                    focusNode: btnsaveFocusNode,
                    onPressed: () {
                      saveContainer();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("SAVE"),
                  ),
                ),

                const SizedBox(width: 10),

                // RESET
                Expanded(
                  child: ElevatedButton(
                    onPressed: resetForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("RESET"),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    ),
    );
  }
}