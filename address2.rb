require 'openssl'
require './hex.rb'
require './base58.rb'

group = OpenSSL::PKey::EC::Group.new 'secp256k1'
ec = OpenSSL::PKey::EC.new group

ec.generate_key

p "Hey we got our pair of keys, v cool"


# Let's go full base 58 here
public_key = ec.public_key.to_bn.to_s(16)
p public_key

payload = decode_hex public_key

ripemd = OpenSSL::Digest::RIPEMD160.new(OpenSSL::Digest::SHA256.new(payload).digest)
addr = ripemd.digest


p "PKHash #{ ripemd.to_s }"

p "Address #{to_base58 addr}"