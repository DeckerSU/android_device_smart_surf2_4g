[ROM][UNOFFICIAL][6.0.1] CyanogenMod 13 for MTC Smart Surf2 4G (Decker, http://www.decker.su)

Сборка для запуска на стоковом ядрке 3.18.19 (!), 32-bit.

Внимание! Это тестовое дерево для сборки CM13.0 для МТС Smart Surf2 4G. Работы над деревом ведутся в данный момент,
поэтому прошивка может не собираться / не запускаться и т.п. 

https://github.com/Nonta72/android_device_d5110_infinix/tree/cm-13.0 - дерево построено на основе этого CyanogenMod 13 for HOT 2.
https://forum.xda-developers.com/hot-2/development/rom-cyanogenmod-13-t3442726

Заметки (Decker)
----------------

ERROR: /home/decker/cm-13.0/frameworks/opt/telephony/../../../device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java:299: Operators cannot be resolved to a type
ERROR: /home/decker/cm-13.0/frameworks/opt/telephony/../../../device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java:299: Operators cannot be resolved to a type
ERROR: /home/decker/cm-13.0/frameworks/opt/telephony/../../../device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java:828: Operators cannot be resolved to a type
ERROR: /home/decker/cm-13.0/frameworks/opt/telephony/../../../device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java:828: Operators cannot be resolved to a type

device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java.bak 

            if (strings[i] != null && (strings[i].equals("") || strings[i].equals(strings[i+2]))) {
[!]		Operators init = new Operators ();
		String temp = init.unOptimizedOperatorReplace(strings[i+2]);
		riljLog("lookup RIL responseOperatorInfos() " + strings[i+2] + " gave " + temp);
                strings[i] = temp;
                strings[i+1] = temp;
            }


MediaTekRIL.java и gps.h временно убраны из дерева (добавлено расширение .bak) чтобы убрать проблемы при сборке.
Отсутствующий Operators.java необходимый для сборки MediaTekRIL.java можно посмотреть здесь:
https://github.com/SeriniTY320/android_device_THL4000-cm-13.0/blob/master/ril/telephony/java/com/android/internal/telephony/Operators.java

libmtkplayer необходимый для FM Radio пока отключен в Vendor'е.

При сборке применен патч /home/decker/cm-13.0/external/sepolicy для поддержки POLICYVERS := 29, содержимое
/home/decker/cm-13.0/external/sepolicy которое использовалось при сборке есть в архиве external_sepolicy.tar

Что работает, что не работает
-----------------------------

1. На данный момент работает запуск прошивки и отображение графики. Все остальное можно сказать не работает, т.е.
*не работает*:

WiFi, RIL, звук, камера и т.п.

Надо смотреть что сделано в дереве от CM14 и пробовать перенести изменения сюда.

Несколько интересных на мой взгляд деревьев
-------------------------------------------

Деревья для сборки CM13:

https://github.com/ferhung-mtk/android_device_Xiaomi_HM2014011 - 6582
https://github.com/Nonta72/android_device_d5110_infinix/tree/cm-13.0 - 6580 (3.18.19)
https://github.com/jsharma44/android_device_GIONEE_WBL7511
https://github.com/SeriniTY320/android_device_THL4000-cm-13.0