CREATE TABLE dep (depno VARCHAR(20) NOT NULL PRIMARY KEY, 
				  d_name VARCHAR(20));

CREATE TABLE emp (tabno VARCHAR(10) NOT NULL PRIMARY KEY, 
				  depno VARCHAR(20) REFERENCES dep(depno), 
				  e_name VARCHAR(20), 
				  post VARCHAR(20), 
				  salary VARCHAR(20), 
				  born DATE, 
				  tel CHAR(9));

CREATE TABLE children (tabno VARCHAR(10) REFERENCES emp(tabno), 
					   child_name VARCHAR(20), 
					   born DATE, 
					   gender CHAR(1),
					   PRIMARY KEY (tabno, child_name));