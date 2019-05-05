# def rant
# p "Why are bitcoin (cash) developers such a bunch of math nerds?
# We'll never know
# Like seriously, they pick the weirdest stuff
# BCH Codes? One might expect BCH there to mean "bitcoin cash" because that's what we're working with here
# But no, it stands for Bose-Chaudhuri–Hocquenghem Codes
# Which is basically a super complicated way of doing error correction
# seriously, it's like they hate new developers
# Have you read their (bitcoin cash) spec documents? Those things are plagued with unexplained acronyms everywhere"
# end

# def tip
# For all the dumb devs like me, these videos helped me understand (a bit) the whole cyclic code business
# https://www.youtube.com/watch?v=FPmFMUoxsiQ
# end

module Base32
    ALPHABET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l"
    VERSION_BYTE = 0
    BCH_PREFIX = "bitcoincash"
    SEPARATOR = ":"
end

def cashaddr hash_str
    hash_bits = hash_str.size * 8

    puts "HASH SIZE #{hash_bits}"
    version_byte = "00000001".to_i(2)

    payload = []
    addr = ""
    Base32::BCH_PREFIX.each_byte { |byte|
        # Use bitwise and to get the lower 5 bits from each character in the prefix, as specified in the spec
        # b = 0110 0010
        # 31= 0001 1111
        # b AND(&) 31 = 0000 0010
        payload << (byte & 31)
    }

    # Separator zero
    payload << 0

    payload_bytes = [version_byte]+hash_str.bytes
    
    payload_chunked = to_5bit_arr payload_bytes

    payload += payload_chunked

    payload += [0] * 8 # 8 zeroes, for some reason

    checksum = poly_mod payload

    checksum_grouped = checksum.to_s(2).rjust(40, "0").scan(/.{1,5}/)

    checksum_grouped.map! { |code| code.to_i(2) }

    addr = (payload_chunked + checksum_grouped).map { |code| Base32::ALPHABET[code] }.join()
    return Base32::BCH_PREFIX + ":" + addr
end

# Why is it called poly_mod anyway?
def poly_mod data
    c = 1 #64bit unsigned

    data.each { |byte|
        c0 = c >> 35
        c = ((c & 0x07ffffffff) << 5) ^ byte

        # Literally copy pasted from the spec
        # Try and guess what this is doing
        c ^= 0x98f2bc8e61 if (c0 & 0x01)
        c ^= 0x79b76d99e2 if (c0 & 0x02)
        c ^= 0xf33e5fb3c4 if (c0 & 0x04)
        c ^= 0xae2eabe2a8 if (c0 & 0x08)
        c ^= 0x1e4f43e470 if (c0 & 0x10)
    }

    checksum = c ^ 1

    puts "CHCECKSUM #{checksum}"
    checksum
end

# Take an array of 8 bit elements and turn it into a array of 5 bit elements
def to_5bit_arr arr
    result = []

    accumulator = 0
    bits = 0

    for value in arr
        accumulator = (accumulator << 8) | value
        bits += 8

        while bits >= 5
            result << ((accumulator >> (bits - 5)) & 31)
            bits -= 5
        end
    end

    if bits > 0
        # we needa pad
        result << ((accumulator << (5 - bits)) & 31)
    end

    puts "Start: #{arr}"
    puts "End: #{result}"
    result
end