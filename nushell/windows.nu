export alias cat = open

export-env {
  $env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64"
    | uniq
    | str join (char esep)
  )
}
