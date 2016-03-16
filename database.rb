require 'pg'


puts 'Connecting to the database...'
CONN = PG.connect(
  host: 'localhost',
  dbname: 'contacts',
  user: 'development',
  password: 'development'
  )

