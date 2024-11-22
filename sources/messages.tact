struct JettonData {
    total_supply: Int;
    mintable: Bool;
    owner: Address;
    content: Cell;
    // wallet_code: Cell - This is the actual smart contract code for Jetton wallets
    // It's stored in the master contract and used to deploy new wallet contracts
    // when users receive tokens for the first time
    wallet_code: Cell;
}

struct JettonWalletData {
    balance: Int;
    owner: Address;
    master: Address;
    // code: Cell - This is the wallet's own contract code
    // Used for contract verification and to ensure wallet authenticity
    code: Cell;
}

message(0xf8a7ea5) TokenTransfer {
    query_id: Int as uint64;
    amount: Int as coins;
    destination: Address;
    response_destination: Address?;
    custom_payload: Cell?;
    forward_ton_amount: Int as coins;
    forward_payload: Slice as remaining; 
}

message(0x178d4519) TokenTransferInternal {
    query_id: Int as uint64;
    amount: Int as coins;
    // from: Address - The original sender's address (wallet owner)
    // Used to track who initiated the transfer and for notifications
    from: Address;
    response_destination: Address?;
    forward_ton_amount: Int as coins;
    forward_payload: Slice as remaining;
}

message(0x7362d09c) TokenNotification {
    // This notification is for the RECEIVER of the tokens
    // It notifies the recipient's wallet owner about received tokens
    // 'from' field indicates who sent the tokens
    query_id: Int as uint64;
    amount: Int as coins;
    from: Address;
    forward_payload: Slice as remaining;
}

message(0x595f07bc) TokenBurn {
    query_id: Int as uint64;
    amount: Int as coins;
    response_destination: Address?;
    custom_payload: Cell?;
}

message(0x7bdd97de) TokenBurnNotification {
    // NOTIFICATION TO MASTER CONTRACT
    query_id: Int as uint64;
    amount: Int as coins;
    sender: Address; // The address that initiated the burn
    response_destination: Address?; // Where to send confirmation/excess funds
    // sender and response_destination can be different: sender might want the response sent elsewhere
}

message(0xd53276db) TokenExcesses {
    query_id: Int as uint64;
}

message TokenUpdateContent {
    content: Cell;
}

// ==== TEP89: Jetton Wallet Discovery ====
message(0x2c76b973) ProvideWalletAddress {
    query_id: Int as uint64;
    owner_address: Address;
    include_address: Bool;
}

// take_wallet_address#d1735400 
// query_id:uint64 wallet_address:MsgAddress owner_address:(Maybe ^MsgAddress) = InternalMsgBody;
message(0xd1735400) TakeWalletAddress {
    query_id: Int as uint64;
    wallet_address: Address;
    owner_address: Slice as remaining;
}

// these hex identifiers are standardized in the Jetton standard (TEP-74)