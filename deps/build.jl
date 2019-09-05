using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

# These are the two binary objects we care about
products = [
    LibraryProduct(prefix, ["libfontconfig"], :jl_libfontconfig),
]

dependencies = [
    # Freetype2-related dependencies
    "build_Zlib.v1.2.11.jl",
    "build_Bzip2.v1.0.6.jl",
    "build_FreeType2.v2.10.1.jl",
    # Fontconfig-related dependencies
    "build_Libuuid.v2.34.0.jl",
    "build_Expat.v2.2.7.jl",
    "build_Fontconfig.v2.13.1.jl",
]

for dependency in dependencies
    # On macOS let's use system libuuid
    platform_key_abi() isa MacOS &&
        occursin(r"^build_(Libuuid)", dependency) &&
        continue

    # it's a bit faster to run the build in an anonymous module instead of
    # starting a new julia process

    # Build the dependencies
    Mod = @eval module Anon end
    Mod.include(dependency)
end

# Finally, write out a deps.jl file
write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
