import "./jetton";

message Mint {
    amount: Int;
    receiver: Address;
}

contract SampleJetton with Jetton {
    // total jettons in circulation
    // Uses TON's native coin unit system (as coins)
    total_supply: Int as coins;
    owner: Address;
    // metadata about the jettong
    content: Cell;
    mintable: Bool;
    // max supply of the jetton
    max_supply: Int as coins; // Extract parameter we set here. The Jetton Standards doesn't have this parameter.

    init(owner: Address, content: Cell, max_supply: Int) {
        self.total_supply = 0;
        self.owner = owner;
        self.mintable = true;
        self.content = content;
        self.max_supply = max_supply;
    }

    // Two minting mechanisms
    // 1. Owner minting
    receive(msg: Mint) { // 0xfc708bd2
        let ctx: Context = context();
        require(ctx.sender == self.owner, "Not owner");
        require(self.mintable, "Not mintable");
        require(self.total_supply + msg.amount <= self.max_supply, "Max supply exceeded");
        self.mint(msg.receiver, msg.amount, self.owner); // (to, amount, response_destination)
    }

    // 2. Public minting
    receive("Mint: 100") { // Public Minting
        let ctx: Context = context();
        require(self.mintable, "Not mintable");
        require(self.total_supply + 100 <= self.max_supply, "Max supply exceeded");
        self.mint(ctx.sender, 100, self.owner); // 🔴 
    }

    // Owner close minting, set mintable to false
    receive("Owner: MintClose") {
        let ctx: Context = context();
        require(ctx.sender == self.owner, "Not owner");
        self.mintable = false;
    }
} 