function ls
    if test (count $argv) -eq 0
        exa --group-directories-first --sort new
    else
        exa --group-directories-first --sort name $argv
    end
end
