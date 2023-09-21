function lt -d 'Alias for ls'
    if test (count $argv) -eq 0
        exa --tree --sort name
    else
        exa --tree $argv
    end
end
