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

mutable struct Pattern
    ptr::Ptr{Nothing}

    function Pattern(; args...)
        ptr = ccall((:FcPatternCreate, libfontconfig), Ptr{Nothing}, ())

        for (attr, value) in args
            if attr in string_attrs
                ccall((:FcPatternAddString, libfontconfig), Cint,
                      (Ptr{Nothing}, Ptr{UInt8}, Ptr{UInt8}),
                      ptr, string(attr), value)
            elseif attr in double_attrs
                ccall((:FcPatternAddDouble, libfontconfig), Cint,
                      (Ptr{Nothing}, Ptr{UInt8}, Cdouble),
                      ptr, string(attr), value)
            elseif attr in integer_attrs
                ccall((:FcPatternAddInteger, libfontconfig), Cint,
                      (Ptr{Nothing}, Ptr{UInt8}, Cint),
                      ptr, string(attr), value)
            elseif attr in bool_attrs
                ccall((:FcPatternAddBool, libfontconfig), Cint,
                      (Ptr{Nothing}, Ptr{UInt8}, Cint),
                      ptr, string(attr), value)
            end
        end

        pat = new(ptr)
        finalizer(pat -> ccall((:FcPatternDestroy, libfontconfig), Nothing,
                                    (Ptr{Nothing},), pat.ptr), pat)
        return pat
    end

    function Pattern(ptr::Ptr{Nothing})
        return new(ptr)
    end

    function Pattern(name::AbstractString)
        ptr = ccall((:FcNameParse, libfontconfig), Ptr{Nothing}, (Ptr{UInt8},), name)
        pat = new(ptr)
        finalizer(pat -> ccall((:FcPatternDestroy, libfontconfig), Nothing,
                                    (Ptr{Nothing},), pat.ptr), pat)
        return pat
    end
end


function Base.show(io::IO, pat::Pattern)
    desc = ccall((:FcNameUnparse, libfontconfig), Ptr{UInt8},
                 (Ptr{Nothing},), pat.ptr)
    @printf(io, "Fontconfig.Pattern(\"%s\")", unsafe_string(desc))
    Libc.free(desc)
end


function Base.match(pat::Pattern, default_substitute::Bool=true)
    ccall((:FcConfigSubstitute, libfontconfig),
          UInt8, (Ptr{Nothing}, Ptr{Nothing}, Int32),
          C_NULL, pat.ptr, FcMatchPattern)

    if default_substitute
        ccall((:FcDefaultSubstitute, libfontconfig),
              Nothing, (Ptr{Nothing},), pat.ptr)
    end

    result = Int32[0]
    mat = ccall((:FcFontMatch, libfontconfig),
                Ptr{Nothing}, (Ptr{Nothing}, Ptr{Nothing}, Ptr{Int32}),
                C_NULL, pat.ptr, result)

    if result[1] != 0
        error(string("Fontconfig was unable to match font ", pat))
    end

    return Pattern(mat)
end


function format(pat::Pattern, fmt::AbstractString="%{=fclist}")
    desc = ccall((:FcPatternFormat, libfontconfig), Ptr{UInt8},
                 (Ptr{Nothing}, Ptr{UInt8}), pat.ptr, fmt)
    if desc == C_NULL
        error("Invalid fontconfig format.")
    end
    descstr = unsafe_string(desc)
    Libc.free(desc)
    return descstr
end


struct FcFontSet
    nfont::Cint
    sfont::Cint
    fonts::Ptr{Ptr{Nothing}}
end


"""
    list(pat::Pattern=Pattern(), properties = ["family", "style", "file"])::Vector{Pattern}
    
Selects fonts matching `pat` and creates patterns from those fonts. These patterns containing only those 
properties listed in `properties`, and returns a vector of unique such patterns, as a `Vector{Pattern}`.
"""
function list(pat::Pattern=Pattern(), properties = ["family", "style", "file"])
    os = ccall((:FcObjectSetCreate, libfontconfig), Ptr{Nothing}, ())
    ccall((:FcObjectSetAdd, libfontconfig), Cint, (Ptr{Nothing}, Ptr{UInt8}),
          os, "family")
    ccall((:FcObjectSetAdd, libfontconfig), Cint, (Ptr{Nothing}, Ptr{UInt8}),
          os, "style")
    ccall((:FcObjectSetAdd, libfontconfig), Cint, (Ptr{Nothing}, Ptr{UInt8}),
          os, "file")

    fs_ptr = ccall((:FcFontList, libfontconfig), Ptr{FcFontSet},
                   (Ptr{Nothing}, Ptr{Nothing}, Ptr{Nothing}), C_NULL, pat.ptr, os)
    fs = unsafe_load(fs_ptr)

    patterns = Pattern[]
    for i in 1:fs.nfont
        push!(patterns, Pattern(unsafe_load(fs.fonts, i)))
    end

    ccall((:FcObjectSetDestroy, libfontconfig), Nothing, (Ptr{Nothing},), os)

    return patterns
end


end # module
