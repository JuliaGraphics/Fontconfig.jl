
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

# functions to extract Fontconfig attributes from patterns

function extract_fc_attr(pat::Fontconfig.Pattern, attr::String; num::Int = 0)
    sym_attr = Symbol(attr)
    if sym_attr in string_attrs
        return extract_fc_attr(pat, attr, String; num)
    elseif sym_attr in int_attrs
        return extract_fc_attr(pat, attr, Int; num)
    elseif sym_attr in double_attrs
        return extract_fc_attr(pat, attr, Cdouble; num)
    elseif sym_attr in bool_attrs
        return extract_fc_attr(pat, attr, Bool; num)
    else
        @error "Attribute not recognized!"
    end
end

function extract_fc_attr(pat::Fontconfig.Pattern, attr::String, ::Type{String}; num::Int = 0)
    local output_str = Ref(Ptr{Cchar}())
    success = @ccall Fontconfig.Fontconfig_jll.libfontconfig.FcPatternGetString(pat.ptr::Ptr{Cvoid}, attr::Cstring, num::Cint, output_str::Ptr{Ptr{Cchar}})::Cint
    if success != 0
        error("The operation did not succeed!  Fontconfig returned the error code $success when extracting the $(num)th entry of attribute $attr from pattern $pat.")
    end
    return unsafe_string(output_str[])
end

function extract_fc_attr(pat::Fontconfig.Pattern, attr::String, ::Type{Int}; num::Int = 0)
    local output_int = Ref{Cint}()
    success = @ccall Fontconfig.Fontconfig_jll.libfontconfig.FcPatternGetInteger(pat.ptr::Ptr{Cvoid}, attr::Cstring, num::Cint, output_int::Ptr{Cint})::Cint
    if success != 0
        error("The operation did not succeed!  Fontconfig returned the error code $success when extracting the $(num)th entry of attribute $attr from pattern $pat.")
    end
    return output_int[]
end

function extract_fc_attr(pat::Fontconfig.Pattern, attr::String, ::Type{Cdouble}; num::Int = 0)
    local output_double = Ref{Cdouble}()
    success = @ccall Fontconfig.Fontconfig_jll.libfontconfig.FcPatternGetDouble(pat.ptr::Ptr{Cvoid}, attr::Cstring, num::Cint, output_double::Ptr{Cdouble})::Cint
    if success != 0
        error("The operation did not succeed!  Fontconfig returned the error code $success when extracting the $(num)th entry of attribute $attr from pattern $pat.")
    end
    return output_double[]
end

function extract_fc_attr(pat::Fontconfig.Pattern, attr::String, ::Type{Bool}; num::Int = 0)
    local output_bool = Ref{Bool}()
    success = @ccall Fontconfig.Fontconfig_jll.libfontconfig.FcPatternGetBool(pat.ptr::Ptr{Cvoid}, attr::Cstring, num::Cint, output_bool::Ptr{Bool})::Cint
    if success != 0
        error("The operation did not succeed!  Fontconfig returned the error code $success when extracting the $(num)th entry of attribute $attr from pattern $pat.")
    end
    return output_bool[]
end



"""
    list(pat::Pattern=Pattern(), properties = ["family", "style", "file"])::Vector{Pattern}
    
Selects fonts matching `pat` and creates patterns from those fonts. These patterns containing only those 
properties listed in `properties`, and returns a vector of unique such patterns, as a `Vector{Pattern}`.
"""
function list(pat::Pattern=Pattern(), properties = ["family", "style", "file"])
    os = ccall((:FcObjectSetCreate, libfontconfig), Ptr{Nothing}, ())
    for property in properties
        ccall((:FcObjectSetAdd, libfontconfig), Cint, (Ptr{Nothing}, Ptr{UInt8}),
              os, string(property))
    end

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

