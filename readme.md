A Bitcoin Cash Ruby Experiment
==============================

Short term Goals:
    - Create public / private key pairs
    - Generate addresses

Long term goals:
    - Monitor payments to those addresses

Why bitcoin cash? Zero confirmation payments are possible

Quick fax
=========

* A public key can be calculated using the private key, so storing only the private key is possible (Mastering Bitcoin)
* Private keys are 256 bits long, so, the private key can be any number between 1 and n - 1, where n is a constant (n = 1.158 * 1077, slightly less than 2256)