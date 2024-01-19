/* 

Data Cleaning Using Microsoft SQL Server Management Studio 

*/

---------------------------------------------------------------------------------------------------------------------------------

-- Select all columns to view the data and identify where to clean 


SELECT 
		*
FROM
		housingdata;

---------------------------------------------------------------------------------------------------------------------------------

-- The SaleDate column is in MMDDYYY format; The standard format for SQL is YYYYMMDD
-- Modify the column by using the 'Convert' function

UPDATE housingdata
set SaleDate=CONVERT(date,SaleDate);

---------------------------------------------------------------------------------------------------------------------------------

-- The PropertyAddress column has null values; there are empty fields in that column
-- Populate the missing fields by comparing the ParcelID and the UniqueID of the PropertyAddress

UPDATE a
-- Using the alias 'a' to avoid any errors
SET PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM housingdata a
JOIN housingdata b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

---------------------------------------------------------------------------------------------------------------------------------

-- Split the PropertyAddress column into different columns, i.e, address, city and state 
-- Create new columns to house the data split from the ProperyAddress column

ALTER TABLE housingdata
ADD Property_Address NVARCHAR(255);

ALTER TABLE housingdata
ADD Property_City NVARCHAR(255);

-- Split the data into the new columns using ',' as the delimiter to split data in PropertyAddress columns

UPDATE housingdata
SET Property_Address=
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

UPDATE housingdata
SET Property_City=
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));

---------------------------------------------------------------------------------------------------------------------------------

-- The OwnerAddress column is similar to the PropertyAddress, Split the OwnerAddress column into address, city and state
-- Create three new columns to house the split data

ALTER TABLE housingdata
ADD Owner_Address NVARCHAR(255);

ALTER TABLE housingdata
ADD Owner_City NVARCHAR(255);

ALTER TABLE housingdata
ADD Owner_State NVARCHAR(255);

-- Split the data into the newly created column

UPDATE housingdata
SET Owner_Address=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);

UPDATE housingdata
SET Owner_City=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);

UPDATE housingdata
SET Owner_State=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);


---------------------------------------------------------------------------------------------------------------------------------

-- The SoldAsVacant Column has four different entries; Yes, No, Y and N.
-- For every Y replace with Yes, and for every N replace with No

UPDATE housingdata
SET SoldAsVacant=CASE 
					WHEN SoldAsVacant = 'Y' THEN 'YES'
					WHEN SoldAsVacant = 'N' THEN 'NO'
					ELSE SoldAsVacant
					END
	
---------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates using CTE

WITH temphousingdata AS
	(SELECT *, ROW_NUMBER() OVER 
	(PARTITION BY ParcelID,
				  PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
					UniqueID
	) row_num

	FROM housingdata
	)
-- The temp table allows us to see the duplicates in the dataset

DELETE
FROM temphousingdata
WHERE row_num > 1;

---------------------------------------------------------------------------------------------------------------------------------

-- Delete unused columns in the dataset

ALTER TABLE housingdata
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict;

---------------------------------------------------------------------------------------------------------------------------------
