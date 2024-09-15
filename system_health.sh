#!/bin/bash

print_header(){
    echo
    echo "==== $1 ===="
}

idle_percentage=$(top -b -n1 | grep '%Cpu' | awk '{print $8}')
cpu_percentage=$(awk "BEGIN {print 100 - $idle_percentage}")
print_header "CPU"
echo "Used cpu percentage: ${cpu_percentage}%"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | awk 'NR==1 || NR>2' | head -n 6

mem=$(free -m | grep 'Mem: ' | awk '{print $2, $3, $7}')
total_memory=$(echo $mem | cut -d " " -f 1)
used_memory=$(echo $mem | cut -d " " -f 2)
free_memory=$(($total_memory-$used_memory)) 
memory_percentage=$(($used_memory*100/$total_memory))

print_header "Memory"
echo "Total memory: ${total_memory} Mi" 
echo "Used memory:  ${used_memory} Mi" 
echo "Free memory:  ${free_memory} Mi" 
echo "Used %:       ${memory_percentage}%"

space=$(df -h / | awk 'NR==2 {print $2, $3, $4, $5}')
total_space=$(echo $space | cut -d " " -f 1)
used_space=$(echo $space | cut -d " " -f 2)
free_space=$(echo $space | cut -d " " -f 3)
space_percentage=$(echo $space | cut -d " " -f 4)

print_header "Disk Space"
echo "Total space: ${total_space}"
echo "Used space:  ${used_space}"
echo "Free space:  ${free_space}"
echo "Used %:      ${space_percentage}"

cpu_percentage=$(echo "$cpu_percentage" | tr -cd [:digit:])
cpu_percentage=${cpu_percentage%?}
space_percentage=${space_percentage%?}

print_header "Report"
if [ "$cpu_percentage" -gt 90 ]; then
    echo "High CPU usage, exit unused applications"
else 
    echo "CPU OK"
fi
if [ "$memory_percentage" -gt 90 ]; then
    echo "Low memory, exit unused applications"
else 
    echo "Memory OK"
fi

if [ "$space_percentage" -gt 75 ]; then
    echo "Low disk space, delete unused applications"
else 
    echo "Disk space OK"
fi

print_header "Updates"
choice="n"
read -r -p "Do you want to check for system updates? (y/n) " choice
if [[ "$choice" =~ ^[Nn][Oo]?$ ]] || [[ -z "$choice" ]]; then
    exit 0
fi

if command -v apt-get &> /dev/null; then
    echo "Debian-based system detected"
    sudo apt-get update
    sudo apt-get upgrade
elif command -v dnf &> /dev/null; then
    echo "Fedora-based system detected"
    sudo dnf upgrade
elif command -v pacman &> /dev/null; then
    echo "Arch-based system detected"
    sudo pacman -Syu
else
    echo "Unable to determine available updates. Please check manually."
fi