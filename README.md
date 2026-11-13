<h1 align="center"> 💜 Gentoo BSPWM Rice 💜 </h1>

<p align="center">
  <img src="https://img.shields.io/badge/OS-Gentoo_Linux-54487a?style=for-the-badge&logo=gentoo&logoColor=white">
  <img src="https://img.shields.io/badge/WM-BSPWM-white?style=for-the-badge">
  <img src="https://img.shields.io/badge/Terminal-Kitty-green?style=for-the-badge&logo=kitty">
  <img src="https://img.shields.io/badge/Shell-Fish-blue?style=for-the-badge">
</p>

</br>

<!-- INFORMATION -->
<h1 align="left"> 📖 О сборке</h1> 

<img src="demonstration/1.png" alt="rice" align="right" width="500px">

</br>

 - **OS:** [**`Gentoo Linux`**](https://www.gentoo.org/)
 - **WM:** [**`BSPWM`**](https://github.com/baskerville/bspwm)
 - **Bar:** [**`Polybar`**](https://github.com/polybar/polybar) (с фиолетовым логотипом Gentoo и прямоугольными рабочими столами)
 - **Compositor:** [**`Picom`**](https://github.com/yshui/picom)
 - **Terminal:** [**`Kitty`**](https://github.com/kovidgoyal/kitty)
 - **App Launcher:** [**`Rofi`**](https://github.com/davatorium/rofi)
 - **Notify Daemon:** [**`Dunst`**](https://github.com/dunst-project/dunst) (белые обводки и белый индикатор звука)
 - **Hotkeys:** [**`sxhkd`**](https://github.com/baskerville/sxhkd)
 - **Shell:** [**`Fish`**](https://github.com/fish-shell/fish-shell)

</br>

<!-- INSTALLATION -->
## 🚀 Автоматическая установка (Gentoo Linux)

Скрипт автоматически проверит зависимости, установит недостающие пакеты через `emerge` (`doas`/`sudo`), развернёт конфиги и сделает бэкап текущих настроек:

```bash
git clone https://github.com/netanyahy/bspwm-dotfiles.git ~/.dotfiles && cd ~/.dotfiles && chmod +x install_gentoo.sh && ./install_gentoo.sh
```

### Что делает скрипт:
1. Предлагает установить необходимые пакеты через `emerge` (`bspwm`, `sxhkd`, `polybar`, `picom`, `dunst`, `rofi`, `kitty`, `feh`, `flameshot`, `jetbrains-mono`, `symbols-nerd-font` и др.).
2. Делает резервную копию существующих конфигураций в `~/.config/dotfiles_backup_*`.
3. Копирует актуальные настройки в `~/.config/` и скрипты в `~/bin/`.
4. Настраивает права на исполнение (`chmod +x`).

</br>

<!-- FEATURES -->
## ✨ Особенности
* Адаптировано специально под **Gentoo Linux** (включая PipeWire / `gentoo-pipewire-launcher`).
* **Белые строгие акценты:** обводка окон 1px (`#ffffff`), белый OSD громкости и раскладки в Dunst.
* **Кастомные белые SVG-иконки** громкости (`~/.config/bspwm/assets/icons/volume/`).
* **Polybar с логотипом Gentoo:** фиолетовая иконка (`#c678dd`) со смещением на 2px и строгие прямоугольные рабочие столы.
* Автоопределение основного и второго монитора (поддержка высоких разрешений и частот обновления до 180Hz).
* Скрипты управления звуком, яркостью, буфером обмена и скриншотами в `~/bin/`.

</br>

<!-- IMAGES -->
## 🖼️ Галерея
![gallery](demonstration/1.png)
![gallery](demonstration/2.png)
![gallery](demonstration/3.png)
![gallery](demonstration/4.png)
![gallery](demonstration/5.png)

</br>

<!-- HOTKEYS -->
## 💻 Горячие клавиши

| Сочетание | Действие |
| :--- | :--- |
| `Super + Enter` | Запуск терминала (**Kitty**) |
| `Super + W` | Запуск браузера (**Firefox**) |
| `Super + Alt + W` | Установка случайных обоев |
| `Super + Q` | Закрыть активное окно |
| `Super + P` | Скрыть / показать Polybar |
| `Super + D` | Меню приложений (**Rofi**) |
| `Super + V` | Менеджер буфера обмена |
| `Super + Shift + X` | Выбор цвета пипеткой с экрана |
| `Alt + Shift` / `Shift + Alt` | Переключение языка клавиатуры |
| `Print` | Скриншоттер (**Flameshot**) |
| `Ctrl + Shift + R` | Перезапустить BSPWM |
| `Ctrl + Shift + Q` | Выйти из BSPWM |
| `Super + 1-9, 0` | Переключить рабочий стол |
| `Super + Shift + 1-9, 0` | Переместить окно на рабочий стол |
| `Super + Пробел` | Переключить тайлинг / плавающее окно |

Полный список доступен в [~/.config/sxhkd/sxhkdrc](config/sxhkd/sxhkdrc).

---
*Основано на дотфайлах [Zproger/bspwm-dotfiles](https://github.com/Zproger/bspwm-dotfiles).*
