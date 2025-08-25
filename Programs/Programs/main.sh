#!/bin/bash

declare -A FILE_TYPES=(
  ["Documents"]="txt pdf docx xlsx pptx"
  ["Images"]="jpg jpeg png gif"
  ["Videos"]="mp4 mkv mov avi"
  ["Audio"]="mp3 wav aac"
  ["Archives"]="zip rar tar gz"
  ["Programs"]="exe msi sh bat"
  ["Others"]=""
)

organize() {
  local dir=$1

  if [[ ! -d "$dir" ]]; then
    echo "directory $dir does not exist"
    return 1
  fi

  for fp in "$dir"/*; do
    [[ -f "$fp" ]] || continue

    fn=$(basename "$fp")
    extention="${fn##*.}"
    extention="${extention,,}"

    category="Others"
    for folder in "${!FILE_TYPES[@]}"; do
      for ext in ${FILE_TYPES[$folder]}; do
        if [[ "$extention" == "$ext" ]]; then
          category=$folder
          break 2
        fi
      done
    done


    category_path="$dir/$category"
    mkdir -p "$category_path"

    mv "$fp" "$category_path/"
    echo "Moved $fn-> $category/"

  done
}
read -rp "please enter the folder path you want to organize: " path
organize "$path"
