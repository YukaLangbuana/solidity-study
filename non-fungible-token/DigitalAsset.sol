// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DigitalAsset {

    struct Asset {
        uint256 id;
        string name;
        string assetUrl;
        string description;
        address owner;
    }

    mapping(uint256 => Asset) public assets;

    function createAsset(string memory _name, string memory _assetUrl, string memory _description) public {
        Asset memory asset;
        asset.id = uint256(block.number);
        asset.name = _name;
        asset.assetUrl = _assetUrl;
        asset.description = _description;
        asset.owner = msg.sender;
        assets[asset.id] = asset;
    }

    function changeOwner(uint256 _id, address _newOwner) public {
        require(assets[_id].owner == msg.sender, "Only the current owner can change owner");
        assets[_id].owner = _newOwner;
    }

    function getAsset(uint256 _id) public view returns (Asset memory) {
        return assets[_id];
    }

    function getAssets() public view returns (Asset[] memory) {
        Asset[] memory assetsArray = new Asset[](assets.length);
        uint256 i = 0;
        for (uint256 key in assets) {
            assetsArray[i] = assets[key];
            i++;
        }
        return assetsArray;
    }

    function getOwner(uint256 _id) public view returns (address) {
        return assets[_id].owner;
    }

    function getAssetsByOwner(address _owner) public view returns (Asset[] memory) {
        Asset[] memory assetsArray = new Asset[](assets.length);
        uint256 i = 0;
        for (uint256 key in assets) {
            if (assets[key].owner == _owner) {
                assetsArray[i] = assets[key];
                i++;
            }
        }
        return assetsArray;
    }
}