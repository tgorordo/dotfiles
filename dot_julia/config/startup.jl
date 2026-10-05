using Pkg: Pkg

atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "error importing OhMyREPL" e
    end

    try
        @eval using Revise
    catch e
        @warn "error importing Revise" e
    end
end
