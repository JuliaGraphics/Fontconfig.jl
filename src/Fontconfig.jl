module Fontconfig

using Printf
using Fontconfig_jll

export format, match, list

function __init__()
    ENV["FONTCONFIG_FILE"] = fonts_conf
    ccall((:FcInit, libfontconfig), UInt8, ())

    # By default fontconfig on OSX does not include user fonts.
    @static if Sys.isapple()
        ccall((:FcConfigAppFontAddDir, libfontconfig),
               UInt8, (Ptr{Nothing}, Ptr{UInt8}),
               C_NULL, b"~/Library/Fonts")
    end
end


const FcMatchPattern = UInt32(0)
const FcMatchFont    = UInt32(1)
const FcMatchScan    = UInt32(2)

const string_attrs = Set([:family, :style, :foundry, :file, :lang,
                          :fullname, :familylang, :stylelang, :fullnamelang,
                          :compatibility, :fontformat, :fontfeatures, :namelang,
                          :prgname, :hash, :postscriptname])

const double_attrs = Set([:size, :aspect, :pixelsize, :scale, :dpi])

const integer_attrs =  Set([:slant, :weight, :spacing, :hintstyle, :width, :index,
                            :rgba, :fontversion, :lcdfilter])

const bool_attrs = Set([:antialias, :histing, :verticallayout, :autohint, :outline,
                        :scalable, :minspace, :embolden, :embeddedbitmap,
                        :decorative])

include("types.jl")
include("pattern.jl")



end # module
