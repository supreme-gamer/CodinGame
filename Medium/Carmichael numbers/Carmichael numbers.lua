local function isPrime(num)
    if num <= 1 then
        return false
    end
    if num % 2 == 0 and num > 2 then
        return false
    end
    local sqrtNum = math.sqrt(num)
    for i = 3, sqrtNum, 2 do
        if num % i == 0 then
            return false
        end
    end
    return true
end

local function modPow(base, exp, mod)
    local result = 1
    base = base % mod
    while exp > 0 do
        if exp % 2 == 1 then
            result = (result * base) % mod
        end
        base = (base * base) % mod
        exp = math.floor(exp / 2)
    end
    return result
end

local n = tonumber(io.read())

if modPow(2, n, n) == 2 % n and not isPrime(n) then
    print("YES")
else
    print("NO")
end