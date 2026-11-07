mkcd() {
  [[ -z "$1" ]] && { echo "Usage: mkcd <directory>"; return 1; }
  mkdir -p "$1" && cd "$1"
}

extract() {
  [[ ! -f "$1" ]] && { echo "'$1' is not a file"; return 1; }
  case "$1" in
    *.tar.gz|*.tgz)  tar xzf "$1" ;;
    *.tar.bz2|*.tbz) tar xjf "$1" ;;
    *.tar.xz)        tar xJf "$1" ;;
    *.tar)           tar xf  "$1" ;;
    *.zip)           unzip   "$1" ;;
    *.gz)            gunzip  "$1" ;;
    *.bz2)           bunzip2 "$1" ;;
    *.xz)            unxz    "$1" ;;
    *)               echo "Unknown format: $1"; return 1 ;;
  esac
}

port() {
  [[ "$1" =~ ^[0-9]+$ ]] || { echo "Usage: port <number>"; return 1; }
  lsof -i :"$1"
}

ports() {
  lsof -i -P -n | grep LISTEN
}
