using Fontconfig_jll
export Fontconfig_jll

using CEnum

function FcFreeTypeCharSetAndSpacing(face::Cint, blanks, spacing)
    @ccall fontconfig.FcFreeTypeCharSetAndSpacing(face::Cint, blanks::Ptr{Cint}, spacing::Ptr{Cint})::Ptr{Cint}
end

function FcFreeTypeCharSet(face::Cint, blanks)
    @ccall fontconfig.FcFreeTypeCharSet(face::Cint, blanks::Ptr{Cint})::Ptr{Cint}
end

function FcPatternGetFTFace(p, object, n::Cint, f)
    @ccall fontconfig.FcPatternGetFTFace(p::Ptr{Cint}, object::Cstring, n::Cint, f::Ptr{Cint})::Cint
end

function FcPatternAddFTFace(p, object, f::Cint)
    @ccall fontconfig.FcPatternAddFTFace(p::Ptr{Cint}, object::Cstring, f::Cint)::Cint
end

function FcFreeTypeQueryFace(face::Cint, file, id::Cuint, blanks)
    @ccall fontconfig.FcFreeTypeQueryFace(face::Cint, file::Ptr{Cint}, id::Cuint, blanks::Ptr{Cint})::Ptr{Cint}
end

const _FcPattern = Cvoid

const FcPattern = _FcPattern

@cenum _FcType::Int32 begin
    FcTypeUnknown = -1
    FcTypeVoid = 0
    FcTypeInteger = 1
    FcTypeDouble = 2
    FcTypeString = 3
    FcTypeBool = 4
    FcTypeMatrix = 5
    FcTypeCharSet = 6
    FcTypeFTFace = 7
    FcTypeLangSet = 8
    FcTypeRange = 9
end

const FcType = _FcType

struct var"##Ctag#332"
    data::NTuple{8, UInt8}
end

function Base.getproperty(x::Ptr{var"##Ctag#332"}, f::Symbol)
    f === :s && return Ptr{Ptr{FcChar8}}(x + 0)
    f === :i && return Ptr{Cint}(x + 0)
    f === :b && return Ptr{FcBool}(x + 0)
    f === :d && return Ptr{Cdouble}(x + 0)
    f === :m && return Ptr{Ptr{FcMatrix}}(x + 0)
    f === :c && return Ptr{Ptr{FcCharSet}}(x + 0)
    f === :f && return Ptr{Ptr{Cvoid}}(x + 0)
    f === :l && return Ptr{Ptr{FcLangSet}}(x + 0)
    f === :r && return Ptr{Ptr{FcRange}}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::var"##Ctag#332", f::Symbol)
    r = Ref{var"##Ctag#332"}(x)
    ptr = Base.unsafe_convert(Ptr{var"##Ctag#332"}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{var"##Ctag#332"}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct _FcValue
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{_FcValue}, f::Symbol)
    f === :type && return Ptr{FcType}(x + 0)
    f === :u && return Ptr{var"##Ctag#332"}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::_FcValue, f::Symbol)
    r = Ref{_FcValue}(x)
    ptr = Base.unsafe_convert(Ptr{_FcValue}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_FcValue}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const FcValue = _FcValue

function FcPatternCreate()
    @ccall fontconfig.FcPatternCreate()::Ptr{FcPattern}
end

const FcChar8 = Cuchar

const FcBool = Cint

struct _FcMatrix
    xx::Cdouble
    xy::Cdouble
    yx::Cdouble
    yy::Cdouble
end

const FcMatrix = _FcMatrix

const _FcCharSet = Cvoid

const FcCharSet = _FcCharSet

const _FcLangSet = Cvoid

const FcLangSet = _FcLangSet

const _FcRange = Cvoid

const FcRange = _FcRange

function FcPatternAdd(p, object, value::FcValue, append::FcBool)
    @ccall fontconfig.FcPatternAdd(p::Ptr{FcPattern}, object::Cstring, value::FcValue, append::FcBool)::FcBool
end

function FcPatternDestroy(p)
    @ccall fontconfig.FcPatternDestroy(p::Ptr{FcPattern})::Cvoid
end

struct _FcObjectSet
    nobject::Cint
    sobject::Cint
    objects::Ptr{Cstring}
end

const FcObjectSet = _FcObjectSet

function FcObjectSetCreate()
    @ccall fontconfig.FcObjectSetCreate()::Ptr{FcObjectSet}
end

function FcObjectSetAdd(os, object)
    @ccall fontconfig.FcObjectSetAdd(os::Ptr{FcObjectSet}, object::Cstring)::FcBool
end

function FcObjectSetDestroy(os)
    @ccall fontconfig.FcObjectSetDestroy(os::Ptr{FcObjectSet})::Cvoid
end

const FcChar32 = Cuint

const FcChar16 = Cushort

struct _FcObjectType
    object::Cstring
    type::FcType
end

const FcObjectType = _FcObjectType

struct _FcConstant
    name::Ptr{FcChar8}
    object::Cstring
    value::Cint
end

const FcConstant = _FcConstant

@cenum _FcResult::UInt32 begin
    FcResultMatch = 0
    FcResultNoMatch = 1
    FcResultTypeMismatch = 2
    FcResultNoId = 3
    FcResultOutOfMemory = 4
end

const FcResult = _FcResult

@cenum _FcValueBinding::UInt32 begin
    FcValueBindingWeak = 0
    FcValueBindingStrong = 1
    FcValueBindingSame = 2
    FcValueBindingEnd = 2147483647
end

const FcValueBinding = _FcValueBinding

struct _FcPatternIter
    dummy1::Ptr{Cvoid}
    dummy2::Ptr{Cvoid}
end

const FcPatternIter = _FcPatternIter

struct _FcFontSet
    nfont::Cint
    sfont::Cint
    fonts::Ptr{Ptr{FcPattern}}
end

const FcFontSet = _FcFontSet

@cenum _FcMatchKind::UInt32 begin
    FcMatchPattern = 0
    FcMatchFont = 1
    FcMatchScan = 2
    FcMatchKindEnd = 3
    FcMatchKindBegin = 0
end

const FcMatchKind = _FcMatchKind

@cenum _FcLangResult::UInt32 begin
    FcLangEqual = 0
    FcLangDifferentCountry = 1
    FcLangDifferentTerritory = 1
    FcLangDifferentLang = 2
end

const FcLangResult = _FcLangResult

@cenum _FcSetName::UInt32 begin
    FcSetSystem = 0
    FcSetApplication = 1
end

const FcSetName = _FcSetName

struct _FcConfigFileInfoIter
    dummy1::Ptr{Cvoid}
    dummy2::Ptr{Cvoid}
    dummy3::Ptr{Cvoid}
end

const FcConfigFileInfoIter = _FcConfigFileInfoIter

const _FcAtomic = Cvoid

const FcAtomic = _FcAtomic

@cenum FcEndian::UInt32 begin
    FcEndianBig = 0
    FcEndianLittle = 1
end

const _FcConfig = Cvoid

const FcConfig = _FcConfig

const _FcGlobalCache = Cvoid

const FcFileCache = _FcGlobalCache

const _FcBlanks = Cvoid

const FcBlanks = _FcBlanks

const _FcStrList = Cvoid

const FcStrList = _FcStrList

const _FcStrSet = Cvoid

const FcStrSet = _FcStrSet

const _FcCache = Cvoid

const FcCache = _FcCache

function FcBlanksCreate()
    @ccall fontconfig.FcBlanksCreate()::Ptr{FcBlanks}
end

function FcBlanksDestroy(b)
    @ccall fontconfig.FcBlanksDestroy(b::Ptr{FcBlanks})::Cvoid
end

function FcBlanksAdd(b, ucs4::FcChar32)
    @ccall fontconfig.FcBlanksAdd(b::Ptr{FcBlanks}, ucs4::FcChar32)::FcBool
end

function FcBlanksIsMember(b, ucs4::FcChar32)
    @ccall fontconfig.FcBlanksIsMember(b::Ptr{FcBlanks}, ucs4::FcChar32)::FcBool
end

function FcCacheDir(c)
    @ccall fontconfig.FcCacheDir(c::Ptr{FcCache})::Ptr{FcChar8}
end

function FcCacheCopySet(c)
    @ccall fontconfig.FcCacheCopySet(c::Ptr{FcCache})::Ptr{FcFontSet}
end

function FcCacheSubdir(c, i::Cint)
    @ccall fontconfig.FcCacheSubdir(c::Ptr{FcCache}, i::Cint)::Ptr{FcChar8}
end

function FcCacheNumSubdir(c)
    @ccall fontconfig.FcCacheNumSubdir(c::Ptr{FcCache})::Cint
end

function FcCacheNumFont(c)
    @ccall fontconfig.FcCacheNumFont(c::Ptr{FcCache})::Cint
end

function FcDirCacheUnlink(dir, config)
    @ccall fontconfig.FcDirCacheUnlink(dir::Ptr{FcChar8}, config::Ptr{FcConfig})::FcBool
end

function FcDirCacheValid(cache_file)
    @ccall fontconfig.FcDirCacheValid(cache_file::Ptr{FcChar8})::FcBool
end

function FcDirCacheClean(cache_dir, verbose::FcBool)
    @ccall fontconfig.FcDirCacheClean(cache_dir::Ptr{FcChar8}, verbose::FcBool)::FcBool
end

function FcCacheCreateTagFile(config)
    @ccall fontconfig.FcCacheCreateTagFile(config::Ptr{FcConfig})::Cvoid
end

function FcDirCacheCreateUUID(dir, force::FcBool, config)
    @ccall fontconfig.FcDirCacheCreateUUID(dir::Ptr{FcChar8}, force::FcBool, config::Ptr{FcConfig})::FcBool
end

function FcDirCacheDeleteUUID(dir, config)
    @ccall fontconfig.FcDirCacheDeleteUUID(dir::Ptr{FcChar8}, config::Ptr{FcConfig})::FcBool
end

function FcConfigHome()
    @ccall fontconfig.FcConfigHome()::Ptr{FcChar8}
end

function FcConfigEnableHome(enable::FcBool)
    @ccall fontconfig.FcConfigEnableHome(enable::FcBool)::FcBool
end

function FcConfigGetFilename(config, url)
    @ccall fontconfig.FcConfigGetFilename(config::Ptr{FcConfig}, url::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcConfigFilename(url)
    @ccall fontconfig.FcConfigFilename(url::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcConfigCreate()
    @ccall fontconfig.FcConfigCreate()::Ptr{FcConfig}
end

function FcConfigReference(config)
    @ccall fontconfig.FcConfigReference(config::Ptr{FcConfig})::Ptr{FcConfig}
end

function FcConfigDestroy(config)
    @ccall fontconfig.FcConfigDestroy(config::Ptr{FcConfig})::Cvoid
end

function FcConfigSetCurrent(config)
    @ccall fontconfig.FcConfigSetCurrent(config::Ptr{FcConfig})::FcBool
end

function FcConfigGetCurrent()
    @ccall fontconfig.FcConfigGetCurrent()::Ptr{FcConfig}
end

function FcConfigUptoDate(config)
    @ccall fontconfig.FcConfigUptoDate(config::Ptr{FcConfig})::FcBool
end

function FcConfigBuildFonts(config)
    @ccall fontconfig.FcConfigBuildFonts(config::Ptr{FcConfig})::FcBool
end

function FcConfigGetFontDirs(config)
    @ccall fontconfig.FcConfigGetFontDirs(config::Ptr{FcConfig})::Ptr{FcStrList}
end

function FcConfigGetConfigDirs(config)
    @ccall fontconfig.FcConfigGetConfigDirs(config::Ptr{FcConfig})::Ptr{FcStrList}
end

function FcConfigGetConfigFiles(config)
    @ccall fontconfig.FcConfigGetConfigFiles(config::Ptr{FcConfig})::Ptr{FcStrList}
end

function FcConfigGetCache(config)
    @ccall fontconfig.FcConfigGetCache(config::Ptr{FcConfig})::Ptr{FcChar8}
end

function FcConfigGetBlanks(config)
    @ccall fontconfig.FcConfigGetBlanks(config::Ptr{FcConfig})::Ptr{FcBlanks}
end

function FcConfigGetCacheDirs(config)
    @ccall fontconfig.FcConfigGetCacheDirs(config::Ptr{FcConfig})::Ptr{FcStrList}
end

function FcConfigGetRescanInterval(config)
    @ccall fontconfig.FcConfigGetRescanInterval(config::Ptr{FcConfig})::Cint
end

function FcConfigSetRescanInterval(config, rescanInterval::Cint)
    @ccall fontconfig.FcConfigSetRescanInterval(config::Ptr{FcConfig}, rescanInterval::Cint)::FcBool
end

function FcConfigGetFonts(config, set::FcSetName)
    @ccall fontconfig.FcConfigGetFonts(config::Ptr{FcConfig}, set::FcSetName)::Ptr{FcFontSet}
end

function FcConfigAppFontAddFile(config, file)
    @ccall fontconfig.FcConfigAppFontAddFile(config::Ptr{FcConfig}, file::Ptr{FcChar8})::FcBool
end

function FcConfigAppFontAddDir(config, dir)
    @ccall fontconfig.FcConfigAppFontAddDir(config::Ptr{FcConfig}, dir::Ptr{FcChar8})::FcBool
end

function FcConfigAppFontClear(config)
    @ccall fontconfig.FcConfigAppFontClear(config::Ptr{FcConfig})::Cvoid
end

function FcConfigSubstituteWithPat(config, p, p_pat, kind::FcMatchKind)
    @ccall fontconfig.FcConfigSubstituteWithPat(config::Ptr{FcConfig}, p::Ptr{FcPattern}, p_pat::Ptr{FcPattern}, kind::FcMatchKind)::FcBool
end

function FcConfigSubstitute(config, p, kind::FcMatchKind)
    @ccall fontconfig.FcConfigSubstitute(config::Ptr{FcConfig}, p::Ptr{FcPattern}, kind::FcMatchKind)::FcBool
end

function FcConfigGetSysRoot(config)
    @ccall fontconfig.FcConfigGetSysRoot(config::Ptr{FcConfig})::Ptr{FcChar8}
end

function FcConfigSetSysRoot(config, sysroot)
    @ccall fontconfig.FcConfigSetSysRoot(config::Ptr{FcConfig}, sysroot::Ptr{FcChar8})::Cvoid
end

function FcConfigFileInfoIterInit(config, iter)
    @ccall fontconfig.FcConfigFileInfoIterInit(config::Ptr{FcConfig}, iter::Ptr{FcConfigFileInfoIter})::Cvoid
end

function FcConfigFileInfoIterNext(config, iter)
    @ccall fontconfig.FcConfigFileInfoIterNext(config::Ptr{FcConfig}, iter::Ptr{FcConfigFileInfoIter})::FcBool
end

function FcConfigFileInfoIterGet(config, iter, name, description, enabled)
    @ccall fontconfig.FcConfigFileInfoIterGet(config::Ptr{FcConfig}, iter::Ptr{FcConfigFileInfoIter}, name::Ptr{Ptr{FcChar8}}, description::Ptr{Ptr{FcChar8}}, enabled::Ptr{FcBool})::FcBool
end

function FcCharSetCreate()
    @ccall fontconfig.FcCharSetCreate()::Ptr{FcCharSet}
end

function FcCharSetNew()
    @ccall fontconfig.FcCharSetNew()::Ptr{FcCharSet}
end

function FcCharSetDestroy(fcs)
    @ccall fontconfig.FcCharSetDestroy(fcs::Ptr{FcCharSet})::Cvoid
end

function FcCharSetAddChar(fcs, ucs4::FcChar32)
    @ccall fontconfig.FcCharSetAddChar(fcs::Ptr{FcCharSet}, ucs4::FcChar32)::FcBool
end

function FcCharSetDelChar(fcs, ucs4::FcChar32)
    @ccall fontconfig.FcCharSetDelChar(fcs::Ptr{FcCharSet}, ucs4::FcChar32)::FcBool
end

function FcCharSetCopy(src)
    @ccall fontconfig.FcCharSetCopy(src::Ptr{FcCharSet})::Ptr{FcCharSet}
end

function FcCharSetEqual(a, b)
    @ccall fontconfig.FcCharSetEqual(a::Ptr{FcCharSet}, b::Ptr{FcCharSet})::FcBool
end

function FcCharSetIntersect(a, b)
    @ccall fontconfig.FcCharSetIntersect(a::Ptr{FcCharSet}, b::Ptr{FcCharSet})::Ptr{FcCharSet}
end

function FcCharSetUnion(a, b)
    @ccall fontconfig.FcCharSetUnion(a::Ptr{FcCharSet}, b::Ptr{FcCharSet})::Ptr{FcCharSet}
end

function FcCharSetSubtract(a, b)
    @ccall fontconfig.FcCharSetSubtract(a::Ptr{FcCharSet}, b::Ptr{FcCharSet})::Ptr{FcCharSet}
end

function FcCharSetMerge(a, b, changed)
    @ccall fontconfig.FcCharSetMerge(a::Ptr{FcCharSet}, b::Ptr{FcCharSet}, changed::Ptr{FcBool})::FcBool
end

function FcCharSetHasChar(fcs, ucs4::FcChar32)
    @ccall fontconfig.FcCharSetHasChar(fcs::Ptr{FcCharSet}, ucs4::FcChar32)::FcBool
end

function FcCharSetCount(a)
    @ccall fontconfig.FcCharSetCount(a::Ptr{FcCharSet})::FcChar32
end

function FcCharSetIntersectCount(a, b)
    @ccall fontconfig.FcCharSetIntersectCount(a::Ptr{FcCharSet}, b::Ptr{FcCharSet})::FcChar32
end

function FcCharSetSubtractCount(a, b)
    @ccall fontconfig.FcCharSetSubtractCount(a::Ptr{FcCharSet}, b::Ptr{FcCharSet})::FcChar32
end

function FcCharSetIsSubset(a, b)
    @ccall fontconfig.FcCharSetIsSubset(a::Ptr{FcCharSet}, b::Ptr{FcCharSet})::FcBool
end

function FcCharSetFirstPage(a, map, next)
    @ccall fontconfig.FcCharSetFirstPage(a::Ptr{FcCharSet}, map::Ptr{FcChar32}, next::Ptr{FcChar32})::FcChar32
end

function FcCharSetNextPage(a, map, next)
    @ccall fontconfig.FcCharSetNextPage(a::Ptr{FcCharSet}, map::Ptr{FcChar32}, next::Ptr{FcChar32})::FcChar32
end

function FcCharSetCoverage(a, page::FcChar32, result)
    @ccall fontconfig.FcCharSetCoverage(a::Ptr{FcCharSet}, page::FcChar32, result::Ptr{FcChar32})::FcChar32
end

function FcValuePrint(v::FcValue)
    @ccall fontconfig.FcValuePrint(v::FcValue)::Cvoid
end

function FcPatternPrint(p)
    @ccall fontconfig.FcPatternPrint(p::Ptr{FcPattern})::Cvoid
end

function FcFontSetPrint(s)
    @ccall fontconfig.FcFontSetPrint(s::Ptr{FcFontSet})::Cvoid
end

function FcGetDefaultLangs()
    @ccall fontconfig.FcGetDefaultLangs()::Ptr{FcStrSet}
end

function FcDefaultSubstitute(pattern)
    @ccall fontconfig.FcDefaultSubstitute(pattern::Ptr{FcPattern})::Cvoid
end

function FcFileIsDir(file)
    @ccall fontconfig.FcFileIsDir(file::Ptr{FcChar8})::FcBool
end

function FcFileScan(set, dirs, cache, blanks, file, force::FcBool)
    @ccall fontconfig.FcFileScan(set::Ptr{FcFontSet}, dirs::Ptr{FcStrSet}, cache::Ptr{FcFileCache}, blanks::Ptr{FcBlanks}, file::Ptr{FcChar8}, force::FcBool)::FcBool
end

function FcDirScan(set, dirs, cache, blanks, dir, force::FcBool)
    @ccall fontconfig.FcDirScan(set::Ptr{FcFontSet}, dirs::Ptr{FcStrSet}, cache::Ptr{FcFileCache}, blanks::Ptr{FcBlanks}, dir::Ptr{FcChar8}, force::FcBool)::FcBool
end

function FcDirSave(set, dirs, dir)
    @ccall fontconfig.FcDirSave(set::Ptr{FcFontSet}, dirs::Ptr{FcStrSet}, dir::Ptr{FcChar8})::FcBool
end

function FcDirCacheLoad(dir, config, cache_file)
    @ccall fontconfig.FcDirCacheLoad(dir::Ptr{FcChar8}, config::Ptr{FcConfig}, cache_file::Ptr{Ptr{FcChar8}})::Ptr{FcCache}
end

function FcDirCacheRescan(dir, config)
    @ccall fontconfig.FcDirCacheRescan(dir::Ptr{FcChar8}, config::Ptr{FcConfig})::Ptr{FcCache}
end

function FcDirCacheRead(dir, force::FcBool, config)
    @ccall fontconfig.FcDirCacheRead(dir::Ptr{FcChar8}, force::FcBool, config::Ptr{FcConfig})::Ptr{FcCache}
end

function FcDirCacheLoadFile(cache_file, file_stat)
    @ccall fontconfig.FcDirCacheLoadFile(cache_file::Ptr{FcChar8}, file_stat::Ptr{Cvoid})::Ptr{FcCache}
end

function FcDirCacheUnload(cache)
    @ccall fontconfig.FcDirCacheUnload(cache::Ptr{FcCache})::Cvoid
end

function FcFreeTypeQuery(file, id::Cuint, blanks, count)
    @ccall fontconfig.FcFreeTypeQuery(file::Ptr{FcChar8}, id::Cuint, blanks::Ptr{FcBlanks}, count::Ptr{Cint})::Ptr{FcPattern}
end

function FcFreeTypeQueryAll(file, id::Cuint, blanks, count, set)
    @ccall fontconfig.FcFreeTypeQueryAll(file::Ptr{FcChar8}, id::Cuint, blanks::Ptr{FcBlanks}, count::Ptr{Cint}, set::Ptr{FcFontSet})::Cuint
end

function FcFontSetCreate()
    @ccall fontconfig.FcFontSetCreate()::Ptr{FcFontSet}
end

function FcFontSetDestroy(s)
    @ccall fontconfig.FcFontSetDestroy(s::Ptr{FcFontSet})::Cvoid
end

function FcFontSetAdd(s, font)
    @ccall fontconfig.FcFontSetAdd(s::Ptr{FcFontSet}, font::Ptr{FcPattern})::FcBool
end

function FcInitLoadConfig()
    @ccall fontconfig.FcInitLoadConfig()::Ptr{FcConfig}
end

function FcInitLoadConfigAndFonts()
    @ccall fontconfig.FcInitLoadConfigAndFonts()::Ptr{FcConfig}
end

function FcInit()
    @ccall fontconfig.FcInit()::FcBool
end

function FcFini()
    @ccall fontconfig.FcFini()::Cvoid
end

function FcGetVersion()
    @ccall fontconfig.FcGetVersion()::Cint
end

function FcInitReinitialize()
    @ccall fontconfig.FcInitReinitialize()::FcBool
end

function FcInitBringUptoDate()
    @ccall fontconfig.FcInitBringUptoDate()::FcBool
end

function FcGetLangs()
    @ccall fontconfig.FcGetLangs()::Ptr{FcStrSet}
end

function FcLangNormalize(lang)
    @ccall fontconfig.FcLangNormalize(lang::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcLangGetCharSet(lang)
    @ccall fontconfig.FcLangGetCharSet(lang::Ptr{FcChar8})::Ptr{FcCharSet}
end

function FcLangSetCreate()
    @ccall fontconfig.FcLangSetCreate()::Ptr{FcLangSet}
end

function FcLangSetDestroy(ls)
    @ccall fontconfig.FcLangSetDestroy(ls::Ptr{FcLangSet})::Cvoid
end

function FcLangSetCopy(ls)
    @ccall fontconfig.FcLangSetCopy(ls::Ptr{FcLangSet})::Ptr{FcLangSet}
end

function FcLangSetAdd(ls, lang)
    @ccall fontconfig.FcLangSetAdd(ls::Ptr{FcLangSet}, lang::Ptr{FcChar8})::FcBool
end

function FcLangSetDel(ls, lang)
    @ccall fontconfig.FcLangSetDel(ls::Ptr{FcLangSet}, lang::Ptr{FcChar8})::FcBool
end

function FcLangSetHasLang(ls, lang)
    @ccall fontconfig.FcLangSetHasLang(ls::Ptr{FcLangSet}, lang::Ptr{FcChar8})::FcLangResult
end

function FcLangSetCompare(lsa, lsb)
    @ccall fontconfig.FcLangSetCompare(lsa::Ptr{FcLangSet}, lsb::Ptr{FcLangSet})::FcLangResult
end

function FcLangSetContains(lsa, lsb)
    @ccall fontconfig.FcLangSetContains(lsa::Ptr{FcLangSet}, lsb::Ptr{FcLangSet})::FcBool
end

function FcLangSetEqual(lsa, lsb)
    @ccall fontconfig.FcLangSetEqual(lsa::Ptr{FcLangSet}, lsb::Ptr{FcLangSet})::FcBool
end

function FcLangSetHash(ls)
    @ccall fontconfig.FcLangSetHash(ls::Ptr{FcLangSet})::FcChar32
end

function FcLangSetGetLangs(ls)
    @ccall fontconfig.FcLangSetGetLangs(ls::Ptr{FcLangSet})::Ptr{FcStrSet}
end

function FcLangSetUnion(a, b)
    @ccall fontconfig.FcLangSetUnion(a::Ptr{FcLangSet}, b::Ptr{FcLangSet})::Ptr{FcLangSet}
end

function FcLangSetSubtract(a, b)
    @ccall fontconfig.FcLangSetSubtract(a::Ptr{FcLangSet}, b::Ptr{FcLangSet})::Ptr{FcLangSet}
end

function FcFontSetList(config, sets, nsets::Cint, p, os)
    @ccall fontconfig.FcFontSetList(config::Ptr{FcConfig}, sets::Ptr{Ptr{FcFontSet}}, nsets::Cint, p::Ptr{FcPattern}, os::Ptr{FcObjectSet})::Ptr{FcFontSet}
end

function FcFontList(config, p, os)
    @ccall fontconfig.FcFontList(config::Ptr{FcConfig}, p::Ptr{FcPattern}, os::Ptr{FcObjectSet})::Ptr{FcFontSet}
end

function FcAtomicCreate(file)
    @ccall fontconfig.FcAtomicCreate(file::Ptr{FcChar8})::Ptr{FcAtomic}
end

function FcAtomicLock(atomic)
    @ccall fontconfig.FcAtomicLock(atomic::Ptr{FcAtomic})::FcBool
end

function FcAtomicNewFile(atomic)
    @ccall fontconfig.FcAtomicNewFile(atomic::Ptr{FcAtomic})::Ptr{FcChar8}
end

function FcAtomicOrigFile(atomic)
    @ccall fontconfig.FcAtomicOrigFile(atomic::Ptr{FcAtomic})::Ptr{FcChar8}
end

function FcAtomicReplaceOrig(atomic)
    @ccall fontconfig.FcAtomicReplaceOrig(atomic::Ptr{FcAtomic})::FcBool
end

function FcAtomicDeleteNew(atomic)
    @ccall fontconfig.FcAtomicDeleteNew(atomic::Ptr{FcAtomic})::Cvoid
end

function FcAtomicUnlock(atomic)
    @ccall fontconfig.FcAtomicUnlock(atomic::Ptr{FcAtomic})::Cvoid
end

function FcAtomicDestroy(atomic)
    @ccall fontconfig.FcAtomicDestroy(atomic::Ptr{FcAtomic})::Cvoid
end

function FcFontSetMatch(config, sets, nsets::Cint, p, result)
    @ccall fontconfig.FcFontSetMatch(config::Ptr{FcConfig}, sets::Ptr{Ptr{FcFontSet}}, nsets::Cint, p::Ptr{FcPattern}, result::Ptr{FcResult})::Ptr{FcPattern}
end

function FcFontMatch(config, p, result)
    @ccall fontconfig.FcFontMatch(config::Ptr{FcConfig}, p::Ptr{FcPattern}, result::Ptr{FcResult})::Ptr{FcPattern}
end

function FcFontRenderPrepare(config, pat, font)
    @ccall fontconfig.FcFontRenderPrepare(config::Ptr{FcConfig}, pat::Ptr{FcPattern}, font::Ptr{FcPattern})::Ptr{FcPattern}
end

function FcFontSetSort(config, sets, nsets::Cint, p, trim::FcBool, csp, result)
    @ccall fontconfig.FcFontSetSort(config::Ptr{FcConfig}, sets::Ptr{Ptr{FcFontSet}}, nsets::Cint, p::Ptr{FcPattern}, trim::FcBool, csp::Ptr{Ptr{FcCharSet}}, result::Ptr{FcResult})::Ptr{FcFontSet}
end

function FcFontSort(config, p, trim::FcBool, csp, result)
    @ccall fontconfig.FcFontSort(config::Ptr{FcConfig}, p::Ptr{FcPattern}, trim::FcBool, csp::Ptr{Ptr{FcCharSet}}, result::Ptr{FcResult})::Ptr{FcFontSet}
end

function FcFontSetSortDestroy(fs)
    @ccall fontconfig.FcFontSetSortDestroy(fs::Ptr{FcFontSet})::Cvoid
end

function FcMatrixCopy(mat)
    @ccall fontconfig.FcMatrixCopy(mat::Ptr{FcMatrix})::Ptr{FcMatrix}
end

function FcMatrixEqual(mat1, mat2)
    @ccall fontconfig.FcMatrixEqual(mat1::Ptr{FcMatrix}, mat2::Ptr{FcMatrix})::FcBool
end

function FcMatrixMultiply(result, a, b)
    @ccall fontconfig.FcMatrixMultiply(result::Ptr{FcMatrix}, a::Ptr{FcMatrix}, b::Ptr{FcMatrix})::Cvoid
end

function FcMatrixRotate(m, c::Cdouble, s::Cdouble)
    @ccall fontconfig.FcMatrixRotate(m::Ptr{FcMatrix}, c::Cdouble, s::Cdouble)::Cvoid
end

function FcMatrixScale(m, sx::Cdouble, sy::Cdouble)
    @ccall fontconfig.FcMatrixScale(m::Ptr{FcMatrix}, sx::Cdouble, sy::Cdouble)::Cvoid
end

function FcMatrixShear(m, sh::Cdouble, sv::Cdouble)
    @ccall fontconfig.FcMatrixShear(m::Ptr{FcMatrix}, sh::Cdouble, sv::Cdouble)::Cvoid
end

function FcNameRegisterObjectTypes(types, ntype::Cint)
    @ccall fontconfig.FcNameRegisterObjectTypes(types::Ptr{FcObjectType}, ntype::Cint)::FcBool
end

function FcNameUnregisterObjectTypes(types, ntype::Cint)
    @ccall fontconfig.FcNameUnregisterObjectTypes(types::Ptr{FcObjectType}, ntype::Cint)::FcBool
end

function FcNameGetObjectType(object)
    @ccall fontconfig.FcNameGetObjectType(object::Cstring)::Ptr{FcObjectType}
end

function FcNameRegisterConstants(consts, nconsts::Cint)
    @ccall fontconfig.FcNameRegisterConstants(consts::Ptr{FcConstant}, nconsts::Cint)::FcBool
end

function FcNameUnregisterConstants(consts, nconsts::Cint)
    @ccall fontconfig.FcNameUnregisterConstants(consts::Ptr{FcConstant}, nconsts::Cint)::FcBool
end

function FcNameGetConstant(string)
    @ccall fontconfig.FcNameGetConstant(string::Ptr{FcChar8})::Ptr{FcConstant}
end

function FcNameConstant(string, result)
    @ccall fontconfig.FcNameConstant(string::Ptr{FcChar8}, result::Ptr{Cint})::FcBool
end

function FcNameParse(name)
    @ccall fontconfig.FcNameParse(name::Ptr{FcChar8})::Ptr{FcPattern}
end

function FcNameUnparse(pat)
    @ccall fontconfig.FcNameUnparse(pat::Ptr{FcPattern})::Ptr{FcChar8}
end

function FcPatternDuplicate(p)
    @ccall fontconfig.FcPatternDuplicate(p::Ptr{FcPattern})::Ptr{FcPattern}
end

function FcPatternReference(p)
    @ccall fontconfig.FcPatternReference(p::Ptr{FcPattern})::Cvoid
end

function FcPatternFilter(p, os)
    @ccall fontconfig.FcPatternFilter(p::Ptr{FcPattern}, os::Ptr{FcObjectSet})::Ptr{FcPattern}
end

function FcValueDestroy(v::FcValue)
    @ccall fontconfig.FcValueDestroy(v::FcValue)::Cvoid
end

function FcValueEqual(va::FcValue, vb::FcValue)
    @ccall fontconfig.FcValueEqual(va::FcValue, vb::FcValue)::FcBool
end

function FcValueSave(v::FcValue)
    @ccall fontconfig.FcValueSave(v::FcValue)::FcValue
end

function FcPatternObjectCount(pat)
    @ccall fontconfig.FcPatternObjectCount(pat::Ptr{FcPattern})::Cint
end

function FcPatternEqual(pa, pb)
    @ccall fontconfig.FcPatternEqual(pa::Ptr{FcPattern}, pb::Ptr{FcPattern})::FcBool
end

function FcPatternEqualSubset(pa, pb, os)
    @ccall fontconfig.FcPatternEqualSubset(pa::Ptr{FcPattern}, pb::Ptr{FcPattern}, os::Ptr{FcObjectSet})::FcBool
end

function FcPatternHash(p)
    @ccall fontconfig.FcPatternHash(p::Ptr{FcPattern})::FcChar32
end

function FcPatternAddWeak(p, object, value::FcValue, append::FcBool)
    @ccall fontconfig.FcPatternAddWeak(p::Ptr{FcPattern}, object::Cstring, value::FcValue, append::FcBool)::FcBool
end

function FcPatternGet(p, object, id::Cint, v)
    @ccall fontconfig.FcPatternGet(p::Ptr{FcPattern}, object::Cstring, id::Cint, v::Ptr{FcValue})::FcResult
end

function FcPatternGetWithBinding(p, object, id::Cint, v, b)
    @ccall fontconfig.FcPatternGetWithBinding(p::Ptr{FcPattern}, object::Cstring, id::Cint, v::Ptr{FcValue}, b::Ptr{FcValueBinding})::FcResult
end

function FcPatternDel(p, object)
    @ccall fontconfig.FcPatternDel(p::Ptr{FcPattern}, object::Cstring)::FcBool
end

function FcPatternRemove(p, object, id::Cint)
    @ccall fontconfig.FcPatternRemove(p::Ptr{FcPattern}, object::Cstring, id::Cint)::FcBool
end

function FcPatternAddInteger(p, object, i::Cint)
    @ccall fontconfig.FcPatternAddInteger(p::Ptr{FcPattern}, object::Cstring, i::Cint)::FcBool
end

function FcPatternAddDouble(p, object, d::Cdouble)
    @ccall fontconfig.FcPatternAddDouble(p::Ptr{FcPattern}, object::Cstring, d::Cdouble)::FcBool
end

function FcPatternAddString(p, object, s)
    @ccall fontconfig.FcPatternAddString(p::Ptr{FcPattern}, object::Cstring, s::Ptr{FcChar8})::FcBool
end

function FcPatternAddMatrix(p, object, s)
    @ccall fontconfig.FcPatternAddMatrix(p::Ptr{FcPattern}, object::Cstring, s::Ptr{FcMatrix})::FcBool
end

function FcPatternAddCharSet(p, object, c)
    @ccall fontconfig.FcPatternAddCharSet(p::Ptr{FcPattern}, object::Cstring, c::Ptr{FcCharSet})::FcBool
end

function FcPatternAddBool(p, object, b::FcBool)
    @ccall fontconfig.FcPatternAddBool(p::Ptr{FcPattern}, object::Cstring, b::FcBool)::FcBool
end

function FcPatternAddLangSet(p, object, ls)
    @ccall fontconfig.FcPatternAddLangSet(p::Ptr{FcPattern}, object::Cstring, ls::Ptr{FcLangSet})::FcBool
end

function FcPatternAddRange(p, object, r)
    @ccall fontconfig.FcPatternAddRange(p::Ptr{FcPattern}, object::Cstring, r::Ptr{FcRange})::FcBool
end

function FcPatternGetInteger(p, object, n::Cint, i)
    @ccall fontconfig.FcPatternGetInteger(p::Ptr{FcPattern}, object::Cstring, n::Cint, i::Ptr{Cint})::FcResult
end

function FcPatternGetDouble(p, object, n::Cint, d)
    @ccall fontconfig.FcPatternGetDouble(p::Ptr{FcPattern}, object::Cstring, n::Cint, d::Ptr{Cdouble})::FcResult
end

function FcPatternGetString(p, object, n::Cint, s)
    @ccall fontconfig.FcPatternGetString(p::Ptr{FcPattern}, object::Cstring, n::Cint, s::Ptr{Ptr{FcChar8}})::FcResult
end

function FcPatternGetMatrix(p, object, n::Cint, s)
    @ccall fontconfig.FcPatternGetMatrix(p::Ptr{FcPattern}, object::Cstring, n::Cint, s::Ptr{Ptr{FcMatrix}})::FcResult
end

function FcPatternGetCharSet(p, object, n::Cint, c)
    @ccall fontconfig.FcPatternGetCharSet(p::Ptr{FcPattern}, object::Cstring, n::Cint, c::Ptr{Ptr{FcCharSet}})::FcResult
end

function FcPatternGetBool(p, object, n::Cint, b)
    @ccall fontconfig.FcPatternGetBool(p::Ptr{FcPattern}, object::Cstring, n::Cint, b::Ptr{FcBool})::FcResult
end

function FcPatternGetLangSet(p, object, n::Cint, ls)
    @ccall fontconfig.FcPatternGetLangSet(p::Ptr{FcPattern}, object::Cstring, n::Cint, ls::Ptr{Ptr{FcLangSet}})::FcResult
end

function FcPatternGetRange(p, object, id::Cint, r)
    @ccall fontconfig.FcPatternGetRange(p::Ptr{FcPattern}, object::Cstring, id::Cint, r::Ptr{Ptr{FcRange}})::FcResult
end

function FcPatternFormat(pat, format)
    @ccall fontconfig.FcPatternFormat(pat::Ptr{FcPattern}, format::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcRangeCreateDouble(_begin::Cdouble, _end::Cdouble)
    @ccall fontconfig.FcRangeCreateDouble(_begin::Cdouble, _end::Cdouble)::Ptr{FcRange}
end

function FcRangeCreateInteger(_begin::FcChar32, _end::FcChar32)
    @ccall fontconfig.FcRangeCreateInteger(_begin::FcChar32, _end::FcChar32)::Ptr{FcRange}
end

function FcRangeDestroy(range)
    @ccall fontconfig.FcRangeDestroy(range::Ptr{FcRange})::Cvoid
end

function FcRangeCopy(r)
    @ccall fontconfig.FcRangeCopy(r::Ptr{FcRange})::Ptr{FcRange}
end

function FcRangeGetDouble(range, _begin, _end)
    @ccall fontconfig.FcRangeGetDouble(range::Ptr{FcRange}, _begin::Ptr{Cdouble}, _end::Ptr{Cdouble})::FcBool
end

function FcPatternIterStart(pat, iter)
    @ccall fontconfig.FcPatternIterStart(pat::Ptr{FcPattern}, iter::Ptr{FcPatternIter})::Cvoid
end

function FcPatternIterNext(pat, iter)
    @ccall fontconfig.FcPatternIterNext(pat::Ptr{FcPattern}, iter::Ptr{FcPatternIter})::FcBool
end

function FcPatternIterEqual(p1, i1, p2, i2)
    @ccall fontconfig.FcPatternIterEqual(p1::Ptr{FcPattern}, i1::Ptr{FcPatternIter}, p2::Ptr{FcPattern}, i2::Ptr{FcPatternIter})::FcBool
end

function FcPatternFindIter(pat, iter, object)
    @ccall fontconfig.FcPatternFindIter(pat::Ptr{FcPattern}, iter::Ptr{FcPatternIter}, object::Cstring)::FcBool
end

function FcPatternIterIsValid(pat, iter)
    @ccall fontconfig.FcPatternIterIsValid(pat::Ptr{FcPattern}, iter::Ptr{FcPatternIter})::FcBool
end

function FcPatternIterGetObject(pat, iter)
    @ccall fontconfig.FcPatternIterGetObject(pat::Ptr{FcPattern}, iter::Ptr{FcPatternIter})::Cstring
end

function FcPatternIterValueCount(pat, iter)
    @ccall fontconfig.FcPatternIterValueCount(pat::Ptr{FcPattern}, iter::Ptr{FcPatternIter})::Cint
end

function FcPatternIterGetValue(pat, iter, id::Cint, v, b)
    @ccall fontconfig.FcPatternIterGetValue(pat::Ptr{FcPattern}, iter::Ptr{FcPatternIter}, id::Cint, v::Ptr{FcValue}, b::Ptr{FcValueBinding})::FcResult
end

function FcWeightFromOpenType(ot_weight::Cint)
    @ccall fontconfig.FcWeightFromOpenType(ot_weight::Cint)::Cint
end

function FcWeightFromOpenTypeDouble(ot_weight::Cdouble)
    @ccall fontconfig.FcWeightFromOpenTypeDouble(ot_weight::Cdouble)::Cdouble
end

function FcWeightToOpenType(fc_weight::Cint)
    @ccall fontconfig.FcWeightToOpenType(fc_weight::Cint)::Cint
end

function FcWeightToOpenTypeDouble(fc_weight::Cdouble)
    @ccall fontconfig.FcWeightToOpenTypeDouble(fc_weight::Cdouble)::Cdouble
end

function FcStrCopy(s)
    @ccall fontconfig.FcStrCopy(s::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcStrCopyFilename(s)
    @ccall fontconfig.FcStrCopyFilename(s::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcStrPlus(s1, s2)
    @ccall fontconfig.FcStrPlus(s1::Ptr{FcChar8}, s2::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcStrFree(s)
    @ccall fontconfig.FcStrFree(s::Ptr{FcChar8})::Cvoid
end

function FcStrDowncase(s)
    @ccall fontconfig.FcStrDowncase(s::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcStrCmpIgnoreCase(s1, s2)
    @ccall fontconfig.FcStrCmpIgnoreCase(s1::Ptr{FcChar8}, s2::Ptr{FcChar8})::Cint
end

function FcStrCmp(s1, s2)
    @ccall fontconfig.FcStrCmp(s1::Ptr{FcChar8}, s2::Ptr{FcChar8})::Cint
end

function FcStrStrIgnoreCase(s1, s2)
    @ccall fontconfig.FcStrStrIgnoreCase(s1::Ptr{FcChar8}, s2::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcStrStr(s1, s2)
    @ccall fontconfig.FcStrStr(s1::Ptr{FcChar8}, s2::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcUtf8ToUcs4(src_orig, dst, len::Cint)
    @ccall fontconfig.FcUtf8ToUcs4(src_orig::Ptr{FcChar8}, dst::Ptr{FcChar32}, len::Cint)::Cint
end

function FcUtf8Len(string, len::Cint, nchar, wchar)
    @ccall fontconfig.FcUtf8Len(string::Ptr{FcChar8}, len::Cint, nchar::Ptr{Cint}, wchar::Ptr{Cint})::FcBool
end

function FcUcs4ToUtf8(ucs4::FcChar32, dest)
    @ccall fontconfig.FcUcs4ToUtf8(ucs4::FcChar32, dest::Ptr{FcChar8})::Cint
end

function FcUtf16ToUcs4(src_orig, endian::FcEndian, dst, len::Cint)
    @ccall fontconfig.FcUtf16ToUcs4(src_orig::Ptr{FcChar8}, endian::FcEndian, dst::Ptr{FcChar32}, len::Cint)::Cint
end

function FcUtf16Len(string, endian::FcEndian, len::Cint, nchar, wchar)
    @ccall fontconfig.FcUtf16Len(string::Ptr{FcChar8}, endian::FcEndian, len::Cint, nchar::Ptr{Cint}, wchar::Ptr{Cint})::FcBool
end

function FcStrDirname(file)
    @ccall fontconfig.FcStrDirname(file::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcStrBasename(file)
    @ccall fontconfig.FcStrBasename(file::Ptr{FcChar8})::Ptr{FcChar8}
end

function FcStrSetCreate()
    @ccall fontconfig.FcStrSetCreate()::Ptr{FcStrSet}
end

function FcStrSetMember(set, s)
    @ccall fontconfig.FcStrSetMember(set::Ptr{FcStrSet}, s::Ptr{FcChar8})::FcBool
end

function FcStrSetEqual(sa, sb)
    @ccall fontconfig.FcStrSetEqual(sa::Ptr{FcStrSet}, sb::Ptr{FcStrSet})::FcBool
end

function FcStrSetAdd(set, s)
    @ccall fontconfig.FcStrSetAdd(set::Ptr{FcStrSet}, s::Ptr{FcChar8})::FcBool
end

function FcStrSetAddFilename(set, s)
    @ccall fontconfig.FcStrSetAddFilename(set::Ptr{FcStrSet}, s::Ptr{FcChar8})::FcBool
end

function FcStrSetDel(set, s)
    @ccall fontconfig.FcStrSetDel(set::Ptr{FcStrSet}, s::Ptr{FcChar8})::FcBool
end

function FcStrSetDestroy(set)
    @ccall fontconfig.FcStrSetDestroy(set::Ptr{FcStrSet})::Cvoid
end

function FcStrListCreate(set)
    @ccall fontconfig.FcStrListCreate(set::Ptr{FcStrSet})::Ptr{FcStrList}
end

function FcStrListFirst(list)
    @ccall fontconfig.FcStrListFirst(list::Ptr{FcStrList})::Cvoid
end

function FcStrListNext(list)
    @ccall fontconfig.FcStrListNext(list::Ptr{FcStrList})::Ptr{FcChar8}
end

function FcStrListDone(list)
    @ccall fontconfig.FcStrListDone(list::Ptr{FcStrList})::Cvoid
end

function FcConfigParseAndLoad(config, file, complain::FcBool)
    @ccall fontconfig.FcConfigParseAndLoad(config::Ptr{FcConfig}, file::Ptr{FcChar8}, complain::FcBool)::FcBool
end

function FcConfigParseAndLoadFromMemory(config, buffer, complain::FcBool)
    @ccall fontconfig.FcConfigParseAndLoadFromMemory(config::Ptr{FcConfig}, buffer::Ptr{FcChar8}, complain::FcBool)::FcBool
end

