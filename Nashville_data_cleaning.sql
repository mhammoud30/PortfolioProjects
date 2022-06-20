--- Cleaning Data in SQL Queries

Select *
From PortfolioProject.dbo.NashvilleHousing

--- Standardize SaleDate Format

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)


ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate

EXEC sp_rename 'NashvilleHousing.SaleDateConverted', 'SaleDate', 'COLUMN'

Select *
From PortfolioProject.dbo.NashvilleHousing

--- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
order by ParcelID

-- Notice that the ParcelID is exactly the same as the PropertyAddress 
-- Populate the Null values in PropertyAddress with the PropertyAddress of same ParcelID

-- Looking at the PropertyAdresses that are null but share a parcelID
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Copy Address that shares same ParcelID 

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--- Breaking out Address into Individual Columns (Address, City, State)


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select COUNT(*)
From PortfolioProject.dbo.NashvilleHousing
Where OwnerAddress is NULL

Select OwnerAddress 
From PortfolioProject.dbo.NashvilleHousing


	




