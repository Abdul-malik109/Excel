-- data cleaning project


select * from layoffs;

-- 1. Remove Duplicates
-- 2. standardize the data
-- 3. null values or blanlk values
-- 4. Remove any columns


# copying this layoffs data into a new table named layoffs_stagging if something happens accidentally in layoffs table
#create table layoffs_staging like layoffs;

select * from layoffs_staging;

#insert layoffs_staging select * from layoffs;

select * from layoffs_staging where country = 'india';
 
 
-- identifying duplicates 

select *, row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, `date`)
as no_of_entries from layoffs_staging;


with duplicate_cte as (select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as no_of_entries from layoffs_staging)
select * from duplicate_cte where no_of_duplicates > 1;


select * from layoffs_staging where company = 'yahoo';
select * from layoffs_staging where company = 'cazoo';
select * from layoffs_staging where company = 'hibob';
select * from layoffs_staging where company = 'wildlife studios';
select * from layoffs_staging where company = 'casper';


-- deleting only duplicate values

with duplicate_cte as (select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as no_of_entries from layoffs_staging)
delete from duplicate_cte where no_of_entries > 1;  # this wont work and shows error


-- double click on the layoffs staging and click the clipboard and copy the select statement and come here and paste it....


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `no_of_entries` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




select * from layoffs_staging2;

insert into layoffs_staging2 select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
as no_of_entries from layoffs_staging;

select * from layoffs_staging2 where  no_of_entries > 1;

-- deleting the duplicates

delete from layoffs_staging2 where no_of_entries > 1;

select * from layoffs_staging2 where  no_of_entries > 1;  # no more duplicates

select * from layoffs_staging2;


-- standardzing data it means finding issues and fixing it

select company, trim(company) as new_company from layoffs_staging2;   # trim clears the white space out

update layoffs_staging2 set company = trim(company);

select distinct industry from layoffs_staging2 order by 1; # you can see the no name companies and null and cryptocurriences(in different types like
												           -- with n without spaces

select * from layoffs_staging2 where industry like 'crypto%' order by company;

-- updating crypto currency, cryptocurrency, crypto to one and only crypto

update layoffs_staging2 set industry = 'crypto' where industry like 'crypto%';
select * from layoffs_staging2 where industry like 'crypto%' order by company;
select distinct industry from layoffs_staging2 order by 1; 


select distinct location from layoffs_staging2 order by 1;
select distinct country from layoffs_staging2 order by 1;    # we have two values 1.united states  2.united states.

-- to remove that "." from there
select distinct country, trim(trailing '.' from country) from layoffs_staging2 order by 1;

update layoffs_staging2 set country = trim(trailing '.' from country) where country like 'United States%';


-- to update the date column data type from text to date format

select `date`, str_to_date(`date`, '%m/%d/%Y') as new_date_format from layoffs_staging2;
update layoffs_staging2 set date = str_to_date(`date`, '%m/%d/%Y');
select `date` from layoffs_staging2;


# you can still notice that the date column is still a text

alter table layoffs_staging2 modify column `date` date;  # you can see that the date is changed to date format instead of text



-- removing null values or blank values from total layoffs

select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

update layoffs_staging2 set industry = null where industry = '';

select * from layoffs_staging2 where industry is null or industry = '';

select * from layoffs_staging2 where company = 'airbnb';

select * from layoffs_staging2 t1 join layoffs_staging2 t2 on t1.company = t2.company
where (t1.industry is null or t1.industry = '') and t2.industry is not null;


update layoffs_staging2 t1 join layoffs_staging2 t2 on t1.company = t2.company set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;

select * from layoffs_staging2 where company = 'airbnb';


select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;
delete from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;
select * from layoffs_staging2;
alter table layoffs_staging2 drop column no_of_entries;



































































































