require_relative "base58"
require_relative "base32"
require_relative "hex"

require 'openssl'
require "test/unit"


class TestAddress < Test::Unit::TestCase
    def test_hex
        start = "3d3c5a075578146d873aaa33def8d7b0a1657d5d"
        assert_equal(start, encode_hex(decode_hex(start)))
    end

    def test_base58
        group = OpenSSL::PKey::EC::Group.new 'secp256k1'
        ec = OpenSSL::PKey::EC.new group

        ec.generate_key

        public_key = ec.public_key.to_bn.to_s(16)
        payload = decode_hex public_key

        ripemd = OpenSSL::Digest::RIPEMD160.new(OpenSSL::Digest::SHA256.new(payload).digest)
        addr = ripemd.digest

        key_hash = ripemd.to_s

        b58 = to_base58 addr
        assert_equal(key_hash, encode_hex(from_base58(b58)))
    end
end