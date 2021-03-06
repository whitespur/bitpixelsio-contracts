// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IRentablePixel.sol";
import "../interfaces/IMarketPlace.sol";

library AppConstants{
    uint256 constant isTestMode = 1;
    uint256 constant publicPrice = isTestMode == 1 ? 1000000000000000 : 1000000000000000000; // 1 AVAX
    uint256 constant dayInSeconds = isTestMode == 1 ? 1 : 86400;
    uint256 constant _NOT_ENTERED = 1;
    uint256 constant _ENTERED = 2;
}

struct AppStorage {
    //ERC721
    string _name;
    string _symbol;
    mapping(uint256 => address) _owners;
    mapping(address => uint256) _balances;
    mapping(uint256 => address) _tokenApprovals;
    mapping(address => mapping(address => bool)) _operatorApprovals;
    //ERC721Enumerable
    mapping(address => mapping(uint256 => uint256)) _ownedTokens;
    mapping(uint256 => uint256) _ownedTokensIndex;
    uint256[] _allTokens;
    mapping(uint256 => uint256) _allTokensIndex;
    //ERC721URIStorage
    mapping(uint256 => string) _tokenURIs;//not used

    uint256 isSaleStarted;
    string baseUri;

    mapping(uint256 => IRentablePixel.RentData[]) RentStorage;
    mapping(address => uint256) totalLockedValueByAddress;
    uint256 totalLockedValue;

    mapping(uint256 => IMarketPlace.MarketData) Market;
    address payable feeReceiver;
    uint256 feePercentage;
    uint32 isRentStarted;
    uint32 isMarketStarted;

    uint32 limitMinDaysToRent;
    uint32 limitMaxDaysToRent;
    uint32 limitMinDaysBeforeRentCancel;
    uint32 limitMaxDaysForRent;
    uint256 _status;
    uint256 reflectionBalance;
    uint256 totalDividend;
    mapping(uint256 => uint256) lastDividendAt;
    uint256 reflectionPercentage;
    uint256 currentReflectionBalance;

    //pixel group id to marketdata
    mapping(uint256 => IMarketPlace.MarketDataV2) MarketV2;
    //pixel id to pixel group
    mapping(uint256 => uint256) MarketV2Pixel;
    uint256 creatorBalance;
}

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }

    function abs(int256 x) internal pure returns (uint256) {
        return uint256(x >= 0 ? x : -x);
    }
}

interface ReentrancyGuard{
    modifier nonReentrant() {
        require(LibAppStorage.diamondStorage()._status != AppConstants._ENTERED, "ReentrancyGuard: reentrant call");

        LibAppStorage.diamondStorage()._status = AppConstants._ENTERED;

        _;

        LibAppStorage.diamondStorage()._status = AppConstants._NOT_ENTERED;
    }
}
