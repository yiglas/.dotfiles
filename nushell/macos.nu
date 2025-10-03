export-env {
  # Prepend common Homebrew & pnpm paths safely (avoid duplicates)
  $env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend "/opt/homebrew/sbin"
    | prepend "/opt/homebrew/bin"
    | prepend "/Users/devinsackett/Library/pnpm"
    | uniq
    | str join (char esep)
  )

  # .NET SDK path (brew-managed)
  $env.DOTNET_ROOT = "/opt/homebrew/opt/dotnet/libexec"
}
