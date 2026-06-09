import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:flutter/material.dart';

class SceneForm extends StatefulWidget {
  final String nomorLevel;
  final String nomorScene;
  final String title;
  final bool isIntro; //untuk pembeda klik dari card intro dan level

  const SceneForm({
    super.key,
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

  //Controllers untuk TextFieldComponent
  final _namaKarakterCont = TextEditingController();
  final _dialogCont = TextEditingController();
  final _pertanyaanCont = TextEditingController();
  final _kalimatOpsionalCont = TextEditingController();
  final _opsiACont = TextEditingController();
  final _opsiBCont = TextEditingController();
  final _opsiCCont = TextEditingController();
  final _jawabanTextCont = TextEditingController();
  final _hadiahXpCont = TextEditingController();

  //var dropdown
  String? _selectedBackground;
  String? _selectedKarakter;
  String? _selectedTipeScene;
  String? _kunciJawabanPG;

  //jika isIntro true, kunci nilai tipe scene ke 'dialog'
  @override
  void initState() {
    super.initState();
    if (widget.isIntro) {
      _selectedTipeScene = 'dialog';
    }
  }

  //dummy data list
  final List<String> _listBackground = [
    'Lab Komputer',
    'Kelas SQL',
    'Server Room',
  ];
  final List<String> _listKarakter = [
    'Alex (Guru)',
    'Budi (Siswa)',
    'Siti (Sembunyi)',
  ];
  final List<String> _listTipeScene = [
    'Dialog',
    'Pilihan ganda',
    'Susun kata',
    'Tulis SQL',
  ];

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

  @override
  Widget build(BuildContext context) {
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
                DropdownFieldComponent(
                  value: _selectedBackground,
                  hinttext: 'Pilih Gambar Background',
                  items: _listBackground,
                  onChanged: (val) => setState(() => _selectedBackground = val),
                  validator: (val) =>
                      val == null ? 'Wajib pilih gambar background' : null,
                ),
                const SizedBox(height: 16),

                //Dropdown Karakter
                Text(
                  "Pilih Gambar Karakter",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownFieldComponent(
                  value: _selectedKarakter,
                  hinttext: 'Pilih Gambar Karakter',
                  items: _listKarakter,
                  onChanged: (val) => setState(() => _selectedKarakter = val),
                  validator: (val) =>
                      val == null ? 'Wajib pilih gambar karakter' : null,
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

                // Pertanyaan
                Text(
                  "Pertanyaan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFieldComponent(
                  hinttext: 'Pertanyaan',
                  lines: 3,
                  textFieldCont: _pertanyaanCont,
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
                  _buildFieldXP(),
                ],

                if (_selectedTipeScene == 'Susun kata' ||
                    _selectedTipeScene == 'Tulis SQL') ...[
                  Text(
                    "Kunci Jawaban",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFieldComponent(
                    lines: 5,
                    hinttext: _selectedTipeScene == 'Tulis SQL'
                        ? 'Kunci Query SQL'
                        : 'Kunci Susun Kata',
                    textFieldCont: _jawabanTextCont,
                    textFieldVal: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildFieldXP(),
                ],
                const SizedBox(height: 32),

                //button save/simpan scene
                ButtonComponent(
                  text: "Simpan",
                  bgcolor: AppColors.primaryHoney,
                  onPressed: () {
                    if (_sceneFormKey.currentState!.validate()) {
                      // Jalankan fungsi simpan
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
}
