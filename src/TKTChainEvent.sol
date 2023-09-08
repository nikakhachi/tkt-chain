// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin/token/ERC1155/ERC1155.sol";
import "openzeppelin/access/Ownable.sol";
import "openzeppelin/token/ERC1155/extensions/ERC1155Supply.sol";
import "./UC.sol";

contract TKTChainEvent is ERC1155, Ownable, ERC1155Supply {
    /// @dev Custom Errors
    error InvalidPrice();
    error MaxSupplyReached();
    error DuplicateIds();

    struct Ticket {
        uint256 price;
        uint256 maxSupply;
    }

    string public name;
    string public description;
    uint256 public eventStartsAt;

    uint256 public ticketSalesEndsAt;
    uint256 public ticketTypeCount;
    mapping(uint256 => uint256) public ticketTypePrices;
    mapping(uint256 => uint256) public ticketTypeMaxSupplies;

    constructor(
        string memory _name,
        string memory _description,
        string memory _uri,
        uint256 _ticketSalesEndsAt,
        uint256 _eventStartsAt,
        Ticket[] memory _tickets
    ) ERC1155(_uri) {
        uint length = _tickets.length;

        for (UC i = ZERO; i < uc(length); i = i + ONE) {
            uint256 id = i.unwrap();
            Ticket memory ticket = _tickets[id];

            ticketTypePrices[id] = ticket.price;
            ticketTypeMaxSupplies[id] = ticket.maxSupply;
        }

        name = _name;
        description = _description;
        ticketSalesEndsAt = _ticketSalesEndsAt;
        ticketTypeCount = length;
        eventStartsAt = _eventStartsAt;
    }

    function buyTickets(
        address _to,
        uint256 _ticketTypeId,
        uint256 _quantity
    ) public payable {
        if (msg.value < ticketTypePrices[_ticketTypeId] * _quantity)
            revert InvalidPrice();
        _mint(_to, _ticketTypeId, _quantity, "");
    }

    function buyTicketsBatch(
        address _to,
        uint256[] calldata _ticketTypeIds,
        uint256[] calldata _ticketTypeQuantities
    ) public payable {
        uint256 length = _ticketTypeIds.length;
        uint256 overallPrice;

        for (UC i = ZERO; i < uc(length); i = i + ONE) {
            uint256 index = i.unwrap();
            overallPrice +=
                ticketTypePrices[_ticketTypeIds[index]] *
                _ticketTypeQuantities[index];
        }

        if (msg.value < overallPrice) revert InvalidPrice();

        _mintBatch(_to, _ticketTypeIds, _ticketTypeQuantities, "");
    }

    function remainingTickets(
        uint256 _ticketTypeId
    ) public view returns (uint256) {
        return ticketTypePrices[_ticketTypeId] - soldTickets(_ticketTypeId);
    }

    function soldTickets(uint256 _ticketTypeId) public view returns (uint256) {
        return ERC1155Supply.totalSupply(_ticketTypeId);
    }

    function editName(string memory _name) public onlyOwner {
        name = _name;
    }

    function editDescription(string memory _description) public onlyOwner {
        description = _description;
    }

    function editTicketSalesEndsAt(
        uint256 _ticketSalesEndsAt
    ) public onlyOwner {
        ticketSalesEndsAt = _ticketSalesEndsAt;
    }

    function editEventStartsAt(uint256 _eventStartsAt) public onlyOwner {
        eventStartsAt = _eventStartsAt;
    }

    function editTicketTypeMaxSupply(
        uint256 _ticketTypeId,
        uint256 _maxSupply
    ) public onlyOwner {
        if (totalSupply(_ticketTypeId) > _maxSupply) revert MaxSupplyReached();
        ticketTypeMaxSupplies[_ticketTypeId] = _maxSupply;
    }

    function withdrawFunds() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success);
    }

    receive() external payable {}

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        uint length = ids.length;
        for (UC i = ZERO; i < uc(length); i = i + ONE) {
            uint256 index = i.unwrap();
            uint256 ticketId = ids[index];
            if (
                ERC1155Supply.totalSupply(ticketId) + amounts[index] >
                ticketTypeMaxSupplies[ticketId]
            ) revert MaxSupplyReached();
        }
    }
}
