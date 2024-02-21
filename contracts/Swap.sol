// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IERC20.sol";

contract Swap {

    address manoToken;
    address tokenMano;

    event SwapSuccessful(address _user, address _from, address _to, uint _fromAmount, uint _toAmount);

    constructor (address _manoToken, address _tokenMano) {
        manoToken = _manoToken;
        tokenMano = _tokenMano;
        ratio[_manoToken] = 1;
        ratio[_tokenMano] = 2;
    }

    mapping(address => uint256) ratio;

    function swapToken (address _from, address _to, uint _amount) external {

        // check for addr zero
        require(msg.sender != address(0), "addr zero error");

        // check swap amount
        require(_amount > 0, "You can't swap zero tokens");

        // check balance of user in _from token
        require(IERC20(_from).balanceOf(msg.sender) >= _amount);

        // calculate swap
        uint256 _swapValue = calculateSwap(_to, _amount);

        // transferFrom _from token to contract 
        require(IERC20(_from).transferFrom(msg.sender, address(this), _amount), "transaction failed");

        // transfer to user account
        IERC20(_to).transfer(msg.sender, _swapValue);

        emit SwapSuccessful(msg.sender, _from, _to, _amount, _swapValue);
    }

    function setTokenRatio (address _token, uint256 _newRatio) external {
        ratio[_token] = _newRatio;
    }

    function calculateSwap (address _token, uint256
     _amount ) public view returns (uint256) {
        return ratio[_token] * _amount;
    }
}