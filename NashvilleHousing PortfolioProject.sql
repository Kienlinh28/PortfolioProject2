/*

Cleaning Data in SQL

*/

-------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM PortfolioProject..NashvilleHousing



----- Standardize Data Format

SELECT SaleDateConverted, CONVERT(DATE, SaleDate) as DateSale
FROM PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
SET SaleDate=CONVERT(DATE, SaleDate)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SaleDateConverted DATE;

Update PortfolioProject..NashvilleHousing
SET SaleDateConverted= CONVERT(DATE, SaleDate)


-----Populate Property Address data ---



SELECT *
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID



Select a.ParcelID, a. PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
 ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress is null

 UPDATE a
  SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
 ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress is null


  -------Breaking out Address into Individual Columns (Address, City, State)------------


  SELECT 
  SUBSTRING(PropertyAddress, 1 , CHARINDEX (',', PropertyAddress) - 1)  Address,
   SUBSTRING(PropertyAddress,CHARINDEX (',', PropertyAddress) + 1 , LEN( PropertyAddress))  City
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is NULL
--ORDER BY ParcelID


ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitAddress=  SUBSTRING(PropertyAddress, 1 , CHARINDEX (',', PropertyAddress) - 1)


ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitCity nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitCity =    SUBSTRING(PropertyAddress,CHARINDEX (',', PropertyAddress) + 1 , LEN( PropertyAddress)) 



SELECT OwnerAddress,
PARSENAME(REPLACE (OwnerAddress, ',','.') , 1) as State, 
PARSENAME(REPLACE (OwnerAddress, ',','.') , 2) as City ,
PARSENAME(REPLACE (OwnerAddress, ',','.') , 3) as Address
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD State nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET State =    PARSENAME(REPLACE (OwnerAddress, ',','.') , 1)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD City nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET City =    PARSENAME(REPLACE (OwnerAddress, ',','.') , 2) 


ALTER TABLE PortfolioProject..NashvilleHousing
ADD Address nvarchar(255);



SELECT *
FROM PortfolioProject..NashvilleHousing


-------- Change Y and N to Yes and No in Sold as Vacant -------

SELECT DISTINCT(SoldasVacant), Count(SoldasVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY  SoldAsVacant 
ORDER BY Count(SoldasVacant)


 
SELECT SoldasVacant,
 CASE
	WHEN  SoldasVacant = 'Y' THEN 'Yes' 
	WHEN SoldasVacant = 'N' THEN 'No' 
	ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing



Update PortfolioProject..NashvilleHousing
SET SoldasVacant = CASE WHEN  SoldasVacant = 'Y' THEN 'Yes' 
	WHEN SoldasVacant = 'N' THEN 'No' 
	ELSE SoldAsVacant
	END

----------- Remove Duplicate--------

WITH RownumCTE AS 
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID,
								Saleprice,
								PropertyAddress,
								SaleDate,
								LegalReference
ORDER BY UniqueID) row_num
FROM portfolioproject..NashvilleHousing
)

SELECT *
FROM RownumCTE
WHERE row_num >1



----------- Delete Column -------


Alter table portfolioproject..NashvilleHousing 
DROP COLUMN .....
