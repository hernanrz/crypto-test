require 'openssl'
require './hex.rb'

VERSION_BYTE = 0.chr
# base58 chars
ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

def to_base58(payload_str)
    src = VERSION_BYTE + payload_str
    
    double_hash = OpenSSL::Digest::SHA256.new(OpenSSL::Digest::SHA256.new(src).digest).digest
    checksum = double_hash.bytes.take(4).map { |byte| byte.chr }.join

    third_step = src + checksum
    big_int_hex = third_step.bytes.map { |byte| byte.to_s(16).rjust(2, '0') }.join
    big_int = big_int_hex.hex
    encoded_string = ""

    while big_int > 0 
        remainder = big_int % 58
        big_int /= 58
        encoded_string += ALPHABET[remainder]
    end


    third_step.scan(/^\x00+/).size.times {
        encoded_string += ALPHABET[0]
    }

    encoded_string.reverse    
end

def from_base58(base58)
    ordered = base58.reverse

    big_int = 0
    encoded_string = ordered.split("")
    zeroes = 0

    while encoded_string.last == ALPHABET[0]
        zeroes +=1
        encoded_string.pop
    end

    while encoded_string.size > 0
        remainder = ALPHABET.index encoded_string.last
        big_int = 58*big_int + remainder
        
        encoded_string.pop
    end

    result = big_int.to_s(16)
    decode_hex result
end