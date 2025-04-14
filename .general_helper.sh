### Extract almost any archive ###

extract() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: extract <file1> [file2 ...]"
    return 1
  fi

  for file in "$@"; do
    if [[ ! -f "$file" ]]; then
      echo "extract: '$file' is not a valid file"
      continue
    fi

    case "${file:l}" in
      *.tar.bz2|*.tbz2)   tar xjf "$file" ;;
      *.tar.gz|*.tgz)     tar xzf "$file" ;;
      *.tar.xz)           tar xJf "$file" ;;
      *.tar)              tar xf "$file" ;;
      *.bz2)              bunzip2 "$file" ;;
      *.gz)               gunzip "$file" ;;
      *.xz)               unxz "$file" ;;
      *.lzma)             unlzma "$file" ;;
      *.zip)              unzip "$file" ;;
      *.rar)              unrar x "$file" ;;
      *.7z)               7z x "$file" ;;
      *.Z)                uncompress "$file" ;;
      *.cab)              cabextract "$file" ;;
      *)                  echo "extract: '$file' - unknown archive type" ;;
    esac
  done
}
