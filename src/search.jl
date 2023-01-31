
to_string_style(sym::Symbol) = replace(string(sym), "_" => " ")
to_string_style(str::String) = str

# basically a lookup table for known fallbacks
function _known_style_fallbacks(s::String)
    if s == "regular"
        return ("roman", "book", "sans", "serif")
    elseif s == "italic"
        return ("oblique", "slanted")
    elseif s == "bold"
        return ("demibold", "semibold", "heavy")
    elseif s == "bold italic" || s == "bold_italic"
        return ("bold oblique", "demibold italic", "demibold oblique", "semibold italic", "semibold oblique", "heavy italic", "heavy oblique")
    end
    return ()
end

_known_style_fallbacks(s::Symbol) = _known_style_fallbacks(string(s))




############################################################
#                Fontconfig-powered search                 #
############################################################

# This performs a search using Fontconfig and loads the result
# as a Makie-compatible NamedTuple.

function _font_list_and_styles(family::String; additional_params_for_fontconfig...)
    pattern = Fontconfig.Pattern(; family = family, additional_params_for_fontconfig...)
    # Use Fontconfig to generate a list of styles from that pattern.
    font_list = Fontconfig.list(pattern, ["family", "style", "file", "index"])
    # Extract the style names (regular, light, bold, oblique, etc)
    styles = extract_fc_attr.(font_list, "style")
    return (font_list, styles)
end

"""
    populate_font_family(family::String; additional_params_for_fontconfig...)

Returns a NamedTuple of styles and loaded FreeType fonts available for family names.
This returns a NamedTuple with symbolic keys and `FreeTypeAbstraction.FTFont` values.
!!! danger
    Style keys can and do vary across font families; make sure that you normalize them!
"""
function populate_font_family(family::String; additional_params_for_fontconfig...)
    font_list, styles = _font_list_and_styles(family; additional_params_for_fontconfig...)
    # Return a NamedTuple
    return (; (Symbol.(lowercase.(styles)) .=> (font_list))...)
end

"""
    search_with_fallbacks(family::String, style::String, [key::String = style, fallbacks::String...]; params_for_fontconfig...)

Searches for a font defined by `family` and `style` using Fontconfig.  If no such font is found, replaces `key` in `style`
with one of `fallbacks`, and tries again, iterating through `fallbacks`.  Returns a `Pair{NativeFont, String}` representing 
the font and returned style.

If nothing was found, returns `nothing => nothing`.
"""
function search_with_fallbacks(family::String, style::String, key::String = style, fallbacks::String...; params_for_fontconfig...)
    # try the original search first
    font_list, styles = _font_list_and_styles(family; style = lowercase(style), params_for_fontconfig...)

    # return the corresponding style if found
    if length(styles) != 0
        return Symbol(styles[1]) => ftfont_from_fc_pattern(font_list[1])
    # if not, go to fallbacks
    else
        # loop through fallbacks and keep trying
        for fallback in fallbacks
            new_style = string(chomp(replace(style, key => fallback)))
            font_list, styles = _font_list_and_styles(family; style = lowercase(new_style), params_for_fontconfig...)
            if length(styles) != 0
                return Symbol(styles[1]) => font_list[1]
            end
        end
    end
    # we didn't find anything, so return nothing
    return nothing => nothing
end
