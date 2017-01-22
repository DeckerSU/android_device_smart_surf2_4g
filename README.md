## [ROM][UNOFFICIAL][6.0.1] CyanogenMod 13 for MTC Smart Surf2 4G ## (Decker, [http://www.decker.su](http://www.decker.su))

Сборка для запуска на стоковом ядрке 3.18.19 (!), 32-bit.

О прошивке
----------

CyanogenMod 13 (6.0.1) для [МТС Smart Surf2 4G](http://www.decker.su/2016/11/mts-smart-surf2-4g-quick-review.html). Ранее для этого же устройства я собирал [CM14.1](http://www.decker.su/2016/12/smart-surf2-4g-android-nougat-711.html), теперь вот решил поработать над CM13. Основное время отнял запуск RIL, на анализ логов, поиски проблемы и патчей в общем случае было потрачено более 18 часов. На данный момент в прошивке работают:

- RIL (сотовая связь), проверялись только голосовые вызовы. Передачу данных не пробовал.
- WIFi (устанавливается связь с точкой доступа, работает передача данных), однако, возможно что MAC адрес устройства передается некорректно. Пока не было времени посмотреть.
- GPS (полномасштабный тест не проводился, но в GPS Test'е местоположение определятся).
- Камера (основная и фронтальная камеры работают в режиме фото, съемка видео пока не работает).
- Светодиод вспышки.
- Звук
- Live Display
- Запись экрана (screen recording)

Не работает Bluetooth ... и возможно еще что-то ;) (прошивка пока еще сырая, так что количество вещей которые не работают может быть существенно больше) 

Сборка
------

Сборка проводится обычным способом, предполагается что вы установили все тулчейны и сделали repo sync CM13:

    cd ~/cm-13.0
    . build/envsetup.sh
    git clone https://github.com/DeckerSU/android_device_smart_surf2_4g -b cm13.0-test01 device/mts/smart_surf2_4g
    git clone https://github.com/DeckerSU/android_vendor_smart_surf2_4g -b cm13.0-test01 vendor/mts/smart_surf2_4g
    breakfast smart_surf2_4g (или lunch, а потом выбор комбо)
    cd device/mts/smart_surf2_4g/patches_decker
    . apply_patches.sh
    cd ../../../..
    make -j9 bacon (или make -j9 bacon 2>&1 | tee device/mts/smart_surf2_4g/build.log с записью в лог) 

Патчи применять обязательно, если какие-то из них не прописаны в apply_patches.sh (работа над деревом ведется до сих пор, поэтому я мог что-то просто забыть) необходимо применить их вручную.

Все замечания, проблемы, ошибки и т.п. с которыми я сталкивался при подготовке дерева теперь описаны в NOTES.md , это своеобразная история заметок для себя, которую можно читать, а можно нет.

Благодарности
-------------

- @Ruslan_3 - за то что когда-то давным давно заинтересовал меня темой сборки Android вообще ;)
- [Nonta72](https://github.com/Nonta72) - за дерево устройства [android_device_d5110_infinix](https://github.com/Nonta72/android_device_d5110_infinix/tree/cm-13.0) для [Infinix HOT 2](https://forum.xda-developers.com/hot-2/development/rom-cyanogenmod-13-t3442726). Несмотря на то что HOT 2 построен на базе MT6580, в качестве старта я взял именно это дерево, хотя многие вещи пришлось поправить.
- [Lucky76](https://github.com/Lucky76) за дерево для [Ulefone Metal](https://github.com/Lucky76/android_device_ulefone_metal).
- Xen0n
- olegsvs
- Deepflex 
- CyanogenMod team

И многим другим, чьи имена по каким-то причинам не попали в этот список ... 

О проекте
---------

- Decker's Blog - [http://www.decker.su/](http://www.decker.su/)
- [Поддержка проекта](http://donate.decker.su/)

