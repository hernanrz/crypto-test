
def decode_hex(str)
    str.scan(/../).map { |byte| byte.to_i(16).chr }.join
end

def encode_hex(digest)
    digest.bytes.map { |byte| byte.to_s(16).rjust(2, "0") }.join
end