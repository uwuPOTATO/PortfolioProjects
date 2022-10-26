Select * 
From PortfolioProject2.dbo.NashvileHousing2


--Change Sale Date column view
Select SaleDate, CONVERT(DATE,SaleDate)
From PortfolioProject2.dbo.NashvileHousing2

ALTER TABLE PortfolioProject2.dbo.NashvileHousing2
Add ConvertedSaleDate DATE

Update PortfolioProject2.dbo.NashvileHousing2
SET ConvertedSaleDate = CONVERT(DATE,SaleDate)


--Filling nulls in Property Adress column 
Select *
From PortfolioProject2.dbo.NashvileHousing2
where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject2.dbo.NashvileHousing2 a 
Join PortfolioProject2.dbo.NashvileHousing2 b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET a.propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
From PortfolioProject2.dbo.NashvileHousing2 a 
Join PortfolioProject2.dbo.NashvileHousing2 b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 


-- Convert address to address, sity, state cols
Select *
From PortfolioProject2.dbo.NashvileHousing2

Select SUBSTRING(PropertyAddress, 1,  CHARINDEX(',', PropertyAddress)-1) 
as Address 
From PortfolioProject2.dbo.NashvileHousing2

Select SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,
len(PropertyAddress)) 
as Sity 
From PortfolioProject2.dbo.NashvileHousing2

ALTER TABLE PortfolioProject2.dbo.NashvileHousing2
Add ConvertedAddress nvarchar(255)

Update PortfolioProject2.dbo.NashvileHousing2
SET ConvertedAddress = SUBSTRING(PropertyAddress, 1,  CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE PortfolioProject2.dbo.NashvileHousing2
Add ConvertedCity nvarchar(255)

Update PortfolioProject2.dbo.NashvileHousing2
SET ConvertedCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,len(PropertyAddress)) 


--Set owner address
Select PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) 
From PortfolioProject2.dbo.NashvileHousing2

ALTER TABLE PortfolioProject2.dbo.NashvileHousing2
Add OwnerConvertedAddress nvarchar(255)

Update PortfolioProject2.dbo.NashvileHousing2
SET OwnerConvertedAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)  

ALTER TABLE PortfolioProject2.dbo.NashvileHousing2
Add OwnerConvertedCity nvarchar(255)

Update PortfolioProject2.dbo.NashvileHousing2
SET OwnerConvertedCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) 

ALTER TABLE PortfolioProject2.dbo.NashvileHousing2
Add OwnerConvertedState nvarchar(255)

Update PortfolioProject2.dbo.NashvileHousing2
SET OwnerConvertedState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) 


--SoldAsVacant cleaning
Select distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject2.dbo.NashvileHousing2
Group by soldasvacant
order by count(SoldAsVacant)

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
End
From PortfolioProject2.dbo.NashvileHousing2

Update PortfolioProject2.dbo.NashvileHousing2
Set SoldAsVacant = 
CASE   When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
End


--Remove Duplicates
With this_set as (
Select *,
Row_Number() over (Partition by ParcelId,
								PropertyAddress,
								SaleDate,
								SalePrice,
								OwnerName
								order by 
									ParcelId
									) row_num
From PortfolioProject2.dbo.NashvileHousing2
)
Delete
From this_set
Where row_num>1


--Delete Unnesesary Cols
Select *
From PortfolioProject2.dbo.NashvileHousing2 

Alter table PortfolioProject2.dbo.NashvileHousing2
drop column TaxDistrict, SaleDate, OwnerAddress, PropertyAddress
