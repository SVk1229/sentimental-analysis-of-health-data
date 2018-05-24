create table senti1(sno int,sqt string,sq string,sr string,sdate string,ddate string,dkey int,dservice1 string, dservice2 string,nu string,sex string,age int,survey string,dmk string,mrn string)
row format delimited
fields terminated by ',' ;

CREATE  TABLE dictionary (
    type string,
    length int,
    word string,
    pos string,
    stemmed string,
    polarity string
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t';

create view senti_l1 as 
select sno,words from senti1 lateral view explode(sentences(lower(survey))) dummy as words;

create table senti2 as 
select sno,word from senti_l1 lateral view explode( words ) dummy as word;


create view senti3 as 
     select sno,l.word,
     case d.polarity 
     when 'negative' then -1
     when 'positive' then 1
     else 0 end as polarity
     from l2 l left outer join dictionary d on l.word = d.word;

create view senti_semi as
     select sno,
     case when sum(polarity)>0 then 'POSITIVE'
     when sum(polarity)<0 then 'NEGATIVE'
     else 'NEUTRAL' end as review 
     from senti3 group by sno;

create table senimental_analysis as
     select senti.sno,survey,review from senti join senti_semi on senti.sno = senti_semi.sno;








