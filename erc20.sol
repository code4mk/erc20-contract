pragma solidity '0.5.11';

/**
 * ERC20 Token
 * @author @code4mk <twiiter.com/@code4mk>
 */
contract ERC20 {

    string  the_name;
    string  the_symbol;
    uint8   the_decimal;
    uint256 the_supply;
    address the_owner;
    address payer;
    address initial_owner;
    string version = "0.0.1";

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);


    constructor(string memory _name,string memory _symbol,uint8 _decimal,uint256 _supply) public{
        the_name = _name;
        the_symbol = _symbol;
        the_decimal = _decimal;
        the_supply = _supply;
        the_owner = msg.sender;
        balances[msg.sender] = _supply;
    }

    modifier isOwner() {
        require(msg.sender == the_owner);
        _;
    }

    function name() public view returns (string memory){
        return(the_name);
    }
    function symbol() public view returns (string memory){
        return(the_symbol);
    }

    function decimals() public view returns (uint8){
        return(the_decimal);
    }

    function totalSupply() public view returns (uint256) {
        return(the_supply);
    }

    function balanceOf(address _owner) view public returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /* custom functions by @code4mk */

    function addSupply(uint256 _quantity) public isOwner() {
        the_supply = the_supply + _quantity;
    }

    function addBalance(uint256 _amount ) public isOwner() {
        balances[msg.sender] = balances[msg.sender] + _amount;
    }

    function addReserve(uint256 _quantity) public isOwner() returns(bool){
        if (balances[msg.sender] >= _quantity && _quantity > 0) {
            balances[msg.sender] = balances[msg.sender] - _quantity;
        } else {
            return false;
        }
    }

    function theOwner() view public returns (address) {
        return (the_owner);
    }

    function transferOwnership(address _new) public isOwner() {
        the_owner = _new;
    }
}
