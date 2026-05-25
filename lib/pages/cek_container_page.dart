import 'package:flutter/material.dart';
import '../services/container_service.dart';
import '../utils/storage.dart';

class CekContainerPage extends StatefulWidget {
  const CekContainerPage({super.key});

  @override
  State<CekContainerPage> createState() => _CekContainerPageState();
}

class _CekContainerPageState extends State<CekContainerPage> {
  final TextEditingController searchController = TextEditingController();
  final AuthService service = AuthService();

  List data = [];
  bool isLoading = false;

  Future<void> search() async {
    setState(() => isLoading = true);

    final token = await Storage.getToken();

    final result = await service.searchContainer(
      searchController.text,
      token ?? "",
    );

    setState(() {
      isLoading = false;
      if (result["status"] == "success") {
        //data = result["data"];
        data = result["data"] ?? [];
      } else {
        data = [];

      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Container"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // INPUT + BUTTON
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: "Cari Container",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // ElevatedButton(
                //   onPressed: search,
                //   child: const Text("Cek"),
                // ),
                ElevatedButton(
                  onPressed: isLoading ? null : search,
                  child: const Text("Cek"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // LOADING
            // if (isLoading) const CircularProgressIndicator(),
            // const SizedBox(height: 10),

            // TABLE / LIST
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : data.isEmpty
                  ? const Center(child: Text("Data tidak ditemukan"))
                  : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];

                  return Card(
                    child: ListTile(
                      title: Text(item["cont_number"]?.toString() ?? "-"),
                      subtitle: Text(
                        "Lokasi: ${item["lokasi"]?.toString() ?? "-"}",
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}