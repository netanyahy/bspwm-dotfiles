#!/usr/bin/env bash
# ==============================================================================
#  Gentoo Linux BSPWM Rice Auto-Installer
#  Repository: https://github.com/netanyahy/bspwm-dotfiles
# ==============================================================================

set -e

# Colors
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_PURPLE="\033[38;2;198;120;221m"
C_BLUE="\033[38;2;97;175;239m"
C_GREEN="\033[38;2;152;195;121m"
C_YELLOW="\033[38;2;229;192;123m"
C_RED="\033[38;2;224;108;117m"

echo -e "${C_PURPLE}${C_BOLD}"
cat << "EOF"
   ____            _               ____  ____  ______        ____  __ 
  / ___| ___ _ __ | |_ ___   ___  | __ )/ ___||  _ \ \      / /  \/  |
 | |  _ / _ \ '_ \| __/ _ \ / _ \ |  _ \\___ \| |_) \ \ /\ / /| |\/| |
 | |_| |  __/ | | | || (_) | (_) || |_) |___) |  __/ \ V  V / | |  | |
  \____|\___|_| |_|\__\___/ \___/ |____/|____/|_|     \_/\_/  |_|  |_|
                 Gentoo Rice Auto-Installer by netanyahy
EOF
echo -e "${C_RESET}"

# 1. Detect elevation tool (doas or sudo)
PRIVILEGE_CMD=""
if command -v doas >/dev/null 2>&1; then
    PRIVILEGE_CMD="doas"
elif command -v sudo >/dev/null 2>&1; then
    PRIVILEGE_CMD="sudo"
elif [ "$(id -u)" -eq 0 ]; then
    PRIVILEGE_CMD=""
else
    echo -e "${C_RED}[!] Ни sudo, ни doas не найдены. Установите их или запустите от root.${C_RESET}"
    exit 1
fi

echo -e "${C_BLUE}[*] Используем команду повышения привилегий:${C_RESET} ${PRIVILEGE_CMD:-root}"

# 2. Package list for Gentoo
GENTOO_PKGS=(
    # Window Manager & Hotkeys
    "x11-wm/bspwm"
    "x11-misc/sxhkd"
    
    # Status bar, compositor, notifications, launcher
    "x11-misc/polybar"
    "x11-misc/picom"
    "x11-misc/dunst"
    "x11-misc/rofi"
    
    # Terminal, file manager, clipboard
    "x11-terms/kitty"
    "xfce-base/thunar"
    "x11-misc/xclip"
    
    # X11 essentials & wallpaper
    "media-gfx/feh"
    "x11-apps/xrandr"
    "x11-apps/xrdb"
    "x11-apps/setxkbmap"
    
    # Audio, screenshot, brightness
    "media-sound/pavucontrol"
    "media-gfx/flameshot"
    "x11-misc/brightnessctl"
    
    # Fonts
    "media-fonts/jetbrains-mono"
    "media-fonts/symbols-nerd-font"
)

echo -e "\n${C_PURPLE}[1/5] Установка пакетов Gentoo через emerge...${C_RESET}"
echo -e "${C_YELLOW}Будут установлены следующие пакеты:${C_RESET}"
for pkg in "${GENTOO_PKGS[@]}"; do
    echo "  - $pkg"
done

read -p "Желаете установить/обновить эти пакеты сейчас? [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    echo -e "${C_BLUE}[*] Запуск emerge...${C_RESET}"
    $PRIVILEGE_CMD emerge --noreplace --verbose "${GENTOO_PKGS[@]}"
else
    echo -e "${C_YELLOW}[-] Пропуск установки пакетов emerge.${C_RESET}"
fi

# 3. Screen Resolution Setup
echo -e "\n${C_PURPLE}[2/5] Настройка разрешения экрана...${C_RESET}"
DEF_RES="2560x1440"
DEF_RATE="180"

# Auto-detect available resolution and rate via xrandr
if command -v xrandr >/dev/null 2>&1; then
    DETECTED_RES=$(xrandr 2>/dev/null | grep -E '^[ ]+[0-9]+x[0-9]+' | awk '{print $1}' | head -n1)
    DETECTED_RATE=$(xrandr 2>/dev/null | grep -E '^[ ]+[0-9]+x[0-9]+.*(\*|\+)' | awk '{for(i=2;i<=NF;i++) if($i ~ /[*+]/) {gsub(/[*+]/,"",$i); print int($i); exit}}')
    [ -n "$DETECTED_RES" ] && DEF_RES="$DETECTED_RES"
    [ -n "$DETECTED_RATE" ] && DEF_RATE="$DETECTED_RATE"
fi

echo -e "${C_BLUE}[*] Обнаруженное/рекомендуемое разрешение:${C_RESET} ${C_BOLD}${DEF_RES}${C_RESET} (${DEF_RATE} Hz)"
read -p "Введите ваше разрешение экрана [по умолчанию: $DEF_RES]: " USER_RES
USER_RES="${USER_RES:-$DEF_RES}"

read -p "Введите частоту обновления (Hz) [по умолчанию: $DEF_RATE, или Enter]: " USER_RATE
USER_RATE="${USER_RATE:-$DEF_RATE}"

echo -e "${C_GREEN}[+] Сохраняем разрешение: ${USER_RES} @ ${USER_RATE}Hz${C_RESET}"

mkdir -p "$HOME/.config/bspwm"
cat << EOF > "$HOME/.config/bspwm/monitor.conf"
# Monitor resolution and refresh rate
PRIMARY_MODE="$USER_RES"
PRIMARY_RATE="$USER_RATE"
EOF

# 4. Deploy Dotfiles
echo -e "\n${C_PURPLE}[3/5] Развёртывание конфигураций...${C_RESET}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/bin"

# Backup and copy configs
for dir in bspwm sxhkd polybar dunst rofi; do
    if [ -d "$HOME/.config/$dir" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${C_YELLOW}[!] Резервная копия ~/.config/$dir -> $BACKUP_DIR/$dir${C_RESET}"
        cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi
    if [ -d "$SCRIPT_DIR/config/$dir" ]; then
        echo -e "${C_GREEN}[+] Копирование config/$dir -> ~/.config/$dir${C_RESET}"
        cp -r "$SCRIPT_DIR/config/$dir" "$HOME/.config/"
    fi
done

# Keep user's chosen monitor.conf
cat << EOF > "$HOME/.config/bspwm/monitor.conf"
# Monitor resolution and refresh rate
PRIMARY_MODE="$USER_RES"
PRIMARY_RATE="$USER_RATE"
EOF

# Copy bin scripts
echo -e "${C_GREEN}[+] Копирование утилит bin/ -> ~/bin/${C_RESET}"
cp -r "$SCRIPT_DIR/bin/"* "$HOME/bin/"
chmod +x "$HOME/bin/"*
chmod +x "$HOME/.config/bspwm/bspwmrc"
chmod +x "$HOME/.config/bspwm/dual_monitors.sh"
chmod +x "$HOME/.config/polybar/launch.sh"

# Apply resolution immediately if X11 is running
if command -v xrandr >/dev/null 2>&1 && [ -n "$DISPLAY" ]; then
    PRIMARY_MON=$(xrandr --query 2>/dev/null | awk '/ connected/{print $1; exit}')
    if [ -n "$PRIMARY_MON" ]; then
        echo -e "${C_BLUE}[*] Применяем разрешение ${USER_RES} к ${PRIMARY_MON}...${C_RESET}"
        xrandr --output "$PRIMARY_MON" --mode "$USER_RES" --rate "$USER_RATE" 2>/dev/null || \
        xrandr --output "$PRIMARY_MON" --mode "$USER_RES" 2>/dev/null || true
    fi
fi

# Copy Xresources if present
if [ -f "$SCRIPT_DIR/Xresources" ]; then
    echo -e "${C_GREEN}[+] Копирование Xresources -> ~/.Xresources${C_RESET}"
    cp "$SCRIPT_DIR/Xresources" "$HOME/.Xresources"
    xrdb merge "$HOME/.Xresources" 2>/dev/null || true
fi

# 5. PATH Verification
echo -e "\n${C_PURPLE}[4/5] Проверка переменной PATH...${C_RESET}"
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo -e "${C_YELLOW}[!] Добавляем ~/bin в PATH...${C_RESET}"
    if [ -f "$HOME/.bashrc" ]; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ]; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.zshrc"
    fi
    if [ -d "$HOME/.config/fish" ]; then
        mkdir -p "$HOME/.config/fish/conf.d"
        echo 'fish_add_path ~/bin' >> "$HOME/.config/fish/conf.d/bspwm_path.fish"
    fi
fi

# 6. Wallpapers
echo -e "\n${C_PURPLE}[5/5] Настройка обоев...${C_RESET}"
mkdir -p "$HOME/Images"
if [ -d "$SCRIPT_DIR/wallpapers" ] && [ "$(ls -A "$SCRIPT_DIR/wallpapers" 2>/dev/null)" ]; then
    echo -e "${C_GREEN}[+] Копирование обоев в ~/Images/...${C_RESET}"
    cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/Images/"
fi

echo -e "\n${C_GREEN}${C_BOLD}================================================================${C_RESET}"
echo -e "${C_GREEN}${C_BOLD} Установка Gentoo BSPWM Rice успешно завершена! ${C_RESET}"
echo -e "${C_GREEN}${C_BOLD} Разрешение экрана: ${USER_RES} @ ${USER_RATE}Hz ${C_RESET}"
echo -e "${C_GREEN}${C_BOLD}================================================================${C_RESET}"
echo -e "${C_BLUE}Для запуска BSPWM добавьте в ~/.xinitrc:${C_RESET}"
echo -e "    ${C_BOLD}exec bspwm${C_RESET}"
echo -e "${C_BLUE}И запустите сессию командой:${C_RESET} ${C_BOLD}startx${C_RESET}\n"
