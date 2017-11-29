# How to change the password for postgres user
sudo -i -u postgres
psql
alter user postgres password 'newpassword';
