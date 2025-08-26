import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/db.dart';
import '../../models/property.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import 'add_edit_property_screen.dart';
import 'property_detail_screen.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  List<PropertyModel> _list = [];
  bool _loading = true;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final auth = context.read<AuthProvider>();
    currentUser = auth.user;
    await _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    _list = await DatabaseHelper.instance.getProperties();
    setState(() => _loading = false);
  }

  Future<void> _delete(int id) async {
    await DatabaseHelper.instance.deleteProperty(id);
    await _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final isSeller = user?.role == 'seller';
    final isAdmin = user?.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(child: Text(user?.username ?? '')),
          ),
          IconButton(
            onPressed: () async {
              await auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _list.isEmpty
          ? const Center(child: Text('No properties yet.'))
          : RefreshIndicator(
              onRefresh: _fetch,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _list.length,
                itemBuilder: (c, i) {
                  final p = _list[i];
                  final canManage =
                      isAdmin || (isSeller && user?.id == p.sellerId);
                  return Card(
                    child: ListTile(
                      leading: p.imagePath.isNotEmpty
                          ? Image.file(
                              File(p.imagePath),
                              width: 72,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.home, size: 48),
                      title: Text('${p.category} • ${p.city}'),
                      subtitle: Text(p.address),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PropertyDetailScreen(property: p),
                        ),
                      ),
                      trailing: canManage
                          ? PopupMenuButton<String>(
                              onSelected: (v) async {
                                if (v == 'edit') {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddEditPropertyScreen(property: p),
                                    ),
                                  );
                                  _fetch();
                                } else if (v == 'delete') {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete property?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (ok == true) await _delete(p.id!);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: (isAdmin || isSeller)
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/add_property');
                _fetch();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
