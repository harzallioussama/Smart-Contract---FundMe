// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



// get the latest price of eth in usd

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

contract fundMe {
    mapping(address => uint256) public  addressToAmount ;
    address public owner ;
    constructor()  {
        owner = msg.sender ;
    }
    function fund() public payable {
        uint256 minUsd = 10 * (10 ** 18) ;
        require( getConversionRate(msg.value) >= minUsd , "Minimum of 10USD is required" ) ;
        addressToAmount[msg.sender] += msg.value ;
    }
    // Sepolia Testnet
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (
            ,int256 answer,,,
        ) = priceFeed.latestRoundData() ;
        return uint256(answer) ;
    }
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethInUsd = (ethPrice * ethAmount) / 100000000 ;
        return ethInUsd ;
    }
    function withdraw() public payable {
        require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance) ; 
    }

}

