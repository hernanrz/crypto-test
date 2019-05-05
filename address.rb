##
# Warning: SecureRandom is not actually safe if running a ruby version older than 2.5.x
# https://paragonie.com/blog/2016/05/how-generate-secure-random-numbers-in-various-programming-languages#ruby-csprng
require 'securerandom'
require 'openssl'
p = 2**256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 - 1
P =  0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFFC2F

G = {
    x: 0x79BE667E_F9DCBBAC_55A06295_CE870B07_029BFCDB_2DCE28D9_59F2815B_16F81798,
    y: 0x483ADA77_26A3C465_5DA4FBFC_0E1108A8_FD17B448_A6855419_9C47D08F_FB10D4B8
}

pkey = SecureRandom.hex(32).upcase


p "Private key #{pkey}"

p "We just encoded 256 bits of randomness into the following hexadecimal number, this is our private key"

p "The public key is calculated from the private key using elliptic curve multiplication, which is irreversible: where k is the private key, G is a constant point called the generator point and K is the resulting public key. The reverse operation, known as “finding the discrete logarithm”—calculating k if you know K—is as difficult as trying all possible values of k, i.e., a brute-force search."

pkey_int = pkey.to_i 16

p "Let's generate a public key K = k * G"
p "Where G is a generoator point defined by the secp256k1 standard and k is our private key"

# Initialize the named curve, builtin openssl because it's a well-known curve
group = OpenSSL::PKey::EC::Group.new 'secp256k1'
point = OpenSSL::PKey::EC::Point.new(group)