--cleaning data with SQL

SELECT *
FROM PortfolioProject..NashvilleHousing

--Changing SaleDate (changing from DateTime format)

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

--Property Address (Identifying ones with Null values and Populating)

SELECT *
FROM PortfolioProject..NashvilleHousing
--Where PropertyAddress is NULL
order by ParcelID

--This code was to fill in Propertyaddress with Null when the ParcelID is the same but the UniqueID is different.

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]

--to Identify the remaing Null
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Spliting Address into different Columns 

		SELECT PropertyAddress
		FROM PortfolioProject..NashvilleHousing
		--Where PropertyAddress is NULL
		--order by ParcelID
	SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
  From PortfolioProject..NashvilleHousing

  ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing

--Spliting Owners Address(another method PARSENAME)

Select *
From PortfolioProject..NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress,',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)


--Changing the Y and N to Yes and No
Select DISTINCT(SoldAsVacant), Count(SoldasVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant

Select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant
	 END
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant =
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant
	 END

-- Removing Duplicates
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER by
			UniqueID
			) row_num
FROM PortfolioProject..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

--Deleting Unused Column for Final Analyses

Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate