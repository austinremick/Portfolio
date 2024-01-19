--- Cleaning data in SQL queries

select *
from NashHousing

---------- Standardize the date format

select SaleDateConverted, CONVERT(Date,SaleDate)
from NashHousing

update NashHousing
SET SaleDate = CONVERT(Date,SaleDate)

select SaleDate
from NashHousing

ALTER TABLE NashHousing
Add SaleDateConverted Date;

UPDATE NashHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------- Populate property address data where address is NULL

select *
from NashHousing
-- where propertyaddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashhousing a
JOIN Nashhousing b
	ON a.parcelID = b.parcelID
	AND a.uniqueID <> b.uniqueID
where a.PropertyAddress is null

UPDATE a
SET propertyaddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashhousing a
JOIN Nashhousing b
	ON a.parcelID = b.parcelID
	AND a.uniqueID <> b.uniqueID
where a.PropertyAddress is null

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------- Breaking out property address into individual columns (address, city, state) using substrings

select propertyaddress
from NashHousing
-- where propertyaddress is null
-- order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address, -- In PropertyAddress field, starting at 1st character and searching until it finds a comma. The
																			-- -1 is there to stop the output before the comma, as opposed to including the comma.
SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress)) as Address -- The second argument of this substring is "charindex...+1" because we want to
																							----- start it right after the comma
From nashhousing

ALTER TABLE NashHousing
Add PropertySplitAddress nvarchar(255); -- Adds a new column to the table for the address (first substring)

UPDATE NashHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) -- Inserts the address itself (first substring) into the new column

ALTER TABLE NashHousing
Add PropertySplitCity nvarchar(255); -- Adds a new column to the table for the city (second substring)

UPDATE NashHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress)) -- Inserts the city itself (second substring) into the new column

select *
from NashHousing

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------- Breaking out owner address into individual columns (address, city, state) using parsename 
select *
from NashHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from NashHousing


ALTER TABLE NashHousing
Add OwnerSplitAddress nvarchar(255); -- Adds a new column to the table for the address (first substring)

UPDATE NashHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) -- Inserts the address itself (first parsename) into the new column

ALTER TABLE NashHousing
Add OwnerSplitCity nvarchar(255); -- Adds a new column to the table for the city (second parsename)

UPDATE NashHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) -- Inserts the city itself (second parsename) into the new column

ALTER TABLE NashHousing
Add OwnerSplitState nvarchar(255); -- Adds a new column to the table for the city (third parsename)

UPDATE NashHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) -- Inserts the city itself (third parsename) into the new column

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select SoldAsVacant,
CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
from NashHousing

UPDATE NashHousing
SET SoldAsVacant = CASE
					WHEN SoldAsVacant = 'Y' THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END

select distinct(SoldAsVacant), Count(SoldAsVacant)
From NashHousing
Group by SoldAsVacant
Order by count(soldasvacant)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove duplicates

WITH RowNumCTE AS (
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID
	) row_num
from NashHousing
-- order by ParcelID
)

DELETE 
from RowNumCTE
where row_num > 1


select *
from RowNumCTE
WHERE Row_Num > 1
ORDER BY PropertyAddress

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns
select *
from NashHousing

ALTER TABLE NashHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashHousing
DROP COLUMN SaleDate

