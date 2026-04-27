CREATE TABLE IF NOT EXISTS rashod_data(
	N_rash varchar(10) not null primary key,
	tovar varchar(20) references tovar(tovar),
	pokup varchar(20) references pokupateli (pokup),
	data_rash date,
	kolvo integer
)