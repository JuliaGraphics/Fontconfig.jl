using BinDeps
using Compat

@BinDeps.setup

freetype = library_dependency("freetype", aliases = ["libfreetype"])
fontconfig = library_dependency("fontconfig", aliases = ["libfontconfig-1", "libfontconfig", "libfontconfig.so.1"], depends = [freetype])


if is_apple()
    using Homebrew
    provides(Homebrew.HB, "freetype", freetype, os = :Darwin)
    provides(Homebrew.HB, "fontconfig", fontconfig, os = :Darwin)
end

if is_windows()
    using WinRPM
    provides(WinRPM.RPM, "freetype", freetype, os = :Windows)
    provides(WinRPM.RPM, "fontconfig", fontconfig, os = :Windows)
end

# System Package Managers
provides(AptGet,
    Dict(
        "libfontconfig1" => fontconfig
    ))

provides(Zypper,
    Dict(
        "libfontconfig" => fontconfig
    ))

@BinDeps.install Dict(:fontconfig => :libfontconfig)
