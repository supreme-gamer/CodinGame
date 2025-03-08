local function factorize(n)
    local factors = {}
    local divisor = 2
    while n >= divisor do
        while n % divisor == 0 do
            table.insert(factors, divisor)
            n = n / divisor
        end
        divisor = divisor + 1
    end
    return factors
end

local function transform(X, clues)
    local mapping = {}
    for _, clue in ipairs(clues) do
        local A, B = clue[1], clue[2]
        local A_factors = factorize(A)
        local B_factors = factorize(B)
        for i = 1, #A_factors do
            mapping[A_factors[i]] = B_factors[i]
        end
    end

    local X_factors = factorize(X)

    local Y = 1
    for _, prime in ipairs(X_factors) do
        local mapped_prime = mapping[prime]
        if not mapped_prime then
            mapped_prime = prime
        end
        Y = Y * mapped_prime
    end

    return Y
end

local function main()
    local X = tonumber(io.read())
    local C = tonumber(io.read())

    local clues = {}
    for _ = 1, C do
        local A, B = io.read("*n", "*n")
        table.insert(clues, {A, B})
    end

    local Y = transform(X, clues)

    Y = math.floor(Y)

    print(Y)
end

main()