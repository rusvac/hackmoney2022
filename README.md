# Battery
### Recharging Borrowing Power (Self-Paying Loans)

__Outline__
```
Powerplant*     - Interest Bearing Assets
Charger         - Locker for assets
Battery         - Claim charges and liquidation logic
```
*not included

__Contract Sizes__
```
 ·-----------------|-------------·
 |  Contract Name  ·  Size (KB)  │
 ··················|··············
 |  Battery        ·     12.038  │
 ··················|··············
 |  Charger        ·     19.636  │
 ·-----------------|-------------·
```


__Description__

Battery is a protocol that enables self-settling loans out of interest bearing tokens.

The Battery core contract allows users to take out spending power, denoted by charge tokens (CHRG) against collateral they've deposited into a Charger contract. Chargers are specialized NFTs, acting as a saftey deposit box for the deposited assets.

While the asset is in a charger, it may be used as collateral to take out CHRG. While CHRG is taken out against the asset, the asset is locked within the Charger until there is no longer an outstanding debt of CHRG.

To clear the outstanding CHRG from the Battery, and reclaim the collateral, the original amount of CHRG borrowed must be returned to the Battery. To facilitate this, two methods of repayment are offered:
1. Simple Repayment- where the user repays CHRG to the Battery
2. Flash Resolution- where a second party (contract) may access the required collateral from the Charger, then repay all of the remaining debt as CHRG



__Cool Stuff__
- The Battery allows users to borrow Charge Tokens
- a new charger can be deployed to accept any fancy new interest bearing asset
- the chargers are ERC721 token vaults that can hold metadata and be traded 
- Flash Resolutions are reminisent of flash loans, however they allow you to keep the fee as a reward for converting the assets



note: this protocol was a MVP to test self-paying loans - to continue development check out the protocol I'm helping build -> [Imaginary Fi](https://github.com/Imaginary-Finance)
