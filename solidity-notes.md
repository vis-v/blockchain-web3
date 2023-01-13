# Solidity Notes

Hey there! I'm excited to share my knowledge of Solidity with you. I'll explain the common data types some important concepts that you'll come across while writing smart contracts on Ethereum. I'll be assuming that you have a basic understanding of programming and data types, and be providing detailed explanations for some specific topics that I wish I had known when I first started learning Solidity. 

## int and uint256
-  The ``uint256`` data type in Solidity represents an unsigned 256-bit integer, and the range of possible values for this data type is from 0 to 2^256 - 1 (that is 0 to 115,792,089,237,316,195,423,570,985,008,687,907,853,269,984,665,640,564,039,457,584,007,913,129,639,935. Hadn't I have added the commas, your brain would have overlooked the humongousnous of the number!).
- The ``int`` data type in Solidity represents a signed 256-bit integer, and the range of possible values for this data type is from -2^256/2 to 2^256/2 - 1 (-57,896,044,618,658,097,711,785,492,504,343,953,926,634,992,332,820,282,019,728,792,003,956,564,819,967 to 57,896,044,618,658,097,711,785,492,504,343,953,926,634,992,332,820,282,019,728,792,003,956,564,819,967).
- When using ``int``, be careful with overflow/underflow, because when the operation results in a number greater than the max positive value or lower than the min negative value it will wrap around to the other side.

## uint256 wrap around behavior in 7.5 and 8.0
- In version 7.5 of the Solidity programming language, there was a feature called "wrap around" for the ``uint256`` data type, which allowed for the automatic wrapping of values around to the maximum value of 2^256 - 1 when a value was decremented from 0. 
- This feature was removed in version 8.0, to prevent potential bugs and vulnerabilities caused by unexpected behavior.
- For example, in version 7.5 the following code would give you the maximum value possible for a uint256.

```
uint256 x = 0;
x--;
```

- In version 8.0, to achieve the same behavior as the wrap around feature, use the unchecked keyword before the arithmetic operation.
- This tells the compiler to perform the operation without any overflow or underflow checks, allowing for wrap around behavior.

```
uint256 x = 0;
unchecked {x--;}
```

## keccak256(abi.encodePacked()) for string comparison
- You are not comparing the original string anymore, you are comparing the hash of the string.
- The Keccak-256 hashing algorithm can be used to generate a fixed-size, deterministic output (a hash) from an input of any size. 
- When used in combination with the Ethereum ABI (Application Binary Interface) encoding function encodePacked(), it can be used to compare strings in a way that is resistant to certain types of tampering and data corruption. 
- The ABI encoding function takes a variable-length argument and converts it into a fixed-length byte array, and the Keccak-256 hash function is applied to the result, creating a unique hash of the input string. 
- This can be useful for comparing strings in a smart contract or other application, because it ensures that the input is unchanged and it can also save space on the blockchain.

## don't convert Strings to Bytes to find length
- Strings are a sequence of characters, in Ethereum smart contracts, they are typically encoded in UTF-8.
- UTF-8 is a variable-width encoding, which means that different characters may be represented by different numbers of bytes. Some characters in a string may be represented by 2 bytes, while others may be represented by 1 byte.
- Not every string can be converted into bytes to get the length of the string.
- Keep in mind that the number of bytes used to represent the string may not be the same as the number of characters in the string.

## address

- The `address` data type in solidity is 20 bytes long.
- To get the balance of an address, you can use the `.balance` keyword.
- Keep in mind that the balance is in wei, the smallest unit of ether, and you may want to convert it to ether or other higher denominations using a conversion factor of 10^18.

```
function getBalance(address _addr) public view returns (uint) {
    return _addr.balance;
}
```
