use PortofolioProject
go

--extracting everything from the table
select*
from dbo.NashvilleHousing;

--standardize date format
--the SaleDate column has a format style of yyyy-mm-dd 00:00:00.000 as we can see from the select statement below
--In order to remove zeros we follow the following steps
select SaleDate
from dbo.NashvilleHousing;

alter table dbo.NashvilleHousing
add SaleDateConverted date;

update dbo.NashvilleHousing 
set SaleDateConverted=CONVERT(date,SaleDate);

--from the select statement we can see that the date is in the appropriate format yyyy-mm-dd
select SaleDateConverted
from dbo.NashvilleHousing;

--splitting PropertyAddress field into two new fields one containing only the address and the other only the city
select
LEFT(PropertyAddress,charindex(',',PropertyAddress)-1) as Address
from dbo.NashvilleHousing;

select
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from dbo.NashvilleHousing;

alter table dbo.NashvilleHousing
add PropertySplitAddress nvarchar(255);

update dbo.NashvilleHousing 
set PropertySplitAddress=LEFT(PropertyAddress,charindex(',',PropertyAddress)-1);

alter table dbo.NashvilleHousing
add PropertySplitCity nvarchar(255);

update dbo.NashvilleHousing 
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));

--selecting the two newly created columns to check that have been populated after the update statements
select
PropertyAddress, 
PropertySplitAddress,
PropertySplitCity
from dbo.NashvilleHousing;

--doing the same thing in the OwnerAddress but this time using PARSENAME function
select
OwnerAddress
from dbo.NashvilleHousing;

select
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as Address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as City,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as State
from dbo.NashvilleHousing;

alter table dbo.NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update dbo.NashvilleHousing 
set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3);

alter table dbo.NashvilleHousing
add OwnerSplitCity nvarchar(255);

update dbo.NashvilleHousing 
set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2);

alter table dbo.NashvilleHousing
add OwnerSplitState nvarchar(255);

update dbo.NashvilleHousing 
set OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1);

--selecting the three newly created columns to check that have been populated after the update statements
select
OwnerAddress,
OwnerSplitAddress,
OwnerSplitCity,
OwnerSplitState
from dbo.NashvilleHousing;

--let's see all the possible values of the column SoldAsVacant
select distinct SoldAsVacant
from dbo.NashvilleHousing;

--and how many times each value occurs in the column
select
distinct SoldAsVacant,
COUNT(*) as frequency
from dbo.NashvilleHousing 
group by SoldAsVacant
order by SoldAsVacant;

--let's create a new column and then change N and Y to No and Yes respectively in order to have only 3 possible values(Yes,No,NULL)
alter table dbo.NashvilleHousing
add SoldAsVacant2 nvarchar(255);

insert into dbo.NashvilleHousing(SoldAsVacant2)
select SoldAsVacant
from dbo.NashvilleHousing;

update dbo.NashvilleHousing 
set SoldAsVacant2=(case
                   when SoldAsVacant2='Y' then 'Yes'
                   when SoldAsVacant2='N' then 'No'
                   else NULL
                   end);

--from the statement below we can confirm that we only have 3 possible values
select distinct SoldAsVacant2
from dbo.NashvilleHousing;


--delete columns that we'll not use
--let's add rollback statement in order not to delete the columns permanently
begin transaction;

alter table dbo.NashvilleHousing
drop column PropertyAddress;

alter table dbo.NashvilleHousing
drop column OwnerAddress,TaxDistrict;

rollback transaction;