CREATE TABLE artist(
	artist_id varchar(10) not null primary key,
	name varchar(50),
	birth_date date,
	style varchar(30));

CREATE TABLE owner(
	pass_num varchar(15) not null primary key,
	name varchar(100),
	city varchar(30),
	street varchar(70),
	house varchar(20),
	apartment varchar(20));

CREATE TABLE painting(
	painting_id varchar(15) not null primary key,
	title varchar(100),
	type varchar(30),
	genre varchar(50),
	price money,
	artist_id varchar(10) references artist(artist_id),
	year integer,
	ownerpass_num varchar(15) references owner(pass_num),
	ownership_date varchar (15));

CREATE TABLE exhibition(
	exhibition_id varchar(10) not null primary key,
	name varchar(100),
	open_date date,
	close_date date,
	place varchar(100));

CREATE TABLE owner_phone(
	pass_num varchar(15) not null references owner(pass_num),
	phone_num varchar(12) not null,
	primary key(pass_num, phone_num));

CREATE TABLE ex_painting(
	exhibition_id varchar(10)references exhibition(exhibition_id),
	painting_id varchar(15) references painting(painting_id),
	primary key(exhibition_id, painting_id));

CREATE TABLE genre_artist(
	artist_id varchar(10) not null references artist(artist_id),
	genre_name varchar(50) not null,
	primary key(artist_id, genre_name));

CREATE TABLE painting_technique(
	painting_id varchar(15) references painting(painting_id),
	technique_name varchar(30) not null,
	primary key(painting_id, technique_name));