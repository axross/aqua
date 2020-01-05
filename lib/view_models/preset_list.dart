import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/player_hand_setting_preset.dart';
import 'package:aqua/models/player_hand_setting_preset_group.dart';
import 'package:aqua/models/rank.dart';
import 'package:flutter/material.dart';

class PresetList extends ChangeNotifier {
  PresetList();

  List<PlayerHandSettingPresetGroup> groups = [];

  bool isLoading;

  void deleteGroupAt(int index) {
    groups.removeAt(index);

    print(groups);

    notifyListeners();
    _savePresets();
  }

  void deletePreset(int groupIndex, int presetIndex) {
    groups[groupIndex].presets.removeAt(presetIndex);

    notifyListeners();
    _savePresets();
  }

  void addNewPresetToGroupAt(int groupIndex) {
    groups[groupIndex]
        .presets
        .add(PlayerHandSettingPreset(name: null, parts: {}));

    notifyListeners();
    _savePresets();
  }

  void setGroupNameAt(int groupIndex, String newName) {
    groups[groupIndex] = PlayerHandSettingPresetGroup(
      name: newName,
      presets: groups[groupIndex].presets,
    );

    notifyListeners();
    _savePresets();
  }

  void setPresetNameAt(int groupIndex, int presetIndex, String name) {
    groups[groupIndex].presets[presetIndex] = PlayerHandSettingPreset(
      name: name,
      parts: groups[groupIndex].presets[presetIndex].parts,
    );

    notifyListeners();
    _savePresets();
  }

  void setPresetPartsAt(
    int groupIndex,
    int presetIndex,
    Set<PlayerHandSettingRangePart> parts,
  ) {
    groups[groupIndex].presets[presetIndex] = PlayerHandSettingPreset(
      name: groups[groupIndex].presets[presetIndex].name,
      parts: parts,
    );

    notifyListeners();
    _savePresets();
  }

  void swapGroups(int aIndex, int bIndex) {
    final temporary = groups[aIndex];

    groups[aIndex] = groups[bIndex];
    groups[bIndex] = temporary;

    notifyListeners();
    _savePresets();
  }

  void swapPresets(int groupIndex, int aPresetIndex, int bPresetIndex) {
    final temporary = groups[groupIndex].presets[aPresetIndex];

    groups[groupIndex].presets[aPresetIndex] =
        groups[groupIndex].presets[bPresetIndex];
    groups[groupIndex].presets[bPresetIndex] = temporary;

    notifyListeners();
    _savePresets();
  }

  Future<void> _savePresets() {
    print("save");
    print(groups);
  }

  Future<void> loadSavedPresets() async {
    isLoading = true;

    notifyListeners();

    groups = [
      PlayerHandSettingPresetGroup(
        name: "ABC",
        presets: [
          PlayerHandSettingPreset(
            name: "A",
            parts: {
              HandRangePart(high: Rank.ace, kicker: Rank.ace),
            },
          ),
          PlayerHandSettingPreset(
            name: "B",
            parts: {
              HandRangePart(high: Rank.king, kicker: Rank.king),
            },
          ),
          PlayerHandSettingPreset(
            name: "C",
            parts: {
              HandRangePart(high: Rank.queen, kicker: Rank.queen),
            },
          ),
        ],
      ),
      PlayerHandSettingPresetGroup(
        name: "DEF",
        presets: [
          PlayerHandSettingPreset(
            name: "D",
            parts: {
              HandRangePart(high: Rank.jack, kicker: Rank.jack),
            },
          ),
          PlayerHandSettingPreset(
            name: "E",
            parts: {
              HandRangePart(high: Rank.ten, kicker: Rank.ten),
            },
          ),
          PlayerHandSettingPreset(
            name: "F",
            parts: {
              HandRangePart(high: Rank.nine, kicker: Rank.nine),
            },
          ),
        ],
      ),
      PlayerHandSettingPresetGroup(
        name: "GHI",
        presets: [
          PlayerHandSettingPreset(
            name: "G",
            parts: {
              HandRangePart(high: Rank.ace, kicker: Rank.king),
            },
          ),
          PlayerHandSettingPreset(
            name: "H",
            parts: {
              HandRangePart(high: Rank.king, kicker: Rank.queen),
            },
          ),
          PlayerHandSettingPreset(
            name: "I",
            parts: {
              HandRangePart(high: Rank.queen, kicker: Rank.jack),
            },
          ),
        ],
      ),
      PlayerHandSettingPresetGroup(
        name: "JKL",
        presets: [
          PlayerHandSettingPreset(
            name: "J",
            parts: {
              HandRangePart(high: Rank.ace, kicker: Rank.king, isSuited: true),
            },
          ),
          PlayerHandSettingPreset(
            name: "K",
            parts: {
              HandRangePart(high: Rank.ace, kicker: Rank.queen, isSuited: true),
            },
          ),
          PlayerHandSettingPreset(
            name: "L",
            parts: {
              HandRangePart(high: Rank.ace, kicker: Rank.jack, isSuited: true),
            },
          ),
        ],
      ),
      PlayerHandSettingPresetGroup(
        name: "MNO",
        presets: [
          PlayerHandSettingPreset(
            name: "M",
            parts: {
              HandRangePart(high: Rank.two, kicker: Rank.two),
            },
          ),
          PlayerHandSettingPreset(
            name: "N",
            parts: {
              HandRangePart(high: Rank.three, kicker: Rank.three),
            },
          ),
          PlayerHandSettingPreset(
            name: "O",
            parts: {
              HandRangePart(high: Rank.four, kicker: Rank.four),
            },
          ),
        ],
      ),
    ];
    isLoading = false;

    notifyListeners();
  }

  Future<void> finalize() {}
}
