############################################################
#                     Fontconfig types                     #
############################################################

struct FCMatrix
    xx::Cdouble
    xy::Cdouble 
    yx::Cdouble 
    yy::Cdouble
end

struct FcFontSet
    nfont::Cint
    sfont::Cint
    fonts::Ptr{Ptr{Nothing}}
end
