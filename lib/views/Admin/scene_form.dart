import 'dart:typed_data';

import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/repository/asset_scene_repository.dart';
import 'package:deebee_user/database/repository/scene_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/asset_scene_model.dart';
import 'package:deebee_user/models/scene_model.dart';
import 'package:deebee_user/views/Gameplay/sql_input_interaction.dart';
import 'package:flutter/material.dart';

class SceneForm extends StatefulWidget {
  final int levelId;
  final SceneModel? scene; //untuk pembeda Create / Edit
  final String nomorLevel;
  final String nomorScene;
  final String title;
  final bool isIntro; //untuk pembeda klik dari card intro dan level

  const SceneForm({
    super.key,
    required this.levelId,
    this.scene,
    required this.nomorLevel,
    required this.nomorScene,
    required this.title,
    this.isIntro = false, //Default-nya false (untuk card level)
  });

  @override
  State<SceneForm> createState() => _SceneCreateFormState();
}

class _SceneCreateFormState extends State<SceneForm> {
  final _sceneFormKey = GlobalKey<FormState>();
  final _sceneRepo = SceneRepository();
  final _assetRepo = AssetSceneRepository();

  //Controllers untuk TextFieldComponent
  final _namaKarakterCont = TextEditingController();
  final _dialogCont = TextEditingController();
  final _kalimatOpsionalCont = TextEditingController();
  final _pertanyaanCont = TextEditingController();

  final _opsiACont = TextEditingController();
  final _opsiBCont = TextEditingController();
  final _opsiCCont = TextEditingController();

  final _jawabanTextCont = TextEditingController();
  final _hadiahXpCont = TextEditingController();

  //var dropdown
  int? _selectedBackgroundId;
  int? _selectedKarakterId;
  String? _selectedTipeScene =
      'Dialog'; //'Dialog', 'Pilihan ganda', 'Susun kata', 'Tulis SQL',
  String? _kunciJawabanPG; //A, B, C

  // List untuk menampung data dari Database
  List<AssetSceneModel> _listBackground = [];
  List<AssetSceneModel> _listKarakter = [];

  // pilihan tipe scene
  final List<String> _listTipeScene = [
    'Dialog',
    'Pilihan ganda',
    'Susun kata',
    'Tulis SQL',
  ];

  // Indikator loading data DB
  bool _isLoadingAssets = true;
  @override
  void initState() {
    super.initState();
    _loadAssetData();
  }

  // Fungsi untuk mengambil data dari DB asset_scene
  void _loadAssetData() async {
    try {
      final backgrounds = await _assetRepo.getAssetSceneByCategory(
        "Background",
      );
      final karakters = await _assetRepo.getAssetSceneByCategory("Karakter");

      setState(() {
        _listBackground = backgrounds;
        _listKarakter = karakters;

        // Jika dalam mode EDIT, pasang nilai lama dari data scene ke dropdown ID
        if (widget.scene != null) {
          final s = widget.scene!;
          _namaKarakterCont.text = s.charName ?? '';
          _dialogCont.text = s.charDialog ?? '';
          _kalimatOpsionalCont.text = s.optionalSentence ?? '';
          _pertanyaanCont.text = s.question ?? '';
          _opsiACont.text = s.optionA ?? '';
          _opsiBCont.text = s.optionB ?? '';
          _opsiCCont.text = s.optionC ?? '';
          _jawabanTextCont.text = s.answerKey ?? '';
          _hadiahXpCont.text = s.rewardXp.toString();

          _selectedBackgroundId = s.bgImageId;
          _selectedKarakterId = s.charImageId;
          _selectedTipeScene = s.sceneType;
          _kunciJawabanPG = s.answerKeyMultipleChoice;
        } else {
          if (widget.isIntro) {
            _selectedTipeScene = 'Dialog';
          }
        }
        _isLoadingAssets = false; // Loading selesai
      });
    } catch (e) {
      // Handle error jika gagal fetch data
      setState(() => _isLoadingAssets = false);
      print("Error loading assets: $e");
    }
  }

  //bersihkan memori ketika halaman ditutup atau tidak lagi digunakan.
  @override
  void dispose() {
    _namaKarakterCont.dispose();
    _dialogCont.dispose();
    _pertanyaanCont.dispose();
    _kalimatOpsionalCont.dispose();
    _opsiACont.dispose();
    _opsiBCont.dispose();
    _opsiCCont.dispose();
    _jawabanTextCont.dispose();
    _hadiahXpCont.dispose();
    super.dispose();
  }

  //helper preview dropdown background/karakter
  Uint8List? _getAssetBytes(int? selectedId, List<AssetSceneModel> assetList) {
    if (selectedId == null) return null;
    try {
      // Cari asset yang ID-nya cocok, lalu ambil field image-nya
      final asset = assetList.firstWhere((element) => element.id == selectedId);
      return asset.image;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jika data asset dari DB belum selesai dimuat, tampilkan loading spinner
    if (_isLoadingAssets) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 80,
          ),
          child: Form(
            key: _sceneFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //row back button dan judul form
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                //Info level dan scene (readonly)
                Text(
                  '${widget.nomorLevel}  •  ${widget.nomorScene}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.borderBrown,
                  ),
                ),
                const SizedBox(height: 20),

                //Dropdown Background
                Text(
                  "Pilih Gambar Background",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildAssetDropdown(
                  value: _selectedBackgroundId,
                  hintText: 'Pilih Gambar Background',
                  items: _listBackground,
                  onChanged: (val) =>
                      setState(() => _selectedBackgroundId = val),
                  validator: (val) =>
                      val == null ? 'Wajib pilih gambar background' : null,
                ),
                //Preview dropdown background
                _buildImagePreview(
                  _getAssetBytes(_selectedBackgroundId, _listBackground),
                ),
                const SizedBox(height: 16),

                //Dropdown Karakter
                Text(
                  "Pilih Gambar Karakter",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildAssetDropdown(
                  value: _selectedKarakterId,
                  hintText: 'Pilih Gambar Karakter',
                  items: _listKarakter,
                  onChanged: (val) => setState(() => _selectedKarakterId = val),
                  validator: (val) =>
                      val == null ? 'Wajib pilih gambar karakter' : null,
                ),
                //Preview dropdown karakter
                _buildImagePreview(
                  _getAssetBytes(_selectedKarakterId, _listKarakter),
                ),
                const SizedBox(height: 16),

                //Nama Karakter
                Text(
                  "Nama Karakter",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFieldComponent(
                  hinttext: 'Nama Karakter',
                  textFieldCont: _namaKarakterCont,
                  textFieldVal: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                //Dialog
                Text("Dialog", style: TextStyle(fontWeight: FontWeight.bold)),
                TextFieldComponent(
                  hinttext: 'Dialog',
                  lines: 3,
                  textFieldCont: _dialogCont,
                  textFieldVal: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                // Dropdown Tipe Scene
                Text(
                  "Pilih Tipe Scene",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownFieldComponent(
                  value: _selectedTipeScene,
                  hinttext: 'Pilih Tipe Scene',
                  items: _listTipeScene,
                  //jika isIntro TRUE, onChanged DISET NULL (OTOMATIS LOCK / DISABLED)
                  onChanged: widget.isIntro
                      ? null
                      : (val) => setState(() => _selectedTipeScene = val),
                  validator: (val) => val == null ? 'Wajib pilih tipe' : null,
                ),
                const SizedBox(height: 24),

                // WIDGET CONDITIONAL //
                if (_selectedTipeScene == 'Dialog') ...[
                  Text(
                    "Kalimat Opsional",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFieldComponent(
                    hinttext: 'Kalimat Opsional',
                    lines: 3,
                    textFieldCont: _kalimatOpsionalCont,
                  ),
                ],

                if (_selectedTipeScene == 'Pilihan ganda') ...[
                  // Pertanyaan
                  _buildQuestion(),

                  _buildRowOpsi('A', _opsiACont),
                  _buildRowOpsi('B', _opsiBCont),
                  _buildRowOpsi('C', _opsiCCont),
                  const SizedBox(height: 16),

                  Text(
                    "Kunci Jawaban Benar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownFieldComponent(
                    value: _kunciJawabanPG,
                    hinttext: 'Kunci Jawaban Benar',
                    items: const ['A', 'B', 'C'],
                    onChanged: (val) => setState(() => _kunciJawabanPG = val),
                    validator: (val) =>
                        val == null ? 'Wajib pilih kunci jawaban' : null,
                  ),
                  const SizedBox(height: 16),
                  //hadiah XP
                  _buildFieldXP(),
                ],

                if (_selectedTipeScene == 'Susun kata' ||
                    _selectedTipeScene == 'Tulis SQL') ...[
                  // Accordion Struktur Tabel (ERD)
                  ExpansionTile(
                    title: const Text(
                      "Struktur Tabel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    iconColor: AppColors.primaryHoney,
                    collapsedIconColor: AppColors.primaryBlack,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColors.borderBrown,
                        width: 1,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColors.primaryHoney,
                        width: 2,
                      ),
                    ),
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //buka preview image (func ada di sql_input_interaction.dart)
                              builder: (_) => const OpenImage(),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/erd.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pertanyaan
                  _buildQuestion(),

                  Text(
                    "Kunci Jawaban",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFieldComponent(
                    lines: 5,
                    hinttext: _selectedTipeScene == 'Tulis SQL'
                        ? 'Kunci Query SQL (HANYA BISA SELECT)'
                        : 'Kunci Susun Kata (HANYA BISA SELECT)',
                    textFieldCont: _jawabanTextCont,
                    textFieldVal: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Wajib diisi';
                      }

                      //validasi cuman boleh query SELECT
                      final sql = val.trim().toUpperCase();
                      if (!sql.startsWith('SELECT')) {
                        return 'Saat ini hanya query SELECT yang diperbolehkan';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  //hadiah XP
                  _buildFieldXP(),
                ],
                const SizedBox(height: 32),

                //button save/simpan scene
                ButtonComponent(
                  text: "Simpan",
                  bgcolor: AppColors.primaryHoney,
                  onPressed: createSaveScene,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // method dropdown background dan karakter
  Widget _buildAssetDropdown({
    required int? value,
    required String hintText,
    required List<AssetSceneModel> items,
    required ValueChanged<int?> onChanged,
    required String? Function(int?)? validator,
  }) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      hint: Text(
        hintText,
        style: const TextStyle(color: Color(0xFF626566), fontSize: 14),
      ),
      // Memetakan objek AssetSceneModel ke DropdownMenuItem<int>
      items: items.map((asset) {
        return DropdownMenuItem<int>(
          value: asset.id,
          child: Text(asset.imageName),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderBrown, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderBrown, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderBrown, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
  // end method dropdown background dan karakter

  // method PREVIEW dropdown background/karakter
  Widget _buildImagePreview(Uint8List? imageBytes) {
    if (imageBytes == null) {
      // Jika belum pilih, tidak muncul apa-apa
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          imageBytes,
          width: 120,
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              "Gagal memuat gambar",
              style: TextStyle(color: Colors.red, fontSize: 12),
            );
          },
        ),
      ),
    );
  }
  // end method PREVIEW dropdown background/karakter

  Column _buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pertanyaan", style: TextStyle(fontWeight: FontWeight.bold)),
        TextFieldComponent(
          hinttext: 'Pertanyaan',
          lines: 3,
          textFieldCont: _pertanyaanCont,
          textFieldVal: (val) => val!.isEmpty ? 'Wajib diisi' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRowOpsi(String huruf, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryHoney,
            child: Text(huruf),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFieldComponent(
              hinttext: 'Pilihan $huruf',
              textFieldCont: controller,
              textFieldVal: (val) => val!.isEmpty ? 'Wajib diisi' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldXP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hadiah XP", style: TextStyle(fontWeight: FontWeight.bold)),
        TextFieldComponent(
          hinttext: 'Hadiah XP',
          textFieldCont: _hadiahXpCont,
          textFieldVal: (val) {
            if (val!.isEmpty) return 'Wajib diisi';
            if (int.tryParse(val) == null) return 'Harus berupa angka bulat';
            return null;
          },
        ),
      ],
    );
  }

  //fungsi tombol simpan scene
  void createSaveScene() async {
    // Jalankan validator form
    if (!_sceneFormKey.currentState!.validate()) {
      return;
    }

    //buat object SceneModel
    final scene = SceneModel(
      id: widget
          .scene
          ?.id, // Jika edit, id lama akan masuk. Jika create, otomatis null.
      levelId: widget.levelId,

      bgImageId: _selectedBackgroundId,
      charImageId: _selectedKarakterId,

      charName: _namaKarakterCont.text,
      charDialog: _dialogCont.text,

      sceneType: _selectedTipeScene ?? 'Dialog',

      optionalSentence: _kalimatOpsionalCont.text.isEmpty
          ? null
          : _kalimatOpsionalCont.text,

      question: _pertanyaanCont.text.isEmpty ? null : _pertanyaanCont.text,

      optionA: _opsiACont.text.isEmpty ? null : _opsiACont.text,
      optionB: _opsiBCont.text.isEmpty ? null : _opsiBCont.text,
      optionC: _opsiCCont.text.isEmpty ? null : _opsiCCont.text,

      answerKeyMultipleChoice: _selectedTipeScene == 'Pilihan ganda'
          ? _kunciJawabanPG
          : null,
      answerKey: _jawabanTextCont.text.isEmpty ? null : _jawabanTextCont.text,
      rewardXp: _hadiahXpCont.text.isEmpty
          ? 0
          : (int.tryParse(_hadiahXpCont.text) ?? 0),
    );

    // Cek apakah mode Create atau Edit berdasarkan widget.scene
    if (widget.scene == null) {
      //jika create
      await _sceneRepo.createScene(scene);
    } else {
      //jika edit
      await _sceneRepo.updateScene(scene);
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.scene == null
              ? 'Scene berhasil dibuat'
              : 'Scene berhasil diperbarui',
        ),
      ),
    );
    context.pop(true);
  }
}
