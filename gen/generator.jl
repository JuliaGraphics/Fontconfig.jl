using Clang.Generators
using Fontconfig.Fontconfig_jll  # replace this with your jll package

cd(@__DIR__)

include_dir = normpath(Fontconfig_jll.artifact_dir, "include")
readdir(include_dir)
fontconfig_dir = joinpath(include_dir, "fontconfig")

options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()  # Note you must call this function firstly and then append your own flags
push!(args, "-I$fontconfig_dir")

headers = [joinpath(fontconfig_dir, header) for header in readdir(fontconfig_dir) if endswith(header, ".h")]
# there is also an experimental `detect_headers` function for auto-detecting top-level headers in the directory
headers = detect_headers(fontconfig_dir, args)
# create context
ctx = cd(dirname(fontconfig_dir)) do
    ctx = create_context(headers, args, options)
end

# run generator
build!(ctx)