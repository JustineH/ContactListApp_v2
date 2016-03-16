require_relative 'database'
require 'pg'
require 'pry'

class Contact

  attr_accessor :name, :email
  attr_reader :id
  
  def self.conn
    CONN
  end

  def initialize(name, email, id=nil)
    @name = name
    @email = email
    @id = id
  end

  def persisted?
    !id.nil?
  end

  def save 
    if persisted?
      Contact.conn.exec_params("UPDATE contacts SET name=$1, email=$2 WHERE id=$3;", [name, email, id])
    else
      result = Contact.conn.exec_params("INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id;", [name, email])
      @id = result[0]["id"]
    end
  end

  def self.create(name, email)
    contact = Contact.new(name, email)
    contact.save
    contact
  end

  def self.find(id)
    result = Contact.conn.exec_params("SELECT * FROM contacts WHERE id=$1 LIMIT 1;", [id])
    return false if result.count == 0
    contact = Contact.new(result[0]["name"], result[0]["email"], result[0]["id"])
    contact
  end

  def self.all
    conn.exec_params("SELECT * FROM contacts").map do |row|
      Contact.new(row["name"],row["email"],row["id"])
    end
  end

  def self.show(id)
    results = Contact.conn.exec_params("SELECT * FROM contacts WHERE id=$1;" [id])
    process_results(results)
  end

  def self.search(key, value)
    results = Contact.conn.exec_params("SELECT * FROM contacts WHERE #{key} ILIKE $1;", ["%#{value}%"])
    process_results(results)
  end

  def self.process_results(results)
    results.map do |contact|
      Contact.new(contact["name"], contact["email"], contact["id"]) 
    end
  end

  def destroy 
    Contact.conn.exec_params("DELETE FROM contacts WHERE id=$1;", [@id])
    self
  end
end

