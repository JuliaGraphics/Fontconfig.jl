using BinDeps
using Compat

@BinDeps.setup

freetype = library_dependency("freetype", aliases = ["libfreetype", "libfreetype-6"])
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

provides(Yum,
    @compat Dict(
        "fontconfig" => fontconfig
    ))

provides(Zypper,
    Dict(
        "libfontconfig" => fontconfig
    ))

provides(Sources,
    Dict(
        URI("http://download.savannah.gnu.org/releases/freetype/freetype-2.4.11.tar.gz") => freetype,
        URI("http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.10.2.tar.gz") => fontconfig
    ))

xx(t...) = (is_windows() ? t[1] : (is_linux() || length(t) == 2) ? t[2] : t[3])

provides(BuildProcess,
    Dict(
        Autotools(libtarget = xx("objs/.libs/libfreetype.la","libfreetype.la")) => freetype,
        Autotools(libtarget = "src/libfontconfig.la") => fontconfig
    ))

@BinDeps.install Dict(:fontconfig => :jl_libfontconfig)
