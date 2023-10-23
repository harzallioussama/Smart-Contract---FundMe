from brownie import accounts , fundMe , network

def main() :
    account = accounts[0]
    # account = accounts.load("fundTest")
    print(account)
    fund_me = fundMe.deploy({"from":account})
    print(f"contract deployed to {fund_me.address}")
    print(fund_me)