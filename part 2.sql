-- exploratory data analysis --
select * from layoffs_staging2;


select max(total_laid_off) , max(percentage_laid_off)
from layoffs_staging2;

select * from layoffs_staging2
where percentage_laid_off =1 
order by funds_raised_millions desc  ;


select company , sum(total_laid_off) 
 from layoffs_staging2
 group by company 
 order by 2 desc ; 
 
 select min(`date`), max(`date`)
 from layoffs_staging2;
 
 select year(`date`) , sum(total_laid_off) 
 from layoffs_staging2
 group by year(`date`) 
 order by 1 desc ; 
 
  select stage , sum(total_laid_off) 
 from layoffs_staging2
 group by stage 
 order by 1 desc ; 
 
 
  select company , sum(percantage_laid_off) 
 from layoffs_staging2
 group by comapny 
 order by 1 desc ; 
 
 
 select year(`date`)`year` , substring(`date` ,6,2) as `month` , sum(total_laid_off)
 from layoffs_staging2
  where  substring(`date` ,6,2) is not null
 group by `year` ,`month` 
 order by 2 asc;
 

with rolling_total as (
 select  substring(`date` ,1,7) as `month` , sum(total_laid_off) as total_off
 from layoffs_staging2
  where  substring(`date` ,6,2) is not null
 group by `month` 
 order by 1 asc
)
select `month` ,total_off
,sum(total_off) over(order by `month`)as rolling_total
from rolling_total;

with Company_year (company, years , total_laid_off) as(
  select company , year(`date`) as years , sum(total_laid_off) 
 from layoffs_staging2
 group by company ,year(`date`) 
 )
select * , dense_rank() over(partition by years order by total_laid_off desc)as ranking
from Company_yea r
where years is not null
order by ranking ;
