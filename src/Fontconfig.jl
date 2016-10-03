
VERSION >= v"0.4.0-dev+6521" && __precompile__()

module Fontconfig

using Compat

export format, match, list

if Pkg.installed("Homebrew") != nothing
    using Homebrew
end

function __init__()

    @static if is_apple()
        if Pkg.installed("Homebrew") != nothing
            if Homebrew.installed("fontconfig")
                ENV["FONTCONFIG_FILE"] = joinpath(Homebrew.prefix(), "etc", "fonts", "fonts.conf")
            end
        end
    end

    ccall((:FcInit, :libfontconfig), UInt8, ())

    # By default fontconfig on OSX does not include user fonts.
    @static if is_apple()
        ccall((:FcConfigAppFontAddDir, :libfontconfig),
               UInt8, (Ptr{Void}, Ptr{UInt8}),
               C_NULL, b"~/Library/Fonts")
    end
end


const FcMatchPattern = @compat UInt32(0)
const FcMatchFont    = @compat UInt32(1)
const FcMatchScan    = @compat UInt32(2)

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

type Pattern
    ptr::Ptr{Void}

    function Pattern(; args...)
        ptr = ccall((:FcPatternCreate, :libfontconfig), Ptr{Void}, ())

        for (attr, value) in args
            if attr in string_attrs
                ccall((:FcPatternAddString, :libfontconfig), Cint,
                      (Ptr{Void}, Ptr{UInt8}, Ptr{UInt8}),
                      ptr, string(attr), value)
            elseif attr in double_attrs
                ccall((:FcPatternAddDouble, :libfontconfig), Cint,
                      (Ptr{Void}, Ptr{UInt8}, Cdouble),
                      ptr, string(attr), value)
            elseif attr in integer_attrs
                ccall((:FcPatternAddInteger, :libfontconfig), Cint,
                      (Ptr{Void}, Ptr{UInt8}, Cint),
                      ptr, string(attr), value)
            elseif attr in bool_attrs
                ccall((:FcPatternAddBool, :libfontconfig), Cint,
                      (Ptr{Void}, Ptr{UInt8}, Cint),
                      ptr, string(attr), value)
            end
        end

        pat = new(ptr)
        finalizer(pat, pat -> ccall((:FcPatternDestroy, :libfontconfig), Void,
                                    (Ptr{Void},), pat.ptr))
        return pat
    end

    function Pattern(ptr::Ptr{Void})
        return new(ptr)
    end

    function Pattern(name::AbstractString)
        ptr = ccall((:FcNameParse, :libfontconfig), Ptr{Void}, (Ptr{UInt8},), name)
        pat = new(ptr)
        finalizer(pat, pat -> ccall((:FcPatternDestroy, :libfontconfig), Void,
                                    (Ptr{Void},), pat.ptr))
        return pat
    end
end


function Base.show(io::IO, pat::Pattern)
    desc = ccall((:FcNameUnparse, :libfontconfig), Ptr{UInt8},
                 (Ptr{Void},), pat.ptr)
    @printf(io, "Fontconfig.Pattern(\"%s\")", unsafe_string(desc))
    @compat Libc.free(desc)
end


function Base.match(pat::Pattern, default_substitute::Bool=true)
    ccall((:FcConfigSubstitute, :libfontconfig),
          UInt8, (Ptr{Void}, Ptr{Void}, Int32),
          C_NULL, pat.ptr, FcMatchPattern)

    if default_substitute
        ccall((:FcDefaultSubstitute, :libfontconfig),
              Void, (Ptr{Void},), pat.ptr)
    end

    result = Int32[0]
    mat = ccall((:FcFontMatch, :libfontconfig),
                Ptr{Void}, (Ptr{Void}, Ptr{Void}, Ptr{Int32}),
                C_NULL, pat.ptr, result)

    if result[1] != 0
        error(string("Fontconfig was unable to match font ", pat))
    end

    return Pattern(mat)
end


function format(pat::Pattern, fmt::AbstractString="%{=fclist}")
    desc = ccall((:FcPatternFormat, :libfontconfig), Ptr{UInt8},
                 (Ptr{Void}, Ptr{UInt8}), pat.ptr, fmt)
    if desc == C_NULL
        error("Invalid fontconfig format.")
    end
    descstr = unsafe_string(desc)
    @compat Libc.free(desc)
    return descstr
end


immutable FcFontSet
    nfont::Cint
    sfont::Cint
    fonts::Ptr{Ptr{Void}}
end


function list(pat::Pattern=Pattern())
    os = ccall((:FcObjectSetCreate, :libfontconfig), Ptr{Void}, ())
    ccall((:FcObjectSetAdd, :libfontconfig), Cint, (Ptr{Void}, Ptr{UInt8}),
          os, "family")
    ccall((:FcObjectSetAdd, :libfontconfig), Cint, (Ptr{Void}, Ptr{UInt8}),
          os, "style")
    ccall((:FcObjectSetAdd, :libfontconfig), Cint, (Ptr{Void}, Ptr{UInt8}),
          os, "file")

    fs_ptr = ccall((:FcFontList, :libfontconfig), Ptr{FcFontSet},
                   (Ptr{Void}, Ptr{Void}, Ptr{Void}), C_NULL, pat.ptr, os)
    fs = unsafe_load(fs_ptr)

    patterns = Pattern[]
    for i in 1:fs.nfont
        push!(patterns, Pattern(unsafe_load(fs.fonts, i)))
    end

    ccall((:FcObjectSetDestroy, :libfontconfig), Void, (Ptr{Void},), os)

    return patterns
end


end # module
