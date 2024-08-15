// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import { ERC20 } from "solmate/tokens/ERC20.sol";

contract RoyaltyToken is ERC20 {
    
    address public royaltyAddress;
    uint256 public royaltyFeePercentage;

    constructor(
        string memory _name, 
        string memoy _symbol, 
        uint8 _decimals,
        uint256 _royaltyFeePercentage,
        uint256 _initialSupply
    ) ERC20(_name, _symbol, _decimals) {
        royaltyAddress = msg.sender;
        royaltyFeePercentage = _royaltyFeePercentage;
        _mint(msg.sender, _initialSupply);
    }

    function transferWithRoyalty (address to, uint256 amount) public returns (bool) {
        uint256 royaltyAmount = amount * royaltyFeePercentage / 100;

        transfer(royaltyAddress, royaltyAmount);

        transfer(to, amount - royaltyAmount);

        return true;
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        uint256 royaltyAmount = amount * royaltyFeePercentage / 100;
        
        balanceOf[msg.sender] -= amount;

        unchecked {
            balanceOf[to] += amount - royaltyAmount;
            balanceOf[royaltyAddress] += royaltyAmount;
        }
        emit Transfer(msg.sender, royaltyAddress, royaltyAmount);
        emit Transfer(msg.sender, to, amount - royaltyAmount);

        return true;
    }
}