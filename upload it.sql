select * from layoffs ;

-- we need to create staging table to start analysis without miss any values --
create table layoffs_staging
like layoffs ;
select * from layoffs_staging;
-- we need to insert the data on the new table--
insert  into layoffs_staging 
select * from layoffs ;

-- 1 then we need to remove any duplicates --

select * ,row_number()
 over (partition by (company, industry, `date`, percabtage_laid_off, total_laid_off))as 
 row_num 
 from layoffs_staging;
 
 -- we find that there's duplicates in row_num column --
 -- we need to select the duplicates > 1 as filter ---
 select * from layoffs_staging
where row_num>1 ;
 
 -- then delete what we got ---
 -- but in mysql delete = update so need to create a table to insert the row_num column and delete them easily---
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
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into project_1.layoffs_staging2
select *,row_number()over(partition by company, location,industry ,
total_laid_off, percentage_laid_off, `date`, stage,country ,funds_raised_millions) as row_num 
from layoffs;

select* from layoffs_staging2
where row_num >1;

delete from layoffs_staging2
where row_num >1;

select * from layoffs_staging2;

-- 2 Standardizing data  --
select * from layoffs_staging2;


-- we need to use trim to make sure that's no space in the text---
select distinct(trim (company)) 
from layoffs_stagings ;

select company , trim (compay)
from layoffs_stagings; 

update layoffs_stagings 
set company = trim(company);

-- there's  Crypto has multiple different variations---
select * 
from layoffs_staging2
where insdustry like 'Crypto%';

update layoffs_staging2
 set industry = 'Crypto'
 where industry like 'Crypto%';

-- there's null values and blank in industry column --

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- we need to swtich the blank to null values ---
update layoffs_staging2 
  set industry = null
   where industry ='';

-- we need to find the null values by using join ----
 select *
  from layoffs_staging2 t1
  join layoffs_staging2 t2 
  on t1.company=t2.company
  WHERE t1.industry is null    
  and t2.industry is not null ;

-- then update it to null rows ---
 update layoffs_staging2 t1
 join layoffs_staging2 t2 
 on t1.company=t2.company 
 set t1.industry =t2.industry 
 WHERE t1.industry is null 
  and t2.industry is not null ;


-- we need to a time seiers from date beacuse the date is text ---
select `date`, 
str_to_date (date,'%m/%d/%Y')
from layoffs_staging2;


-- then we need to update it ---
update layoffs_staging2 
set `date`= str_to_date (date,'%m/%d/%Y')



