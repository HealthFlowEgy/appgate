import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gateapp_user/config/app_config.dart';
import 'package:gateapp_user/models/auth_response.dart';
import 'package:gateapp_user/models/chat.dart';
import 'package:gateapp_user/models/resident_profile.dart';
import 'package:gateapp_user/models/setting.dart';
import 'package:gateapp_user/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';
import 'constants.dart';

class LocalDataLayer {
  LocalDataLayer._privateConstructor() {
    _initPref();
  }

  static final LocalDataLayer _instance = LocalDataLayer._privateConstructor();

  factory LocalDataLayer() {
    return _instance;
  }

  static const String tokenKey = "key_token";
  static const String userKey = "key_user";
  static const String residentProfileKey = "key_resident_profile";
  static const String settingsKey = "key_settings";
  static const String currentLanguageKey = "key_cur_lang";
  static const String demoLangPromtedKey = "key_demo_lang_promted";
  static const String currentThemeKey = "key_cur_theme";
  static const String chatsLocalKey = "key_chats_local";
  static const String buyThisShownKey = "key_buy_this_app_shown";
  SharedPreferences? _sharedPreferences;

  //holding frequently accessed sharedPreferences in memory.
  List<Setting>? _settingsAll;
  String? _authToken;
  UserData? _userMe;
  ResidentProfile? _residentProfile;

  _initPref() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<bool> initAppSettings() async {
    await _initPref();
    await getAuthenticationToken();
    await getUserMe();
    List<Setting> settingsAll = await getSettings();
    return AppSettings.setupWith(settingsAll);
  }

  Future<String?> getAuthenticationToken() async {
    await _initPref();
    if (_authToken == null && _sharedPreferences!.containsKey(tokenKey)) {
      _authToken = "Bearer ${_sharedPreferences!.getString(tokenKey)}";
    }
    //print("authToken: $_authToken");
    return _authToken;
  }

  saveAuthResponse(AuthResponse authResponse) async {
    await _initPref();
    _authToken = "Bearer ${authResponse.token}";
    _sharedPreferences!.setString(tokenKey, authResponse.token);
    setUserMe(authResponse.user);
  }

  Future<String> getCurrentTheme() async {
    await _initPref();
    return _sharedPreferences!.containsKey(currentThemeKey)
        ? _sharedPreferences!.getString(currentThemeKey)!
        : Constants.themeLight;
  }

  Future<bool> setCurrentThemeDark() async {
    await _initPref();
    return _sharedPreferences!.setString(currentThemeKey, Constants.themeDark);
  }

  Future<bool> setCurrentThemeLight() async {
    await _initPref();
    return _sharedPreferences!.setString(currentThemeKey, Constants.themeLight);
  }

  Future<String> getCurrentLanguage() async {
    await _initPref();
    return _sharedPreferences!.containsKey(currentLanguageKey)
        ? _sharedPreferences!.getString(currentLanguageKey)!
        : AppConfig.languageDefault;
  }

  Future<bool> setCurrentLanguage(String langCode) async {
    await _initPref();
    return _sharedPreferences!.setString(currentLanguageKey, langCode);
  }

  Future<bool> getHasLanguageSelectionPromted() async {
    await _initPref();
    return !_sharedPreferences!.containsKey(demoLangPromtedKey);
  }

  Future<bool> setHasLanguageSelectionPromted() async {
    await _initPref();
    return _sharedPreferences!.setBool(demoLangPromtedKey, true);
  }

  Future<UserData?> getUserMe() async {
    if (_userMe == null) {
      await _initPref();
      _userMe = _sharedPreferences!.containsKey(userKey)
          ? UserData.fromJson(
              jsonDecode(_sharedPreferences!.getString(userKey)!))
          : null;
    }
    if (_userMe != null) _userMe!.setup();
    return _userMe;
  }

  Future<ResidentProfile?> getResidentProfileMe() async {
    if (_residentProfile == null) {
      await _initPref();
      _residentProfile = _sharedPreferences!.containsKey(residentProfileKey)
          ? ResidentProfile.fromJson(
              jsonDecode(_sharedPreferences!.getString(residentProfileKey)!))
          : null;
    }
    if (_residentProfile != null) _residentProfile!.setup();
    return _residentProfile;
  }

  Future<void> setUserMe(UserData userMe) async {
    _userMe = userMe;
    await _initPref();
    _sharedPreferences!.setString(userKey, jsonEncode(_userMe!.toJson()));
  }

  Future<void> setResidentProfileMe(ResidentProfile residentProfile) async {
    _residentProfile = residentProfile;
    await _initPref();
    _sharedPreferences!
        .setString(residentProfileKey, jsonEncode(_residentProfile!.toJson()));
  }

  Future<bool> isLoggedIn() async {
    await _initPref();
    await getAuthenticationToken();
    await getUserMe();
    await getResidentProfileMe();
    return _residentProfile != null;
  }

  Future<bool> clearPrefs() async {
    await _initPref();
    //_settingsAll = null;
    _authToken = null;
    _userMe = null;
    _residentProfile = null;
    bool cleared = await _sharedPreferences!.clear(); //clearing everything
    saveSettings(_settingsAll); //except setting values
    return cleared;
  }

  Future<bool> clearPrefsUser() async {
    await _initPref();
    _authToken = null;
    _userMe = null;
    bool cleared = await _sharedPreferences!.remove(tokenKey);
    cleared = await _sharedPreferences!.remove(userKey);
    return cleared;
  }

  Future<bool> clearPrefKey(String key) async {
    await _initPref();
    return _sharedPreferences!.remove(key);
  }

  Future<bool> saveSettings(List<Setting>? settings) async {
    if (settings != null) {
      _settingsAll = settings;
      await _initPref();
      _sharedPreferences!.setString(settingsKey, jsonEncode(settings));
      return AppSettings.setupWith(settings);
    } else {
      return false;
    }
  }

  Future<List<Setting>> getSettings() async {
    await _initPref();
    String? settingVal = _sharedPreferences!.getString(settingsKey);
    if (settingVal != null && settingVal.isNotEmpty) {
      try {
        return (jsonDecode(settingVal) as List)
            .map((e) => Setting.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print("getSettings(): $e");
        }
        return [];
      }
    } else {
      return [];
    }
  }

  Future<bool> addIfChatUnread(Chat chat) async {
    await _initPref();
    List<Chat> chats = await getChatsLocal();
    int existingIndex = chats.indexOf(chat);
    if (existingIndex == -1) {
      chats.add(chat);
      await setChatsLocal(chats);
      return false;
    } else {
      if (chats[existingIndex].timeDiff != chat.timeDiff) {
        chats[existingIndex] = chat;
        await setChatsLocal(chats);
        return false;
      } else {
        return chats[existingIndex].isRead ?? false;
      }
    }
  }

  setChatRead(Chat chat) async {
    await _initPref();
    List<Chat> chats = await getChatsLocal();
    int existingIndex = chats.indexOf(chat);
    chat.isRead = true;
    if (existingIndex != -1) {
      chats[existingIndex] = chat;
    } else {
      chats.add(chat);
    }
    await setChatsLocal(chats);
  }

  Future<int> getChatsUnreadCount() async {
    await _initPref();
    List<Chat> chats = await getChatsLocal();
    chats.removeWhere((element) => (element.isRead ?? false));
    return chats.length;
  }

  Future<List<Chat>> getChatsLocal() async {
    String? settingVal = _sharedPreferences!.getString(chatsLocalKey);
    if (settingVal != null && settingVal.isNotEmpty) {
      try {
        return (jsonDecode(settingVal) as List)
            .map((e) => Chat.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print("getChatsLocal(): $e");
        }
        return [];
      }
    } else {
      return [];
    }
  }

  Future<bool> setChatsLocal(List<Chat> chats) async {
    await _initPref();
    return _sharedPreferences!.setString(chatsLocalKey, jsonEncode(chats));
  }

  Future<bool> isBuyThisAppPromted() async {
    await _initPref();
    return _sharedPreferences!.containsKey(buyThisShownKey);
  }

  setBuyThisAppPromted() async {
    await _initPref();
    _sharedPreferences!.setBool(buyThisShownKey, true);
  }
}
