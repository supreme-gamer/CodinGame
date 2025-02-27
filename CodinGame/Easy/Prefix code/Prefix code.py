def read_prefix_codes(n: int) -> dict:
    prefix_codes = {}
    for _ in range(n):
        code, ascii_value = input().split()
        prefix_codes[code] = chr(int(ascii_value))
    return prefix_codes

def decode_string(encoded_string: str, prefix_codes: dict) -> str:
    decoded_string = ""
    i = 0

    while i < len(encoded_string):
        found = False
        
        for code, char in prefix_codes.items():
            code_length = len(code)
            
            if encoded_string[i:i + code_length] == code:
                decoded_string += char
                i += code_length
                found = True
                break
        
        if not found:
            return f"DECODE FAIL AT INDEX {i}"

    return decoded_string

def main():
    n = int(input())
    prefix_codes = read_prefix_codes(n)
    encoded_string = input().strip()
    result = decode_string(encoded_string, prefix_codes)
    
    print(result)

if __name__ == "__main__":
    main()