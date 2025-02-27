local function read_list()
    return io.read("*l"):gmatch("%S+")
end

local function read_transitions(num_transitions)
    local transitions = {}

    for _ = 1, num_transitions do
        local from_state, symbol, to_state = io.read("*l"):match("(%S+) (%S+) (%S+)")

        if not transitions[from_state] then
            transitions[from_state] = {}
        end

        transitions[from_state][symbol] = to_state
    end

    return transitions
end

local function is_word_valid(word, start_state, end_states, transitions, alphabet_set)
    local current_state = start_state

    for ch in word:gmatch(".") do
        if not alphabet_set[ch] then
            return false
        end

        if not transitions[current_state] or not transitions[current_state][ch] then
            return false
        end

        current_state = transitions[current_state][ch]
    end

    return end_states[current_state] ~= nil
end

local alphabet = {}
for symbol in read_list() do
    alphabet[symbol] = true
end

local states = {}
for state in read_list() do
    states[state] = true
end

local number_of_transitions = tonumber(io.read("*l"))
local transitions = read_transitions(number_of_transitions)

local start_state = io.read("*l")
local end_states = {}
for state in read_list() do
    end_states[state] = true
end

local number_of_words = tonumber(io.read("*l"))

for _ = 1, number_of_words do
    local word = io.read("*l")
    print(is_word_valid(word, start_state, end_states, transitions, alphabet) and "true" or "false")
end
