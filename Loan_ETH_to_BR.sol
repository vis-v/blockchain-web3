// SPDX-License-Identifier: Unlisenced
pragma solidity ^0.8.0;

contract Loan {

    // Conversion rate between ETH and BR (1 ETH = 100 BR)
    uint256 conversionRate;

    // Interest rate (10% per hour)
    uint256 interestRate;

    // Struct to store loan information
    struct LoanInfo {
        address borrower; // borrower's address
        uint256 principal; // principal in BR
        uint256 interest; // interest in BR
        uint256 startTime; // timestamp when loan was issued
        bool settled; // whether the loan has been settled
    }

    // Mapping from user address to loan info
    mapping (address => LoanInfo) public loans;

    // lending limit
    uint lendingLimit = 10000;

    // Total loan amount to be tracked to stay within bank's capacity - Lending Limit
    uint public totalLoanAmount;

    //fallback function
    fallback() external payable {
        // Settle Loan when ETH is sent directly
        settleLoan(); //giveLoan(msg.value);
    }
    
    receive() external payable { //to eliminate the warnings
        // Settle Loan
        settleLoan();
    }


    // Give a loan to the user
    function giveLoan(uint256 _principal) public payable {
        //require(loans[msg.sender].principal == 0, "loan already exists"); //uncomment to restrict giving loans if he already has some loan to pay off
        require(_principal > 0, "principal must be greater than 0");
        require(totalLoanAmount < lendingLimit, "loan limit reached");

        //Conversion Rate
        conversionRate = 100;

        //Interest Rate
        interestRate = 10;

        // Convert the deposited ETH to BR coins
        uint256 principal = _principal * conversionRate;

        // Store the loan information in the mapping
        loans[msg.sender] = LoanInfo(msg.sender, principal, 0, block.timestamp, false);
        totalLoanAmount += principal;
    }

    // Settle the loan
    function settleLoan() public payable {
        // Check that the user has a loan
        require(loans[msg.sender].principal > 0, "Loan not found");
        require(!loans[msg.sender].settled, "Loan already settled");

        // Calculate the interest based on the elapsed time
        //uint256 interest = calculateInterest(msg.sender);

        // Calculate the total amount to be paid (principal + interest)
        uint256 total = totalToBePaid(msg.sender);  //loans[msg.sender].principal + interest;

        // Check that the user has paid enough
        require(checkTransactionValue() >= total, "Insufficient payment"); //require(msg.value >= total, "Insufficient payment");

        // Convert the address to a payable address
        address payable recipient = payable(msg.sender);

        // Return the deposited token to the user
        recipient.transfer(msg.value / conversionRate);

        // Update loan status
        loans[msg.sender].settled = true;
        totalLoanAmount -= loans[msg.sender].principal;
    }

    function checkTransactionValue() public payable returns (uint) {
    return msg.value;
    }

    function totalToBePaid(address _borrower) public view returns (uint256) {
        // Check that the user has a loan
        require(loans[_borrower].principal > 0, "Loan not found");

        // Calculate the interest based on the elapsed time
        uint256 interest = calculateInterest(_borrower);

        // Calculate the total amount to be paid (principal + interest)
        return loans[_borrower].principal + interest;
    }

    // Calculate the interest on the loan
    function calculateInterest(address _borrower) private view returns (uint256) {
        // Get the elapsed time since the loan was issued
        uint256 elapsedTime = block.timestamp - loans[_borrower].startTime;

        // Calculate the interest as a percentage of the principal
        return loans[_borrower].principal * interestRate * elapsedTime / (100 * 3600);
    }

}
