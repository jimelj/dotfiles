echo  'Hello from .zshenv'


function exists() {
  # `command -v` is similar to `which`
  # http://stackoverflow.com/a/677212/1341838
  command -v $1 >/dev/null 2>&1
  
  # More explicitly written:
  # command -v $1 1>/dev/null 2>/dev/
}