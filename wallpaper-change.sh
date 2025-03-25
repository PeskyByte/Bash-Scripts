#!/bin/bash

WALLPAPER_DIR="$HOME/workspace/Bash-Scripts/images"

SUNRISE_WP="$WALLPAPER_DIR/sunrise.png"
MORNING_WP="$WALLPAPER_DIR/morning.png"
NOON_WP="$WALLPAPER_DIR/noon.png"
EVENING_WP="$WALLPAPER_DIR/evening.png"
SUNSET_WP="$WALLPAPER_DIR/sunset.png"
NIGHT_WP="$WALLPAPER_DIR/night.png"

HOUR=$(date +%H)

set_wallpaper() {
    if [ ! -f "$1" ]; then
        echo "Wallpaper file not found: $1"
        exit 1
    fi

    WALLPAPER_URI="file://$1"
    gsettings set org.gnome.desktop.background picture-uri "$WALLPAPER_URI" 2>/dev/null
    gsettings set org.gnome.desktop.background picture-uri-dark "$WALLPAPER_URI" 2>/dev/null

}

echo "Current hour: $HOUR"

if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 7 ]; then
    # Sunrise (5:00 - 6:59)
    set_wallpaper "$SUNRISE_WP"
    echo "Setting sunrise wallpaper"
elif [ "$HOUR" -ge 7 ] && [ "$HOUR" -lt 11 ]; then
    # Morning (7:00 - 10:59)
    set_wallpaper "$MORNING_WP"
    echo "Setting morning wallpaper"
elif [ "$HOUR" -ge 11 ] && [ "$HOUR" -lt 15 ]; then
    # Noon (11:00 - 14:59)
    set_wallpaper "$NOON_WP"
    echo "Setting noon wallpaper"
elif [ "$HOUR" -ge 15 ] && [ "$HOUR" -lt 18 ]; then
    # Evening (15:00 - 17:59)
    set_wallpaper "$EVENING_WP"
    echo "Setting evening wallpaper"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 20 ]; then
    # Sunset (18:00 - 19:59)
    set_wallpaper "$SUNSET_WP"
    echo "Setting sunset wallpaper"
else
    # Night (20:00 - 4:59)
    set_wallpaper "$NIGHT_WP"
    echo "Setting night wallpaper"
fi