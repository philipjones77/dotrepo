# PhilipSecond LAN SSH capsule

Date: 2026-09-22. This capsule contains only sanitized, portable information.

- [LAN client public key](lan-client-ed25519.pub): authorize this key on
  PC-PHILIP-WINDOWS for the reverse connection from PhilipSecond. Its SHA256
  fingerprint is `SHA256:61KYYjTl7UhvtAhY7divT7laH+nc7fUC43Ha1tb5VZ0`.
- PhilipSecond's Windows OpenSSH Server is running and uses ED25519 host
  fingerprint `SHA256:RQLkviLRLJwIqLtdhO0S0+WoSy1oeoUN/uPlhmsiKYc`.
- Use Windows hostname `PC-PHILIP-WINDOWS` for the other PC. The name resolves
  on the home network, but its TCP port 22 was not yet open when this capsule
  was recorded.

The private key, LAN addresses, host keys, authentication data, and private SSH
aliases remain local and must not be committed.
