# map DataSubset over the tuple instead
function DataSubset(tup::Tuple, indices = 1:nobs(tup))
    length(unique(map(_->nobs(_), tup))) == 1 || throw(DimensionMismatch("all parameters must have the same number of observations"))
    map(data -> DataSubset(data, indices), tup)
end

# map datasubset over the tuple instead
datasubset(tup::Tuple, indices) = map(_ -> datasubset(_, indices), tup)
datasubset(tup::Tuple) = map(_ -> datasubset(_), tup)

# add support for arbitrary tuples
nobs(tup::Tuple) = nobs(tup[1])
getobs(tup::Tuple) = map(_ -> getobs(_), tup)
getobs(tup::Tuple, indices) = map(_ -> getobs(_, indices), tup)

# specialized for empty tuples
nobs(tup::Tuple{}) = 0
getobs(tup::Tuple{}) = ()

# --------------------------------------------------------------------
# call with a tuple for more than one arg

for f in (:eachobs, :shuffled, :infinite_obs)
    @eval function $f(s_1, s_rest...)
        tup = (s_1, s_rest...)
        length(unique(map(a->nobs(a), tup))) == 1 || throw(DimensionMismatch("all parameters must have the same number of observations"))
        $f(tup)
    end
end

for f in (:eachbatch, :batches, :infinite_batches, :kfolds, :leave_one_out)
    @eval function $f(s_1, s_rest...; kw...)
        tup = (s_1, s_rest...)
        length(unique(map(a->nobs(a), tup))) == 1 || throw(DimensionMismatch("all parameters must have the same number of observations"))
        $f(tup; kw...)
    end
end
