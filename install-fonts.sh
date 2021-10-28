find_command="find . -name '*.[o,t]tf' -type f -print0"

if [[ `uname` == 'Darwin' ]]; then
  # MacOS
  font_dir="$HOME/Library/Fonts"
else
  # Linux
  font_dir="$HOME/.local/share/fonts"
  mkdir -p $font_dir
fi

echo "Running: $find_command | xargs -0 -I % cp \"%\" \"$font_dir/\""

echo "Copying fonts..."
# print fonts to copy to the console
eval $find_command | xargs -0 -I %

# copy the fonts to the font folder
eval $find_command | xargs -0 -I % cp "%" "$font_dir/"

# Reset font cache on Linux
if command -v fc-cache @>/dev/null ; then
    echo -e "\nResetting font cache, this may take a moment..."
    fc-cache -f $font_dir
fi

echo "\nAll fonts have been installed to $font_dir"
