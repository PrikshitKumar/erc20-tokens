// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract TestToken is ERC20, Ownable, Pausable {
    constructor() ERC20("TestToken", "TTK") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10 ** 18); // 1M tokens to deployer - INITIAL SUPPLY
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function transfer(address _to, uint256 _amount) public override whenNotPaused returns (bool) {
        require(_amount <= balanceOf(msg.sender), "Insufficient Balance");
        _transfer(msg.sender, _to, _amount);
        return true;
    }
}
