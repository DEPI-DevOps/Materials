 # Sample BASH Scripts

- Script to monitor IP address changes and send them through a telegram bot

  ```bash
  #!/bin/bash
  
  REGEX="^(Deleted )?[0-9]+: (\w+)    inet ([0-9\.\/]+)"
  
  ip monitor address | while read -r event; do
    if [[ $event =~ $REGEX ]]; then
      if [ "${BASH_REMATCH[1]}" = "Deleted " ]; then
        message=$(printf "Deleted %s from interface %s" "${BASH_REMATCH[3]}" "${BASH_REMATCH[2]}")
      else
        message=$(printf "Added %s to interface %s" "${BASH_REMATCH[3]}" "${BASH_REMATCH[2]}")
      fi
  
      if ! curl -sS --data-urlencode "chat_id=<CHAT_ID>" --data-urlencode "text=$message" \
        --max-time 5 \
        "https://api.telegram.org/<BOT_TOKEN>/sendMessage" > /dev/null ; then      
        echo "$message" | sed "s/\./ DOT /g" | flite -voice slt
        echo "$message" | sed "s/\./ DOT /g" | flite -voice slt
      fi
    fi
  done
  ```

- Script to locate RaspberryPi devices on the network

  ```bash
  #!/bin/bash
  
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
  fi
  
  usage="
  Usage: $(basename "$0") [-i INTERFACE] [-m MAC]
  
  Options:
    -i INTERFACE         Network interface to scan
    -m MAC               MAC address of the Pi
  "
  
  export mac="Raspberry"
  
  while getopts "m:i:" option; do
    case $option in
    m) export mac="$OPTARG" ;;
    i) export iface="$OPTARG" ;;
    \?) echo "$usage"; exit 0;;
    esac
  done
  
  if [ "$iface" = "" ]; then
    cmd='ip a'
  else
    cmd="ip a show dev $iface"
  fi
  
  eval "$cmd" | grep "inet " | cut -d ' ' -f 6 | while read -r line; do
    if [ "$line" = "127.0.0.1/8" ]; then continue; fi
    nmap -sP -n "$line" | grep -i -B 2 "$mac" | grep -Po " [\d\.]+" | cut -c2-
  done
  ```

- Script to gather information about x86_64 binaries in a certain directory and their used libraries

  ```bash
  #!/bin/bash
  
  if [ "$#" -ne 1 ] || [ ! -d "$1" ]; then
      echo "usage: ./program.sh <dir>"
      exit
  fi
  
  declare -A libs_x86_64
  while IFS= read -r -d '' program; do
    for lib in $(objdump -p "$program" 2> /dev/null | grep NEEDED | awk '{print $2}'); do
        if file -0 "$program" | cut -d '' -f2 | grep -q 'x86-64'; then
          libs_x86_64[$lib]+=$'\t<= '$program$'\r\n'
        fi
    done
  done < <(find "$1/" -type f -executable -print0 2> /dev/null)
  
  if [ ${#libs_x86_64[@]} -ne 0 ]; then
    while read -r line; do
        printf "%s\n%s\n" "$line" "${libs_x86_64[$(echo "$line" | cut -d' ' -f1)]}"
    done < <(
      for key in "${!libs_x86_64[@]}"; do
              printf "%s ( %d exes )\n" "$key" "$(tr -dc '=' <<< "${libs_x86_64[$key]}" | awk '{ print length; }')"
      done | sort -rn -k3
    )
  fi
  ```

  

