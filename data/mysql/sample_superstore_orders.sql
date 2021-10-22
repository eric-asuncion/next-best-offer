GRANT ALL PRIVILEGES ON *.* TO 'mysqluser' WITH GRANT OPTION;
ALTER USER 'mysqluser'@'%' IDENTIFIED WITH mysql_native_password BY 'mysqlpw';
FLUSH PRIVILEGES;
USE user-data;

/* orders */
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	category VARCHAR(20) not null,
	city VARCHAR(20) not null,
	country VARCHAR(20) not null,
	customerid VARCHAR(20) not null,
	customername VARCHAR(50) not null,
	orderdate DATE not null,
	orderid VARCHAR(20) not null,
	postalcode VARCHAR(10),
	productid VARCHAR(20) not null,
	productname VARCHAR(255) not null,
	region VARCHAR(50) not null,
	rowid INT not null,
	segment VARCHAR(20) not null,
	shipdate DATE not null,
	shipmode VARCHAR(20) not null,
	shipstatus VARCHAR(20) not null,
	state VARCHAR(20) not null,
	subcategory VARCHAR(20) not null,
	daystoshipactual INT not null,
	daystoshipscheduled INT not null,
	discount DECIMAL(10,2) not null,
	profit DECIMAL(10,2) not null, 
	quantity INT not null,
	sales DECIMAL(10,2) not null,
	salesforecast DECIMAL(10,2) not null,
	PRIMARY KEY (rowid) 
);

LOAD DATA INFILE '/data/orders.csv' 
INTO TABLE orders 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(category,city,country,customerid,customername,@orderdate,orderid,postalcode,productid,productname,region,rowid,segment,@shipdate,shipmode,shipstatus,state,subcategory,daystoshipactual,daystoshipscheduled,@discount,@profit,quantity,@sales,@salesforecast)
SET orderdate = STR_TO_DATE(@orderdate, '%d-%b-%y'),
shipdate = STR_TO_DATE(@shipdate, '%d-%b-%y'),
discount = REPLACE(@discount, '%', ''),
/*
profit = REPLACE(REPLACE(@profit, ',', ''), '$', ''),
*/
profit = REPLACE(REPLACE(REPLACE(REPLACE(@profit, '(', '-'), '$', ''), ',', ''), ')', ''),
sales = REPLACE(REPLACE(@sales, '$', ''), ',', ''),
salesforecast = REPLACE(REPLACE(@salesforecast, '$', ''), ',', '')
;
